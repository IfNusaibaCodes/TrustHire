-- device_tokens: one row per device FCM registration token, owned by a user.
-- Used by the send-push Edge Function to fan a notification out to a user's devices.
-- Run this in the Supabase dashboard (SQL editor) yourself.

create table if not exists public.device_tokens (
  token       text primary key,
  user_id     uuid not null references auth.users (id) on delete cascade,
  platform    text default 'android',
  updated_at  timestamptz default now()
);

create index if not exists device_tokens_user_id_idx
  on public.device_tokens (user_id);

alter table public.device_tokens enable row level security;

-- A user may only read/write their own device tokens (auth.uid() = user_id).
create policy "device_tokens_select_own"
  on public.device_tokens
  for select
  using (auth.uid() = user_id);

create policy "device_tokens_insert_own"
  on public.device_tokens
  for insert
  with check (auth.uid() = user_id);

create policy "device_tokens_update_own"
  on public.device_tokens
  for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "device_tokens_delete_own"
  on public.device_tokens
  for delete
  using (auth.uid() = user_id);
