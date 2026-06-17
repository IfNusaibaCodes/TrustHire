import 'package:flutter/material.dart';
import 'package:trust_hire_app/Utilities/Constants/colors.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.appBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: TColors.appNavy,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Terms & Conditions',
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
            const _HeroCard(),
            const SizedBox(height: 18),

            const _DateBadge(),
            const SizedBox(height: 20),

            const _IntroCard(),
            const SizedBox(height: 16),

            ..._TcContent.sections.map(
                  (s) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _TcSectionCard(section: s),
              ),
            ),

            const SizedBox(height: 8),
            const _AgreementBanner(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _TcContent {
  static const effectiveDate = 'Effective: January 1, 2025';
  static const lastUpdated   = 'Last updated: June 2025';

  static const intro =
      'TrustHire is a public platform and assumes no liability for the '
      'quality or genuineness of job listings or employer responses. '
      'Users are responsible for conducting their own background checks. '
      'By accessing or using TrustHire, you agree to the following terms.';

  static const sections = <_SectionData>[
    _SectionData(
      icon: Icons.account_circle_outlined,
      title: 'User Accounts',
      points: [
        'You must be at least 16 years old to create a TrustHire account.',
        'You are responsible for maintaining the confidentiality of your login credentials.',
        'You agree to provide accurate and up-to-date information during registration.',
        'TrustHire reserves the right to suspend or terminate accounts that violate these terms.',
        'One person may not maintain more than one active account at a time.',
      ],
    ),
    _SectionData(
      icon: Icons.description_outlined,
      title: 'Profile & CV Display',
      points: [
        'TrustHire allows you to build and display your profile and upload your CV free of cost.',
        'Your profile information can be updated at any time through the app.',
        'TrustHire offers no guarantee that displaying your profile will result in employer responses.',
        'TrustHire does not verify the credentials of employers who view your profile.',
        'You are solely responsible for the accuracy of the information in your profile and CV.',
        'TrustHire reserves the right to remove profiles that contain false or misleading information.',
      ],
    ),
    _SectionData(
      icon: Icons.work_outline_rounded,
      title: 'Job Listings',
      points: [
        'Job listings on TrustHire are sourced from public databases and verified by our team.',
        'TrustHire does not guarantee the accuracy, completeness, or legitimacy of any listing.',
        'Users should independently verify job offers before sharing personal information.',
        'TrustHire is not responsible for any loss incurred as a result of applying to a listing.',
        'Flagging a suspicious listing helps the community — please use the report feature.',
      ],
    ),
    _SectionData(
      icon: Icons.security_outlined,
      title: 'Scam Detection',
      points: [
        'Our scam detection tool provides risk assessments based on available data.',
        'A "safe" result does not guarantee a listing is legitimate — always exercise caution.',
        'TrustHire is not liable for any harm arising from reliance on scam detection results.',
        'Do not share OTPs, bank details, or passwords with any employer through the platform.',
        'Report suspected scams immediately via the in-app report feature or by emailing us.',
      ],
    ),
    _SectionData(
      icon: Icons.block_outlined,
      title: 'Prohibited Activities',
      points: [
        'You may not post false, misleading, or fraudulent job listings or profiles.',
        'Scraping, crawling, or harvesting data from TrustHire without permission is prohibited.',
        'You may not use TrustHire to harass, spam, or send unsolicited messages to other users.',
        'Any attempt to reverse-engineer or tamper with the platform is strictly forbidden.',
        'Sharing your account credentials with others is not permitted.',
      ],
    ),
    _SectionData(
      icon: Icons.copyright_outlined,
      title: 'Intellectual Property',
      points: [
        'All content, branding, and code within TrustHire is the intellectual property of the TrustHire team.',
        'You may not reproduce, distribute, or create derivative works without written permission.',
        'User-submitted content (profile text, reviews) remains the property of the respective user.',
        'By submitting content, you grant TrustHire a non-exclusive licence to display it on the platform.',
      ],
    ),
    _SectionData(
      icon: Icons.gavel_outlined,
      title: 'Limitation of Liability',
      points: [
        'TrustHire is provided "as is" without warranties of any kind, express or implied.',
        'TrustHire is not liable for any direct, indirect, or consequential loss arising from use of the platform.',
        'We are not responsible for the actions of employers, recruiters, or third parties contacted through the app.',
        'In no event shall TrustHire\'s liability exceed the amount paid by you, if any, for using the platform.',
      ],
    ),
    _SectionData(
      icon: Icons.update_rounded,
      title: 'Changes to Terms',
      points: [
        'TrustHire reserves the right to update these Terms & Conditions at any time.',
        'The "Last Updated" date at the top of this page will reflect any changes.',
        'Continued use of TrustHire after changes are posted constitutes acceptance of the new terms.',
        'If you disagree with the updated terms, you should discontinue use of the platform.',
      ],
    ),
  ];
}

class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [TColors.appNavy, TColors.appPrimary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: TColors.appNavy.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(17),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: const Icon(Icons.handshake_outlined,
                color: Colors.white, size: 32),
          ),
          const SizedBox(height: 16),
          const Text(
            'Terms & Conditions',
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
              'Please read carefully before using the app',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontFamily: 'Poppins',
                letterSpacing: 0.3,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'By using TrustHire, you agree to\nthese terms and conditions.',
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
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: TColors.appPrimary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(Icons.calendar_today_outlined,
                size: 18, color: TColors.appPrimary),
          ),
          const SizedBox(width: 14),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _TcContent.effectiveDate,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: TColors.appTextDark,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 2),
              Text(
                _TcContent.lastUpdated,
                style: TextStyle(
                    fontSize: 11, color: TColors.appTextGrey, fontFamily: 'Poppins'),
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

class _IntroCard extends StatelessWidget {
  const _IntroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TColors.appPrimary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TColors.appPrimary.withOpacity(0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, size: 20, color: TColors.appPrimary),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              _TcContent.intro,
              style: TextStyle(
                fontSize: 13,
                color: TColors.appTextDark,
                fontFamily: 'Poppins',
                height: 1.65,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TcSectionCard extends StatefulWidget {
  final _SectionData section;
  const _TcSectionCard({required this.section});

  @override
  State<_TcSectionCard> createState() => _TcSectionCardState();
}

class _TcSectionCardState extends State<_TcSectionCard> {
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
          border: Border(
            left: BorderSide(
              color: _open ? TColors.appPrimary : Colors.transparent,
              width: 4,
            ),
          ),
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
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: _open
                        ? TColors.appPrimary.withOpacity(0.10)
                        : TColors.appBackground,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(
                    widget.section.icon,
                    size: 19,
                    color: _open ? TColors.appPrimary : TColors.appTextGrey,
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
                      color: _open ? TColors.appTextDark : const Color(0xFF374151),
                    ),
                  ),
                ),
                // Point count pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _open
                        ? TColors.appPrimary.withOpacity(0.10)
                        : TColors.appBackground,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${widget.section.points.length}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _open ? TColors.appPrimary : TColors.appTextGrey,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedRotation(
                  turns: _open ? 0.5 : 0,
                  duration: const Duration(milliseconds: 220),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: _open ? TColors.appPrimary : TColors.appTextGrey,
                    size: 22,
                  ),
                ),
              ],
            ),


            if (_open) ...[
              const SizedBox(height: 14),
              Divider(color: TColors.appPrimary.withOpacity(0.12), height: 1),
              const SizedBox(height: 12),
              ...widget.section.points.asMap().entries.map(
                    (entry) => _NumberedPoint(
                  number: entry.key + 1,
                  text: entry.value,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NumberedPoint extends StatelessWidget {
  final int    number;
  final String text;
  const _NumberedPoint({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.only(top: 1),
            decoration: BoxDecoration(
              color: TColors.appPrimary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Center(
              child: Text(
                '$number',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: TColors.appPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF4B5563),
                fontFamily: 'Poppins',
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class _AgreementBanner extends StatelessWidget {
  const _AgreementBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [TColors.appNavy, TColors.appPrimary.withOpacity(0.85)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: TColors.appNavy.withOpacity(0.20),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(Icons.verified_outlined,
                color: Colors.white, size: 24),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'You agree to these terms',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'By continuing to use TrustHire, you accept all of the above terms and conditions.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontFamily: 'Poppins',
                    height: 1.5,
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

class _SectionData {
  final IconData     icon;
  final String       title;
  final List<String> points;
  const _SectionData({
    required this.icon,
    required this.title,
    required this.points,
  });
}