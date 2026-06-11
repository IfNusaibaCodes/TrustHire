import 'package:flutter/material.dart';
import 'package:trust_hire_app/Utilities/Constants/colors.dart';
import 'package:trust_hire_app/Utilities/Customs/Reuseable_Widgets/app_snackbar.dart';
import '../../Model/burnout_model.dart';

import 'burnout_db.dart';

class BurnoutPage extends StatefulWidget {
  const BurnoutPage({super.key});

  @override
  State<BurnoutPage> createState() => _BurnoutPageState();
}

class _BurnoutPageState extends State<BurnoutPage> {

  // ── Dependencies ─────────────────────────────────────────
  final BurnoutRepository _repository = BurnoutRepository();

  // ── State ────────────────────────────────────────────────
  final Map<int, int> selectedAnswers = {};
  final PageController _pageController = PageController();
  int currentPage = 0;
  bool isSaving   = false;
  bool _submitted = false;

  // ── Short-hands ──────────────────────────────────────────
  List<BurnoutQuestion>  get _questions   => BurnoutData.questions;
  List<BurnoutSuggestion> get _suggestions => BurnoutData.suggestions;

  // ── Theme constants ──────────────────────────────────────
  static const Color primary  = TColors.appNavy;
  static const Color bgColor  = TColors.appBackground;
  static const Color textDark = TColors.appTextDark;
  static const Color textGrey = TColors.appTextGrey;

  // ── Save ─────────────────────────────────────────────────
  Future<void> _saveAllAnswers() async {
    if (selectedAnswers.length < _questions.length) {
      _showMessage('Please answer all questions!', isError: true);
      return;
    }

    setState(() => isSaving = true);

    try {
      await _repository.saveAnswers(
        questions: _questions,
        selectedAnswers: selectedAnswers,
      );

      if (mounted) setState(() => _submitted = true);

    } catch (e) {
      _showMessage('Error: $e', isError: true);
    }

    if (mounted) setState(() => isSaving = false);
  }

  // ── Snackbar helper ──────────────────────────────────────
  void _showMessage(String msg, {bool isError = false}) {
    if (!mounted) return;
    showAppSnackBar(context, msg, isError: isError);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // ════════════════════════════════════════════════════════
  //  BUILD
  // ════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    if (_submitted) return _ResultsScreen(suggestions: _suggestions);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [

            // ── TOP BAR ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: Row(
                children: [
                  BackButton(
                      onPressed: (){
                        Navigator.pop(context);
                      }
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
                      '${currentPage + 1} / ${_questions.length}',
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

            // ── PROGRESS BAR ────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Question ${currentPage + 1} of ${_questions.length}',
                          style: const TextStyle(color: textGrey, fontSize: 12)),
                      Text(
                        '${((currentPage + 1) / _questions.length * 100).toInt()}%',
                        style: const TextStyle(
                            color: primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: (currentPage + 1) / _questions.length,
                      minHeight: 7,
                      backgroundColor: primary.withOpacity(0.12),
                      valueColor: const AlwaysStoppedAnimation<Color>(primary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // DOT INDICATORS
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _questions.length,
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

            // SWIPEABLE QUESTION PAGES
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => currentPage = i),
                itemCount: _questions.length,
                itemBuilder: (context, pageIndex) {
                  final q          = _questions[pageIndex];
                  final isLastPage = pageIndex == _questions.length - 1;
                  final answered   = selectedAnswers[pageIndex] != null;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [

                        // ── QUESTION CARD ──────────────────
                        _QuestionCard(
                          question: q,
                          pageIndex: pageIndex,
                          selectedOptionIndex: selectedAnswers[pageIndex],
                          onOptionTap: (optIndex) =>
                              setState(() => selectedAnswers[pageIndex] = optIndex),
                        ),
                        const SizedBox(height: 18),

                        // ── NEXT / SUBMIT BUTTON ───────────
                        _ActionButton(
                          answered: answered,
                          isLastPage: isLastPage,
                          isSaving: isSaving,
                          onTap: () {
                            if (isLastPage) {
                              _saveAllAnswers();
                            } else {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 350),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                        ),

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



// ── Question Card ────────────────────────────────────────────
class _QuestionCard extends StatelessWidget {
  final BurnoutQuestion question;
  final int pageIndex;
  final int? selectedOptionIndex;
  final ValueChanged<int> onOptionTap;

  const _QuestionCard({
    required this.question,
    required this.pageIndex,
    required this.selectedOptionIndex,
    required this.onOptionTap,
  });

  static const Color primary  = TColors.appNavy;
  static const Color textDark = TColors.appTextDark;
  static const Color textGrey = TColors.appTextGrey;

  @override
  Widget build(BuildContext context) {
    return Container(
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

          // ── Illustration ──────────────────────────────────
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            child: Container(
              height: 210,
              width: double.infinity,
              color: primary.withOpacity(0.05),
              child: Image.asset(
                question.imagePath,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Icon(
                  question.fallbackIcon,
                  size: 80,
                  color: primary.withOpacity(0.4),
                ),
              ),
            ),
          ),

          // ── Question text ─────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 22, 24, 6),
            child: Text(
              question.question,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: textDark,
                  height: 1.4),
            ),
          ),
          const Text('Select one that best describes you',
              style: TextStyle(fontSize: 12, color: textGrey)),
          const SizedBox(height: 22),

          // ── Options (2×2 grid) ────────────────────────────
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
                question.options.length,
                    (optIndex) => _OptionChip(
                  option: question.options[optIndex],
                  isSelected: selectedOptionIndex == optIndex,
                  onTap: () => onOptionTap(optIndex),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ── Single option chip ────────────────────────────────────────
class _OptionChip extends StatelessWidget {
  final BurnoutOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionChip({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = option.color;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.15) : color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : color.withOpacity(0.3),
            width: isSelected ? 2.2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? color.withOpacity(0.25)
                  : color.withOpacity(0.08),
              blurRadius: isSelected ? 10 : 6,
              offset: Offset(0, isSelected ? 4 : 2),
            ),
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
                    ? color.withOpacity(0.2)
                    : color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(option.icon, size: 18, color: color),
            ),
            const SizedBox(width: 8),
            Text(
              option.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? color : color.withOpacity(0.75),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Next / Submit button ──────────────────────────────────────
class _ActionButton extends StatelessWidget {
  final bool answered;
  final bool isLastPage;
  final bool isSaving;
  final VoidCallback onTap;

  const _ActionButton({
    required this.answered,
    required this.isLastPage,
    required this.isSaving,
    required this.onTap,
  });

  static const Color primary = TColors.appNavy;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: answered
              ? const LinearGradient(
              colors: [Color(0xFF1A1F36), Color(0xFF4F6EF7)])
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
          onPressed: answered ? onTap : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 17),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18)),
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
                  color: answered ? Colors.white : Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                isLastPage
                    ? Icons.check_circle_outline_rounded
                    : Icons.arrow_forward_rounded,
                color: answered ? Colors.white : Colors.grey,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Results screen (shown after successful submission) ─────────
class _ResultsScreen extends StatelessWidget {
  final List<BurnoutSuggestion> suggestions;
  const _ResultsScreen({required this.suggestions});

  static const Color primary  = TColors.appNavy;
  static const Color bgColor  = TColors.appBackground;
  static const Color textDark = TColors.appTextDark;

  @override
  Widget build(BuildContext context) {
    final String today = _formattedDate();

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Well Done Card ───────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1A1F36), Color(0xFF4F6EF7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: primary.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Text('🎉', style: TextStyle(fontSize: 36)),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Well Done!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'You completed today\'s burnout check-in.\nTaking care of yourself matters. 💜',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.calendar_today_rounded,
                              color: Colors.white70, size: 14),
                          const SizedBox(width: 6),
                          Text(
                            today,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // ── Suggestions label ────────────────────────────
              const Text('Suggestions for you',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textDark)),
              const SizedBox(height: 12),

              // ── Suggestion cards ─────────────────────────────
              ...suggestions.map((s) => _SuggestionCard(suggestion: s)),
              const SizedBox(height: 24),

              // ── Done button ──────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    elevation: 0,
                  ),
                  child: const Text('Done',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  String _formattedDate() {
    final now = DateTime.now();
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    const days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday'
    ];
    return '${days[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';
  }
}

// ── Suggestion card ───────────────────────────────────────────
class _SuggestionCard extends StatelessWidget {
  final BurnoutSuggestion suggestion;
  const _SuggestionCard({required this.suggestion});

  @override
  Widget build(BuildContext context) {
    final color = suggestion.color;
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
            child: Icon(suggestion.icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(suggestion.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: TColors.appTextDark)),
                const SizedBox(height: 2),
                Text(suggestion.subtitle,
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