import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PRIVACY POLICY PAGE  —  TrustHire
// Colours & style pulled directly from profile_widgets.dart + job_feed_page.dart:
//   primary  = Color(0xFF3B5BDB)
//   bgColor  = Color(0xFFF5F6FA)
//   appBar   = Color(0xFF1A1F36)  (same as job_feed_page AppBar)
// Structure:
//   1. Hero card  (navy→primary gradient, same as about_us_page hero)
//   2. Effective date badge  (white card, like profileCard)
//   3. Expandable policy sections  (tap to open, left-border highlight)
//   4. Your Rights  (coloured chips, same wrap style as profile skills)
//   5. Contact note  (tinted info banner, like response note in contact_us)
// All content lives in _PolicyContent — nowhere else.
// ─────────────────────────────────────────────────────────────────────────────

// ── Shared colour tokens (mirrors profile_widgets.dart) ───────────────────
const Color _primary  = Color(0xFF3B5BDB);
const Color _bgColor  = Color(0xFFF5F6FA);
const Color _textDark = Color(0xFF1A1A2E);
const Color _textGrey = Color(0xFF9CA3AF);
const Color _navy     = Color(0xFF1A1F36);

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: _navy,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
            letterSpacing: 0.4,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── 1. HERO ──────────────────────────────────────────
            const _HeroCard(),

            const SizedBox(height: 18),

            // ── 2. EFFECTIVE DATE ────────────────────────────────
            const _DateBadge(),

            const SizedBox(height: 20),

            // ── 3. EXPANDABLE SECTIONS ───────────────────────────
            ..._PolicyContent.sections.map(
                  (s) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _PolicyCard(section: s),
              ),
            ),

            const SizedBox(height: 8),

            // ── 4. YOUR RIGHTS ───────────────────────────────────
            const _RightsCard(),

            const SizedBox(height: 16),

            // ── 5. CONTACT NOTE ──────────────────────────────────
            const _ContactNote(),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// CONTENT  ← update text here only
// ═════════════════════════════════════════════════════════════════════════════

class _PolicyContent {
  static const effectiveDate = 'Effective: January 1, 2025';
  static const lastUpdated   = 'Last updated: June 2025';
  static const contactEmail  = 'trusthire.team@gmail.com';

  static const sections = <_SectionData>[
    _SectionData(
      icon: Icons.info_outline_rounded,
      title: 'Information We Collect',
      body:
      'We collect information you provide directly — such as your name, '
          'email address, and profile details — when you register or use '
          'TrustHire. We may also collect usage data (pages visited, features '
          'used) to improve your experience. We do not collect sensitive '
          'personal data beyond what is necessary to operate the platform.',
    ),
    _SectionData(
      icon: Icons.settings_suggest_outlined,
      title: 'How We Use Your Information',
      body:
      'Your information is used to personalise your job search experience, '
          'send important account notifications, detect and prevent scam '
          'listings, and improve our platform. We never sell your personal '
          'data to third parties. Aggregate, anonymised analytics may be used '
          'to understand platform trends.',
    ),
    _SectionData(
      icon: Icons.share_outlined,
      title: 'Information Sharing',
      body:
      'We do not share your personal information with external parties '
          'except where required by law or with service providers who help us '
          'operate TrustHire (e.g. cloud hosting). All third-party partners '
          'are contractually bound to protect your data and may not use it for '
          'their own purposes.',
    ),
    _SectionData(
      icon: Icons.lock_outline_rounded,
      title: 'Data Security',
      body:
      'We implement industry-standard security measures — including '
          'encryption in transit and at rest — to protect your data. While no '
          'system is completely immune to risks, we continuously monitor and '
          'update our security practices to keep your information safe.',
    ),
    _SectionData(
      icon: Icons.cookie_outlined,
      title: 'Cookies & Tracking',
      body:
      'TrustHire uses cookies and similar technologies to remember your '
          'preferences and analyse usage patterns. You can control cookie '
          'settings through your device. Disabling cookies may affect some '
          'features of the app.',
    ),
    _SectionData(
      icon: Icons.child_care_outlined,
      title: 'Children\'s Privacy',
      body:
      'TrustHire is not intended for users under the age of 16. We do '
          'not knowingly collect personal information from minors. If you '
          'believe a minor has provided us with their data, please contact us '
          'and we will promptly delete it.',
    ),
    _SectionData(
      icon: Icons.update_rounded,
      title: 'Changes to This Policy',
      body:
      'We may update this Privacy Policy from time to time. When we do, '
          'the "Last Updated" date at the top will change. We encourage you '
          'to review this page periodically. Continued use of TrustHire after '
          'changes are posted means you accept the updated policy.',
    ),
  ];

  static const rights = <_RightData>[
    _RightData(icon: Icons.visibility_outlined,      label: 'Access your data'),
    _RightData(icon: Icons.edit_outlined,            label: 'Correct inaccuracies'),
    _RightData(icon: Icons.delete_outline_rounded,   label: 'Request deletion'),
    _RightData(icon: Icons.block_outlined,           label: 'Opt out of marketing'),
  ];
}

// ═════════════════════════════════════════════════════════════════════════════
// WIDGETS
// ═════════════════════════════════════════════════════════════════════════════

/// 1. Hero — navy→primary gradient, mirrors about_us_page._HeroCard
class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_navy, _primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: _navy.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Icon badge
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(17),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: const Icon(Icons.shield_outlined,
                color: Colors.white, size: 32),
          ),
          const SizedBox(height: 16),
          const Text(
            'Privacy Policy',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              fontFamily: 'Poppins',
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Your data, your rights',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontFamily: 'Poppins',
                letterSpacing: 0.4,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'We are committed to protecting your privacy\nand being transparent about how we use\nyour information.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white60,
              fontSize: 12,
              fontFamily: 'Poppins',
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

/// 2. Effective date badge — same white-card style as profileCard
class _DateBadge extends StatelessWidget {
  const _DateBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(Icons.calendar_today_outlined,
                size: 18, color: _primary),
          ),
          const SizedBox(width: 14),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _PolicyContent.effectiveDate,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _textDark,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 2),
              Text(
                _PolicyContent.lastUpdated,
                style: TextStyle(
                  fontSize: 11,
                  color: _textGrey,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Current',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF16A34A),
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 3. Expandable policy section — white card, left border on expand
class _PolicyCard extends StatefulWidget {
  final _SectionData section;
  const _PolicyCard({required this.section});

  @override
  State<_PolicyCard> createState() => _PolicyCardState();
}

class _PolicyCardState extends State<_PolicyCard> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _open = !_open),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: _open
              ? Border(left: BorderSide(color: _primary, width: 4))
              : Border(left: BorderSide(color: Colors.transparent, width: 4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: _open
                        ? _primary.withOpacity(0.10)
                        : _bgColor,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(
                    widget.section.icon,
                    size: 19,
                    color: _open ? _primary : _textGrey,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.section.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                      color: _open ? _textDark : const Color(0xFF374151),
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: _open ? 0.5 : 0,
                  duration: const Duration(milliseconds: 220),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: _open ? _primary : _textGrey,
                    size: 22,
                  ),
                ),
              ],
            ),
            // Body
            if (_open) ...[
              const SizedBox(height: 14),
              Divider(color: _primary.withOpacity(0.12), height: 1),
              const SizedBox(height: 12),
              Text(
                widget.section.body,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF4B5563),
                  fontFamily: 'Poppins',
                  height: 1.7,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 4. Your Rights — white card with primary-tinted chips (like profile skills)
class _RightsCard extends StatelessWidget {
  const _RightsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header (mirrors profile_widgets sectionHeader style)
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: _primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(Icons.gavel_outlined,
                    size: 19, color: _primary),
              ),
              const SizedBox(width: 12),
              const Text(
                'Your Rights',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins',
                  color: _textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Padding(
            padding: EdgeInsets.only(left: 2),
            child: Text(
              'Under our policy you have the right to:',
              style: TextStyle(
                fontSize: 12,
                color: _textGrey,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          const SizedBox(height: 14),
          Divider(color: _primary.withOpacity(0.10), height: 1),
          const SizedBox(height: 14),
          // Rights chips — same wrap style as profile skills
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _PolicyContent.rights
                .map((r) => _RightChip(data: r))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _RightChip extends StatelessWidget {
  final _RightData data;
  const _RightChip({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: _primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _primary.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(data.icon, size: 15, color: _primary),
          const SizedBox(width: 7),
          Text(
            data.label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _primary,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}

/// 5. Contact note — tinted banner, same feel as contact_us _ResponseNote
class _ContactNote extends StatelessWidget {
  const _ContactNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _primary.withOpacity(0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.mail_outline_rounded,
              size: 20, color: _primary),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Questions about this policy?',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _textDark,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Reach out to us at:',
                  style: TextStyle(
                    fontSize: 12,
                    color: _textGrey,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  _PolicyContent.contactEmail,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _primary,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// DATA MODELS
// ═════════════════════════════════════════════════════════════════════════════

class _SectionData {
  final IconData icon;
  final String   title;
  final String   body;
  const _SectionData({
    required this.icon,
    required this.title,
    required this.body,
  });
}

class _RightData {
  final IconData icon;
  final String   label;
  const _RightData({required this.icon, required this.label});
}