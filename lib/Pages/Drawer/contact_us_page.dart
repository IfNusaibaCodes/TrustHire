import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'feedback_support_page.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CONTACT US PAGE
// Structure:
//   1. Hero card (same style as About Us)
//   2. Email Us card — tap to copy
//   3. Find Us On Social — Facebook + LinkedIn
//   4. Response time note
//   5. Send a Message button → FeedbackSupportPage
// No phone numbers, no fake address — clean & professional for a defense.
// ─────────────────────────────────────────────────────────────────────────────

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  static const _navy = Color(0xFF1A1F36);
  static const _blue = Color(0xFF4F6EF7);
  static const _bg   = Color(0xFFF5F7FA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: _navy,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Contact Us',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
            letterSpacing: 0.4,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── 1. HERO ───────────────────────────────────────────
            _HeroCard(),

            const SizedBox(height: 24),

            // ── 2. EMAIL US ───────────────────────────────────────
            _EmailCard(context),

            const SizedBox(height: 16),

            // ── 3. SOCIAL LINKS ───────────────────────────────────
            _SocialSection(),

            const SizedBox(height: 16),

            // ── 4. RESPONSE TIME ──────────────────────────────────
            _ResponseNote(),

            const SizedBox(height: 24),


          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// CONTENT  ← only change text here
// ═════════════════════════════════════════════════════════════════════════════

class _ContactContent {
  static const email       = 'trusthire.team@gmail.com';  //email change korbo
  static const facebookUrl = 'https://facebook.com/trusthire';   // update when you have a page
  static const linkedinUrl = 'https://linkedin.com/company/trusthire'; //pore add korbo
  static const responseTime = 'We typically respond within 24–48 hours.';
  static const availability = 'Available Sunday to Thursday';
}

// ═════════════════════════════════════════════════════════════════════════════
// SECTION WIDGETS
// ═════════════════════════════════════════════════════════════════════════════

/// 1. Hero — same gradient style as About Us hero
class _HeroCard extends StatelessWidget {
  static const _navy = Color(0xFF1A1F36);
  static const _blue = Color(0xFF0B2555);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_navy, _blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _navy.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon badge
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: const Icon(
              Icons.contact_support_outlined,
              color: Colors.white,
              size: 34,
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            'Get In Touch',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
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
              'We\'d love to hear from you',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontFamily: 'Poppins',
                letterSpacing: 0.4,
              ),
            ),
          ),

          const SizedBox(height: 14),

          const Text(
            'Reach out any time — our team is\nalways happy to help.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white60,
              fontSize: 13,
              fontFamily: 'Poppins',
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// 2. Email card — tap to copy email to clipboard
Widget _EmailCard(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Clipboard.setData(
        const ClipboardData(text: _ContactContent.email),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Email copied to clipboard!'),
          backgroundColor: const Color(0xFF1A1F36),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    },
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: const Border(
          left: BorderSide(color: Color(0xFF4F6EF7), width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F2FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.email_outlined,
              color: Color(0xFF4F6EF7),
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Email Us',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6B7280),
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  _ContactContent.email,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1F36),
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F2FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.copy_rounded, size: 13, color: Color(0xFF4F6EF7)),
                SizedBox(width: 4),
                Text(
                  'Copy',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4F6EF7),
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

/// 3. Social links section — Facebook + LinkedIn cards
class _SocialSection extends StatelessWidget {
  static const _navy = Color(0xFF1A1F36);
  static const _blue = Color(0xFF4F6EF7);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'Find Us On Social',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1F36),
              fontFamily: 'Poppins',
            ),
          ),
        ),

        // Facebook card
        _SocialCard(
          icon: Icons.facebook_rounded,
          platformName: 'Facebook',
          handle: '@TrustHire',
          cardColor: const Color(0xFF1877F2),
          onTap: () => _showComingSoon(context, 'Facebook'),
        ),

        const SizedBox(height: 12),

        // LinkedIn card
        _SocialCard(
          icon: Icons.work_rounded,
          platformName: 'LinkedIn',
          handle: 'Trust Hire',
          cardColor: const Color(0xFF0A66C2),
          onTap: () => _showComingSoon(context, 'LinkedIn'),
        ),
      ],
    );
  }

  void _showComingSoon(BuildContext context, String platform) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$platform page coming soon!'),
        backgroundColor: const Color(0xFF1A1F36),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class _SocialCard extends StatelessWidget {
  final IconData  icon;
  final String    platformName;
  final String    handle;
  final Color     cardColor;
  final VoidCallback onTap;

  const _SocialCard({
    required this.icon,
    required this.platformName,
    required this.handle,
    required this.cardColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: cardColor.withOpacity(0.30),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    platformName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    handle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.80),
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
                size: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 4. Response time note
class _ResponseNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD1D5DB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.access_time_rounded,
              size: 18, color: Color(0xFF4F6EF7)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  _ContactContent.responseTime,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1F36),
                    fontFamily: 'Poppins',
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  _ContactContent.availability,
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
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

