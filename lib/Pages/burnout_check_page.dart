// ============================================================
//  FILE: lib/Pages/burnout_check_page.dart
// ============================================================
//
//  ── SUPABASE TABLE ────────────────────────────────────────
//  Run this ONCE in: Supabase Dashboard → SQL Editor → Run
//
//  create table burnout_checks (
//    id               uuid default gen_random_uuid() primary key,
//    user_id          uuid references auth.users(id),
//    answer           text not null,
//    question_number  int not null,
//    question_text    text not null,
//    created_at       timestamp default now()
//  );
//
//  ── IMAGES ────────────────────────────────────────────────
//  All images are inside: assets/images/burnedout_images/
//  File names must match EXACTLY:
//    exhausted.png.png
//    stress.png.png
//    motivation.png.png
//    team.png.png
//    overall.png.png
//    balance.png.png
//    sleep.png.png
//
//  ── SUPABASE REQUIREMENTS ─────────────────────────────────
//  pubspec.yaml:  supabase_flutter: ^2.0.0  ✅ already added
//  main.dart:     Supabase.initialize(url: '...', anonKey: '...')
//
// ============================================================

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BurnoutPage extends StatefulWidget {
  const BurnoutPage({super.key});

  @override
  State<BurnoutPage> createState() => _BurnoutPageState();
}

class _BurnoutPageState extends State<BurnoutPage> {

  final supabase = Supabase.instance.client;
  final Map<int, int> selectedAnswers = {};
  final PageController _pageController = PageController();
  int currentPage = 0;
  bool isSaving = false;

  static const Color primary  = Color(0xFF7C3AED);
  static const Color bgColor  = Color(0xFFF8F7FF);
  static const Color textDark = Color(0xFF1E1B4B);
  static const Color textGrey = Color(0xFF9CA3AF);

  final List<Map<String, dynamic>> questions = [
    {
      'questionNumber': 1,
      'question': 'How exhausted have you felt this week?',
      'image': 'assets/images/burnedout_images/exhausted.png.png',
      'icon': Icons.battery_alert_rounded,
      'options': [
        {'icon': Icons.local_fire_department_rounded, 'label': 'Burned Out', 'color': Color(0xFFEF4444)},
        {'icon': Icons.cloud_rounded,                 'label': 'Tired',      'color': Color(0xFFF59E0B)},
        {'icon': Icons.wb_sunny_rounded,              'label': 'Good',       'color': Color(0xFF10B981)},
        {'icon': Icons.stars_rounded,                 'label': 'Great',      'color': Color(0xFF7C3AED)},
      ],
    },
    {
      'questionNumber': 2,
      'question': 'What is your stress level right now?',
      'image': 'assets/images/burnedout_images/stress.png.png',
      'icon': Icons.psychology_rounded,
      'options': [
        {'icon': Icons.warning_amber_rounded,         'label': 'Very High',  'color': Color(0xFFEF4444)},
        {'icon': Icons.trending_up_rounded,           'label': 'High',       'color': Color(0xFFF59E0B)},
        {'icon': Icons.trending_down_rounded,         'label': 'Low',        'color': Color(0xFF10B981)},
        {'icon': Icons.check_circle_rounded,          'label': 'None',       'color': Color(0xFF7C3AED)},
      ],
    },
    {
      'questionNumber': 3,
      'question': 'How motivated do you feel about your work?',
      'image': 'assets/images/burnedout_images/motivation.png.png',
      'icon': Icons.rocket_launch_rounded,
      'options': [
        {'icon': Icons.do_not_disturb_rounded,        'label': 'Not At All', 'color': Color(0xFFEF4444)},
        {'icon': Icons.battery_1_bar_rounded,         'label': 'A Little',   'color': Color(0xFFF59E0B)},
        {'icon': Icons.bolt_rounded,                  'label': 'Motivated',  'color': Color(0xFF10B981)},
        {'icon': Icons.rocket_launch_rounded,         'label': 'Very Much',  'color': Color(0xFF7C3AED)},
      ],
    },
    {
      'questionNumber': 4,
      'question': 'How connected do you feel with your team?',
      'image': 'assets/images/burnedout_images/team.png.png',
      'icon': Icons.people_rounded,
      'options': [
        {'icon': Icons.person_off_rounded,            'label': 'Isolated',   'color': Color(0xFFEF4444)},
        {'icon': Icons.person_rounded,                'label': 'Distant',    'color': Color(0xFFF59E0B)},
        {'icon': Icons.handshake_rounded,             'label': 'Connected',  'color': Color(0xFF10B981)},
        {'icon': Icons.favorite_rounded,              'label': 'Very Close', 'color': Color(0xFF7C3AED)},
      ],
    },
    {
      'questionNumber': 5,
      'question': 'How is your work-life balance this week?',
      'image': 'assets/images/burnedout_images/balance.png.png',
      'icon': Icons.balance_rounded,
      'options': [
        {'icon': Icons.running_with_errors_rounded,   'label': 'No Balance', 'color': Color(0xFFEF4444)},
        {'icon': Icons.compare_arrows_rounded,        'label': 'Struggling', 'color': Color(0xFFF59E0B)},
        {'icon': Icons.balance_rounded,               'label': 'Managing',   'color': Color(0xFF10B981)},
        {'icon': Icons.verified_rounded,              'label': 'Balanced',   'color': Color(0xFF7C3AED)},
      ],
    },
    {
      'questionNumber': 6,
      'question': 'How well have you been sleeping?',
      'image': 'assets/images/burnedout_images/sleep.png.png',
      'icon': Icons.bedtime_rounded,
      'options': [
        {'icon': Icons.nights_stay_rounded,           'label': 'Very Poor',  'color': Color(0xFFEF4444)},
        {'icon': Icons.battery_2_bar_rounded,         'label': 'Poor',       'color': Color(0xFFF59E0B)},
        {'icon': Icons.bedtime_rounded,               'label': 'Okay',       'color': Color(0xFF10B981)},
        {'icon': Icons.star_rounded,                  'label': 'Great',      'color': Color(0xFF7C3AED)},
      ],
    },
    {
      'questionNumber': 7,
      'question': 'Overall, how are you feeling today?',
      'image': 'assets/images/burnedout_images/overall.png.png',
      'icon': Icons.favorite_rounded,
      'options': [
        {'icon': Icons.sentiment_very_dissatisfied_rounded, 'label': 'Not Good', 'color': Color(0xFFEF4444)},
        {'icon': Icons.sentiment_neutral_rounded,           'label': 'Okay',     'color': Color(0xFFF59E0B)},
        {'icon': Icons.sentiment_satisfied_rounded,         'label': 'Good',     'color': Color(0xFF10B981)},
        {'icon': Icons.sentiment_very_satisfied_rounded,    'label': 'Amazing',  'color': Color(0xFF7C3AED)},
      ],
    },
  ];

  final List<Map<String, dynamic>> suggestions = [
    {'icon': Icons.coffee_outlined,  'color': Color(0xFF7C3AED), 'title': 'Power Break',    'subtitle': 'A 15-min disconnect to reset.'},
    {'icon': Icons.directions_walk,  'color': Color(0xFF10B981), 'title': 'Fresh Air Walk', 'subtitle': 'Step outside for 10 minutes.'},
    {'icon': Icons.no_cell_outlined, 'color': Color(0xFFEF4444), 'title': 'Screen Limit',   'subtitle': 'Reduce blue light exposure.'},
  ];

  Future<void> saveAllAnswers() async {
    if (selectedAnswers.length < questions.length) {
      showMessage('Please answer all questions!', isError: true);
      return;
    }

    setState(() => isSaving = true);

    try {
      // TEMPORARY for frontend testing — replace with real auth later
      final userId = supabase.auth.currentUser?.id ?? 'test-user-123';

      final List<Map<String, dynamic>> rows = [];
      for (int i = 0; i < questions.length; i++) {
        final q = questions[i];
        final int optIndex = selectedAnswers[i]!;
        final String answer =
        (q['options'] as List)[optIndex]['label'] as String;

        rows.add({
          'user_id':         userId,
          'answer':          answer,
          'question_number': q['questionNumber'],
          'question_text':   q['question'],
        });
      }

      await supabase.from('burnout_checks').insert(rows);

      showMessage('Check-in complete! 🎉');
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) Navigator.pop(context);

    } catch (e) {
      showMessage('Error: $e', isError: true);
    }

    if (mounted) setState(() => isSaving = false);
  }

  void showMessage(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: isError ? const Color(0xFFEF4444) : const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [

            // ── TOP BAR ───────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: Row(
                children: [
                  _CircleButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Burnout Check',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: textDark)),
                        Text('How are you holding up?',
                            style: TextStyle(fontSize: 12, color: textGrey)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${currentPage + 1} / ${questions.length}',
                      style: const TextStyle(
                          color: primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── PROGRESS BAR ──────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Question ${currentPage + 1} of ${questions.length}',
                          style: const TextStyle(color: textGrey, fontSize: 12)),
                      Text('${((currentPage + 1) / questions.length * 100).toInt()}%',
                          style: const TextStyle(
                              color: primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: (currentPage + 1) / questions.length,
                      minHeight: 7,
                      backgroundColor: primary.withOpacity(0.12),
                      valueColor: const AlwaysStoppedAnimation<Color>(primary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ── DOT INDICATORS ────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                questions.length,
                    (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: currentPage == i ? 20 : 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: currentPage == i
                        ? primary
                        : primary.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // ── SWIPEABLE QUESTION PAGES ──────────────────────
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => currentPage = i),
                itemCount: questions.length,
                itemBuilder: (context, pageIndex) {
                  final q = questions[pageIndex];
                  final bool isLastPage = pageIndex == questions.length - 1;
                  final bool answered = selectedAnswers[pageIndex] != null;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [

                        // ── MAIN QUESTION CARD ─────────────────
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: primary.withOpacity(0.08),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [

                              // ── STORYSET IMAGE ─────────────────
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(28)),
                                child: Container(
                                  height: 210,
                                  width: double.infinity,
                                  color: primary.withOpacity(0.05),
                                  child: Image.asset(
                                    q['image'] as String,
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, __, ___) => Icon(
                                      q['icon'] as IconData,
                                      size: 80,
                                      color: primary.withOpacity(0.4),
                                    ),
                                  ),
                                ),
                              ),

                              // ── QUESTION TEXT ──────────────────
                              Padding(
                                padding: const EdgeInsets.fromLTRB(24, 22, 24, 6),
                                child: Text(
                                  q['question'] as String,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: textDark,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                              const Text(
                                'Select one that best describes you',
                                style: TextStyle(fontSize: 12, color: textGrey),
                              ),
                              const SizedBox(height: 22),

                              // ── ANSWER OPTION CHIPS (2x2 grid) ─
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: GridView.count(
                                  crossAxisCount: 2,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 3.0,
                                  children: List.generate(
                                    (q['options'] as List).length,
                                        (optIndex) {
                                      final opt = (q['options'] as List)[optIndex];
                                      final bool isSelected =
                                          selectedAnswers[pageIndex] == optIndex;
                                      final Color optColor = opt['color'] as Color;

                                      return InkWell(
                                        borderRadius: BorderRadius.circular(16),
                                        onTap: () => setState(() {
                                          selectedAnswers[pageIndex] = optIndex;
                                        }),
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 200),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? optColor.withOpacity(0.15)
                                                : optColor.withOpacity(0.06),
                                            borderRadius: BorderRadius.circular(16),
                                            border: Border.all(
                                              color: isSelected
                                                  ? optColor
                                                  : optColor.withOpacity(0.3),
                                              width: isSelected ? 2.2 : 1.5,
                                            ),
                                            boxShadow: isSelected
                                                ? [
                                              BoxShadow(
                                                color: optColor.withOpacity(0.25),
                                                blurRadius: 10,
                                                offset: const Offset(0, 4),
                                              )
                                            ]
                                                : [
                                              BoxShadow(
                                                color: optColor.withOpacity(0.08),
                                                blurRadius: 6,
                                                offset: const Offset(0, 2),
                                              )
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              AnimatedContainer(
                                                duration: const Duration(milliseconds: 200),
                                                padding: const EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                  color: isSelected
                                                      ? optColor.withOpacity(0.2)
                                                      : optColor.withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Icon(
                                                  opt['icon'] as IconData,
                                                  size: 18,
                                                  color: optColor,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                opt['label'] as String,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: isSelected
                                                      ? FontWeight.bold
                                                      : FontWeight.w600,
                                                  color: isSelected
                                                      ? optColor
                                                      : optColor.withOpacity(0.75),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),

                        // ── NEXT / SUBMIT BUTTON ───────────────
                        SizedBox(
                          width: double.infinity,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              gradient: answered
                                  ? const LinearGradient(colors: [
                                Color(0xFF7C3AED),
                                Color(0xFF6366F1),
                              ])
                                  : null,
                              color: answered ? null : Colors.grey.shade200,
                              boxShadow: answered
                                  ? [
                                BoxShadow(
                                  color: primary.withOpacity(0.35),
                                  blurRadius: 14,
                                  offset: const Offset(0, 6),
                                )
                              ]
                                  : null,
                            ),
                            child: ElevatedButton(
                              onPressed: !answered
                                  ? null
                                  : () {
                                if (isLastPage) {
                                  saveAllAnswers();
                                } else {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 350),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                disabledBackgroundColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(vertical: 17),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                elevation: 0,
                              ),
                              child: isSaving && isLastPage
                                  ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2.5),
                              )
                                  : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    isLastPage ? 'Submit Check-In' : 'Next',
                                    style: TextStyle(
                                      color: answered
                                          ? Colors.white
                                          : Colors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    isLastPage
                                        ? Icons.check_circle_outline_rounded
                                        : Icons.arrow_forward_rounded,
                                    color: answered
                                        ? Colors.white
                                        : Colors.grey,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // ── SKIP BUTTON ────────────────────────
                        if (!isLastPage)
                          TextButton(
                            onPressed: () => _pageController.nextPage(
                              duration: const Duration(milliseconds: 350),
                              curve: Curves.easeInOut,
                            ),
                            child: const Text(
                              'Skip this question',
                              style: TextStyle(color: textGrey, fontSize: 13),
                            ),
                          ),

                        // ── SUGGESTIONS + BADGE (last page only) ─
                        if (isLastPage) ...[
                          const SizedBox(height: 24),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Suggestions for you',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: textDark),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...suggestions.map((s) => _SuggestionCard(
                            icon: s['icon'] as IconData,
                            color: s['color'] as Color,
                            title: s['title'] as String,
                            subtitle: s['subtitle'] as String,
                          )),
                          const SizedBox(height: 16),

                          // ── CONSISTENCY BADGE BANNER ──────────
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(22),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
                              ),
                              borderRadius: BorderRadius.circular(22),
                              boxShadow: [
                                BoxShadow(
                                  color: primary.withOpacity(0.3),
                                  blurRadius: 18,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Consistency Pays',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(height: 6),
                                      Text('Complete 3 more checks\nfor a badge.',
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 13,
                                              height: 1.5)),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.15),
                                  ),
                                  child: const Icon(Icons.star_rounded,
                                      color: Colors.amber, size: 32),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  REUSABLE WIDGETS
// ════════════════════════════════════════════════════════════

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(Icons.arrow_back_ios_new_rounded,
            size: 16, color: Color(0xFF1E1B4B)),
      ),
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  const _SuggestionCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color(0xFF1E1B4B))),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: const TextStyle(
                        color: Color(0xFF9CA3AF), fontSize: 13)),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey.shade300, size: 22),
        ],
      ),
    );
  }
}