// ─────────────────────────────────────────────────────────────────────────────
// send-push  —  Supabase Edge Function (Deno + TypeScript)
//
// Fans an inserted `public.notifications` row out to the targeted users' devices
// via Firebase Cloud Messaging (FCM HTTP v1).
//
// ── Required secret ──────────────────────────────────────────────────────────
//   FCM_SERVICE_ACCOUNT
//     The FULL Firebase service-account JSON (the file you download from
//     Firebase console → Project settings → Service accounts → Generate new
//     private key). Must include client_email, private_key, token_uri, project_id.
//     Set it (do NOT commit the file) with either:
//       supabase secrets set FCM_SERVICE_ACCOUNT="$(cat service-account.json)"
//     or paste the JSON in: Dashboard → Edge Functions → send-push → Secrets.
//
//   SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY are auto-injected by the platform.
//   Do NOT set them yourself.
//
// ── Database webhook setup (Dashboard → Database → Webhooks → Create) ─────────
//   Name:    send_push_on_notification
//   Table:   public.notifications
//   Events:  Insert
//   Type:    Supabase Edge Functions  →  send-push
//   The webhook POSTs a JSON body: { type, table, schema, record, old_record }.
//
// Deploy:  supabase functions deploy send-push     (or via the Dashboard editor)
// ─────────────────────────────────────────────────────────────────────────────

import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

interface ServiceAccount {
  client_email: string;
  private_key: string;
  token_uri: string;
  project_id: string;
}

interface NotificationRecord {
  id: string;
  title: string;
  body: string;
  type?: string | null;
  target_role?: string | null;
  target_university?: string | null;
  target_study_year?: string | null;
}

// ── OAuth: mint a short-lived access token from the service-account JWT ───────
// RS256 signing with Web Crypto only — no external JWT/crypto deps.

function base64url(input: ArrayBuffer | string): string {
  const bytes =
    typeof input === 'string'
      ? new TextEncoder().encode(input)
      : new Uint8Array(input);
  let binary = '';
  for (const b of bytes) binary += String.fromCharCode(b);
  return btoa(binary).replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '');
}

function pemToDer(pem: string): ArrayBuffer {
  const body = pem
    .replace(/-----BEGIN PRIVATE KEY-----/, '')
    .replace(/-----END PRIVATE KEY-----/, '')
    .replace(/\s+/g, '');
  const binary = atob(body);
  const bytes = new Uint8Array(binary.length);
  for (let i = 0; i < binary.length; i++) bytes[i] = binary.charCodeAt(i);
  return bytes.buffer;
}

async function getAccessToken(sa: ServiceAccount): Promise<string> {
  const now = Math.floor(Date.now() / 1000);
  const header = { alg: 'RS256', typ: 'JWT' };
  const claim = {
    iss: sa.client_email,
    scope: 'https://www.googleapis.com/auth/firebase.messaging',
    aud: sa.token_uri,
    iat: now,
    exp: now + 3600,
  };

  const unsigned =
    `${base64url(JSON.stringify(header))}.${base64url(JSON.stringify(claim))}`;

  const key = await crypto.subtle.importKey(
    'pkcs8',
    pemToDer(sa.private_key),
    { name: 'RSASSA-PKCS1-v1_5', hash: 'SHA-256' },
    false,
    ['sign'],
  );
  const signature = await crypto.subtle.sign(
    'RSASSA-PKCS1-v1_5',
    key,
    new TextEncoder().encode(unsigned),
  );
  const jwt = `${unsigned}.${base64url(signature)}`;

  const res = await fetch(sa.token_uri, {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({
      grant_type: 'urn:ietf:params:oauth:grant-type:jwt-bearer',
      assertion: jwt,
    }),
  });
  if (!res.ok) {
    throw new Error(`OAuth token request failed: ${res.status} ${await res.text()}`);
  }
  const json = await res.json();
  return json.access_token as string;
}

function jsonResponse(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { 'Content-Type': 'application/json' },
  });
}

Deno.serve(async (req) => {
  try {
    const payload = await req.json();
    const record: NotificationRecord | undefined = payload?.record;
    if (!record?.id) {
      return jsonResponse({ error: 'No notification record in payload' }, 400);
    }

    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
    );

    // ── 1. Resolve the audience from `profiles` ──────────────────────────────
    // null target field = everyone; non-null = must match (mirrors the app's
    // NotificationModel.matchesAudience). profiles has NO generic role column,
    // so only target_role === 'admin' is handled; other role values are ignored.
    let profileQuery = supabase.from('profiles').select('id');
    if (record.target_university) {
      profileQuery = profileQuery.eq('university', record.target_university);
    }
    if (record.target_study_year) {
      profileQuery = profileQuery.eq('study_year', record.target_study_year);
    }
    if (record.target_role === 'admin') {
      profileQuery = profileQuery.eq('is_admin', true);
    }

    const { data: profiles, error: profErr } = await profileQuery;
    if (profErr) throw profErr;

    const userIds = (profiles ?? []).map((p: { id: string }) => p.id);
    if (userIds.length === 0) return jsonResponse({ sent: 0, pruned: 0 });

    // ── 2. Collect the device tokens for those users ─────────────────────────
    const { data: tokenRows, error: tokErr } = await supabase
      .from('device_tokens')
      .select('token')
      .in('user_id', userIds);
    if (tokErr) throw tokErr;

    const tokens = (tokenRows ?? []).map((t: { token: string }) => t.token);
    if (tokens.length === 0) return jsonResponse({ sent: 0, pruned: 0 });

    // ── 3. Send via FCM HTTP v1 (one message per token) ──────────────────────
    const sa: ServiceAccount = JSON.parse(Deno.env.get('FCM_SERVICE_ACCOUNT')!);
    const accessToken = await getAccessToken(sa);
    const endpoint =
      `https://fcm.googleapis.com/v1/projects/${sa.project_id}/messages:send`;

    let sent = 0;
    const staleTokens: string[] = [];

    await Promise.all(
      tokens.map(async (token) => {
        const message = {
          message: {
            token,
            notification: { title: record.title, body: record.body },
            data: {
              type: record.type ?? 'general',
              notification_id: record.id,
            },
            android: { priority: 'high' },
          },
        };

        const res = await fetch(endpoint, {
          method: 'POST',
          headers: {
            Authorization: `Bearer ${accessToken}`,
            'Content-Type': 'application/json',
          },
          body: JSON.stringify(message),
        });

        if (res.ok) {
          sent++;
        } else if (res.status === 404 || res.status === 400) {
          // 404 = token unregistered; 400 = invalid/unregistered token.
          // (A 400 can also signal a malformed message — check the response body
          //  during development if sends unexpectedly fail.)
          staleTokens.push(token);
        }
        // 401/429/5xx are auth/transient errors — leave those tokens in place.
      }),
    );

    // ── 4. Prune stale tokens ────────────────────────────────────────────────
    let pruned = 0;
    if (staleTokens.length > 0) {
      const { error: delErr } = await supabase
        .from('device_tokens')
        .delete()
        .in('token', staleTokens);
      if (!delErr) pruned = staleTokens.length;
    }

    return jsonResponse({ sent, pruned });
  } catch (err) {
    return jsonResponse({ error: String(err) }, 500);
  }
});
