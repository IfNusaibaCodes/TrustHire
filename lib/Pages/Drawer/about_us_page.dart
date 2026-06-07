import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

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
          'About Us',
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

            _HeroCard(),

            const SizedBox(height: 24),
            _AboutSection(),

            const SizedBox(height: 20),
            _MissionSection(),

            const SizedBox(height: 28),

            _ValuesSection(),

            const SizedBox(height: 28),

            _OffersSection(),

            const SizedBox(height: 24),

            _VersionBadge(),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _AppContent {
  static const appName    = 'Trust Hire';
  static const tagline    = 'Find. Trust. Hire.';
  static const heroSub    = 'Bangladesh\'s trusted job discovery platform';

  static const aboutLabel = 'About Trust Hire';
  static const aboutHeading =
      'Bangladesh\'s most trusted\njob discovery platform';
  static const aboutBody =
      'Trust Hire is built for job seekers who deserve better — '
      'a platform that verifies listings, exposes scams, and gives '
      'you the tools to make confident career decisions. We believe '
      'every person deserves a safe, transparent hiring experience.';

  static const missionBody =
      'Our mission is to make the job search process safer, smarter, '
      'and more transparent for every job seeker in Bangladesh — '
      'removing friction, building trust, and empowering careers.';

  static const values = <_ValueItem>[
    _ValueItem(
      icon: Icons.verified_outlined,
      title: 'Integrity',
      subtitle: 'Upholding honesty in every decision we make',
      color: Color(0xFF4F6EF7),          // brand blue
    ),
    _ValueItem(
      icon: Icons.lightbulb_outline_rounded,
      title: 'Transparency',
      subtitle: 'Showing you exactly what you need to know',
      color: Color(0xFF1A1F36),          // brand navy
    ),
    _ValueItem(
      icon: Icons.shield_outlined,
      title: 'Trust',
      subtitle: 'Verifying every listing so you can apply safely',
      color: Color(0xFF0EA5E9),          // sky blue accent
    ),
    _ValueItem(
      icon: Icons.trending_up_rounded,
      title: 'Empowerment',
      subtitle: 'Equipping you with tools for career success',
      color: Color(0xFF0B2555),          // purple accent
    ),
  ];

  static const offers = <_OfferItem>[
    _OfferItem(icon: Icons.verified_outlined,         label: 'Verified job listings'),
    _OfferItem(icon: Icons.security_outlined,         label: 'Scam detection system'),
    _OfferItem(icon: Icons.menu_book_outlined,        label: 'Career guides & resources'),
    _OfferItem(icon: Icons.calendar_today_outlined,   label: 'Job application planner'),
    _OfferItem(icon: Icons.self_improvement_outlined, label: 'Burnout check-in tool'),
    _OfferItem(icon: Icons.bookmark_outline_rounded,  label: 'Save jobs for later'),
  ];

  static const version = 'v1.0.0';
}


class _HeroCard extends StatelessWidget {
  static const _navy = Color(0xFF1A1F36);
  static const _blue = Color(0xFF4F6EF7);

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
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            child: const Icon(
              Icons.work_outline_rounded,
              color: Colors.white,
              size: 34,
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            _AppContent.appName,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
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
              _AppContent.tagline,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontFamily: 'Poppins',
                letterSpacing: 0.6,
              ),
            ),
          ),

          const SizedBox(height: 14),

          const Text(
            _AppContent.heroSub,
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

class _AboutSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            _AppContent.aboutLabel,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF4F6EF7),
              fontFamily: 'Poppins',
              letterSpacing: 0.4,
            ),
          ),

          const SizedBox(height: 12),
          const Text(
            _AppContent.aboutHeading,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1F36),
              fontFamily: 'Poppins',
              height: 1.3,
            ),
          ),

          const SizedBox(height: 14),

          const Divider(color: Color(0xFFE5E7EB)),

          const SizedBox(height: 14),

          const Text(
            _AppContent.aboutBody,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
              fontFamily: 'Poppins',
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}

class _MissionSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F2FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.flag_outlined,
              size: 22,
              color: Color(0xFF4F6EF7),
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Our Mission',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1F36),
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  _AppContent.missionBody,
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6B7280),
                    fontFamily: 'Poppins',
                    height: 1.6,
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

class _ValuesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        const Center(
          child: Text(
            'Our Values',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1F36),
              fontFamily: 'Poppins',
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Value cards
        ...List.generate(_AppContent.values.length, (i) {
          final v = _AppContent.values[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _ValueCard(item: v),
          );
        }),
      ],
    );
  }
}

class _ValueCard extends StatelessWidget {
  final _ValueItem item;
  const _ValueCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: item.color,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: item.color.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(item.icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.85),
                    fontFamily: 'Poppins',
                    height: 1.4,
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

class _OffersSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F2FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.star_outline_rounded,
                    size: 18, color: Color(0xFF4F6EF7)),
              ),
              const SizedBox(width: 12),
              const Text(
                'What We Offer',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1F36),
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(color: Color(0xFFE5E7EB), height: 1),
          const SizedBox(height: 16),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _AppContent.offers
                .map((o) => _OfferChip(item: o))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _OfferChip extends StatelessWidget {
  final _OfferItem item;
  const _OfferChip({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2FF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD1D5DB)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(item.icon, size: 15, color: const Color(0xFF4F6EF7)),
          const SizedBox(width: 7),
          Text(
            item.label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1F36),
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}
class _VersionBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F2FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.info_outline_rounded,
                size: 18, color: Color(0xFF4F6EF7)),
          ),
          const SizedBox(width: 14),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'App Version',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                  fontFamily: 'Poppins',
                ),
              ),
              Text(
                _AppContent.version,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1F36),
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
              'Up to date',
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

//data models
class _ValueItem {
  final IconData icon;
  final String   title;
  final String   subtitle;
  final Color    color;
  const _ValueItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}

class _OfferItem {
  final IconData icon;
  final String   label;
  const _OfferItem({required this.icon, required this.label});
}