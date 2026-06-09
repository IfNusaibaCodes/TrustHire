import 'package:flutter/material.dart';

class RedFlagsPage extends StatelessWidget {
  const RedFlagsPage({super.key});

  static const _navy    = Color(0xFF1A1F36);
  static const _bg      = Color(0xFFF5F7FA);

  static const _flags = [
    _RedFlag(
      icon:  Icons.payments_outlined,
      color: Color(0xFFEF4444),
      title: 'Upfront Payment Requests',
      desc:  'Legitimate employers never ask you to pay for training, equipment, or background checks before you start.',
    ),
    _RedFlag(
      icon:  Icons.attach_money_rounded,
      color: Color(0xFFF97316),
      title: 'Unrealistic Salary Offers',
      desc:  'If the pay seems too high for simple or vague work, it\'s a trap. Scammers use big numbers to lure victims.',
    ),
    _RedFlag(
      icon:  Icons.person_outline_rounded,
      color: Color(0xFF8B5CF6),
      title: 'Personal Info Requested Too Early',
      desc:  'Asking for your ID, bank details, or passport before any interview is a major red flag.',
    ),
    _RedFlag(
      icon:  Icons.email_outlined,
      color: Color(0xFF3B82F6),
      title: 'Gmail or Yahoo Company Emails',
      desc:  'Real companies use their own domain (e.g. hr@company.com). A Gmail or Yahoo address means the company is likely fake.',
    ),
    _RedFlag(
      icon:  Icons.timer_outlined,
      color: Color(0xFFEC4899),
      title: 'Urgency Pressure',
      desc:  '"Apply within 24 hours or lose the opportunity." Scammers create fake urgency to stop you from thinking carefully.',
    ),
    _RedFlag(
      icon:  Icons.how_to_reg_outlined,
      color: Color(0xFF10B981),
      title: 'Instant Job Offer, No Interview',
      desc:  'Getting hired without any interview or screening process is highly suspicious. Real jobs require some verification.',
    ),
    _RedFlag(
      icon:  Icons.description_outlined,
      color: Color(0xFFF59E0B),
      title: 'Vague Job Description',
      desc:  'If the role is described as "data entry", "package handler", or "online assistant" with no real details, be cautious.',
    ),
    _RedFlag(
      icon:  Icons.home_work_outlined,
      color: Color(0xFF06B6D4),
      title: 'Work-From-Home With No Company Details',
      desc:  'Remote jobs are real, but scam postings have no company website, address, or verifiable contact information.',
    ),
    _RedFlag(
      icon:  Icons.spellcheck_rounded,
      color: Color(0xFF6366F1),
      title: 'Poor Spelling and Grammar',
      desc:  'Official job offers from real companies are professionally written. Multiple errors suggest a scam or foreign fraud operation.',
    ),
    _RedFlag(
      icon:  Icons.search_off_rounded,
      color: Color(0xFF14B8A6),
      title: 'Company Not Found Online',
      desc:  'If you can\'t find the company on Google, LinkedIn, or any official directory, it most likely does not exist.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _navy,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Red Flags Guide',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, letterSpacing: 0.4)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Header banner ───────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [_navy, Color(0xFF4F6EF7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Know the Warning Signs',
                            style: TextStyle(color: Colors.white,
                                fontSize: 18, fontWeight: FontWeight.w800)),
                        SizedBox(height: 6),
                        Text('Patterns used in almost every job scam.',
                            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.warning_amber_rounded,
                        color: Colors.amber, size: 30),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Flag cards ──────────────────────────────
            ...List.generate(_flags.length, (i) => _FlagCard(
              number: i + 1,
              flag: _flags[i],
            )),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ── Data class ─────────────────────────────────────────────────
class _RedFlag {
  final IconData icon;
  final Color    color;
  final String   title;
  final String   desc;
  const _RedFlag({required this.icon, required this.color,
      required this.title, required this.desc});
}

// ── Flag card ──────────────────────────────────────────────────
class _FlagCard extends StatelessWidget {
  final int      number;
  final _RedFlag flag;

  const _FlagCard({required this.number, required this.flag});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Icon circle
          Container(
            width: 46, height: 46,
            decoration: BoxDecoration(
              color: flag.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(flag.icon, color: flag.color, size: 22),
          ),
          const SizedBox(width: 14),

          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 20, height: 20,
                      decoration: BoxDecoration(
                        color: flag.color.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text('$number',
                            style: TextStyle(fontSize: 10,
                                fontWeight: FontWeight.w800, color: flag.color)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(flag.title,
                          style: const TextStyle(fontSize: 14,
                              fontWeight: FontWeight.w700, color: Color(0xFF1A1F36))),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(flag.desc,
                    style: const TextStyle(fontSize: 13,
                        color: Color(0xFF6B7280), height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
