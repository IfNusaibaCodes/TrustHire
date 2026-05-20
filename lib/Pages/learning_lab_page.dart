import 'package:flutter/material.dart';
class LearningLabPage extends StatefulWidget {
  const LearningLabPage({super.key});
  @override
  State<LearningLabPage> createState() =>
      _LearningLabPageState();
}
class _LearningLabPageState
    extends State<LearningLabPage> {
  static const Color bgPage       = Color(0xFFF8FAFC);
  static const Color bgCard       = Color(0xFFFFFFFF);
  static const Color bgAppBar     = Color(0xFFFFFFFF);
  static const Color accentScam   = Color(0xFFEF4444);
  static const Color accentLegit  = Color(0xFF22C55E);
  static const Color accentGold   = Color(0xFFF59E0B);
  static const Color textPrimary  = Color(0xFF0F172A);
  static const Color textMuted    = Color(0xFF64748B);
  static const Color cardBorder   = Color(0xFFE2E8F0);
  static const Color progressBg   = Color(0xFFE2E8F0);
  int currentQuestion = 0;
  int score = 0;
  bool quizFinished = false;
  List<Map<String, dynamic>> questions = [
    {
      "job": "Earn 50,000 BDT weekly! Send registration fee now!",
      "answer": "Scam",
      "explanation": "Real jobs do not ask for money."
    },
    {
      "job": "Apply through official company website.",
      "answer": "Legit",
      "explanation": "Official websites are positive signs."
    },
    {
      "job": "Urgent hiring! WhatsApp now!",
      "answer": "Scam",
      "explanation": "Urgency is a common scam tactic."
    },
    {
      "job": "Remote internship with interview process.",
      "answer": "Legit",
      "explanation": "Interview process increases legitimacy."
    },
    {
      "job": "Guaranteed job without experience!",
      "answer": "Scam",
      "explanation": "Too-good-to-be-true promises are risky."
    },
    {
      "job": "Company email ends with gmail.com",
      "answer": "Scam",
      "explanation": "Free email domains can be suspicious."
    },
    {
      "job": "Clear company address and website provided.",
      "answer": "Legit",
      "explanation": "Transparent company info is good."
    },
    {
      "job": "Pay first to unlock training materials.",
      "answer": "Scam",
      "explanation": "Advance payment requests are dangerous."
    },
    {
      "job": "Detailed responsibilities listed in job post.",
      "answer": "Legit",
      "explanation": "Professional job descriptions are positive."
    },
    {
      "job": "Instant selection without interview.",
      "answer": "Scam",
      "explanation": "Real companies usually interview candidates."
    },
  ];
  void checkAnswer(String userAnswer) {
    String correctAnswer = questions[currentQuestion]["answer"];
    if (userAnswer == correctAnswer) {
      score++;
    }
    bool isCorrect = userAnswer == correctAnswer;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: bgCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isCorrect ? accentLegit : accentScam,
              width: 1.5,
            ),
          ),
          title: Text(
            isCorrect ? "✅ Correct!" : "❌ Wrong!",
            style: TextStyle(
              color: isCorrect ? accentLegit : accentScam,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            questions[currentQuestion]["explanation"],
            style: const TextStyle(
              color: textPrimary,
              fontSize: 15,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  if (currentQuestion < questions.length - 1) {
                    currentQuestion++;
                  } else {
                    quizFinished = true;
                  }
                });
              },
              child: const Text(
                "Next →",
                style: TextStyle(
                  color: accentGold,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgPage,
      appBar: AppBar(
        backgroundColor: bgAppBar,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          "Scam Learning Lab",
          style: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: textPrimary),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: cardBorder,
            height: 1,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: quizFinished
            ? buildResultScreen()
            : buildQuizScreen(),
      ),
    );
  }
  Widget buildQuizScreen() {
    double progress = (currentQuestion + 1) / questions.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Question ${currentQuestion + 1}/${questions.length}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: accentGold.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "⭐ Score: $score",
                style: const TextStyle(
                  fontSize: 13,
                  color: accentGold,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: progressBg,
            valueColor: const AlwaysStoppedAnimation<Color>(accentGold),
          ),
        ),
        const SizedBox(height: 28),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: bgCard,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: cardBorder, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: accentGold.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.work_outline,
                  size: 32,
                  color: accentGold,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                questions[currentQuestion]["job"],
                style: const TextStyle(
                  color: textPrimary,
                  fontSize: 19,
                  height: 1.55,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const Center(
          child: Text(
            "Is this job posting a scam or legit?",
            style: TextStyle(
              color: textMuted,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 22),
        SizedBox(
          width: double.infinity,
          height: 58,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: accentScam,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            onPressed: () => checkAnswer("Scam"),
            icon: const Icon(Icons.dangerous_outlined, size: 22),
            label: const Text(
              "SCAM",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 58,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: accentLegit,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            onPressed: () => checkAnswer("Legit"),
            icon: const Icon(Icons.verified_outlined, size: 22),
            label: const Text(
              "LEGIT",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
  Widget buildResultScreen() {
    String badge = "";
    Color badgeColor = accentGold;
    IconData badgeIcon = Icons.emoji_events;
    if (score >= 8) {
      badge = "🏆  Scam Expert";
      badgeColor = accentGold;
      badgeIcon = Icons.emoji_events;
    } else if (score >= 5) {
      badge = "🥇  Scam Aware User";
      badgeColor = accentLegit;
      badgeIcon = Icons.shield_outlined;
    } else {
      badge = "📘  Beginner";
      badgeColor = const Color(0xFF3B82F6);
      badgeIcon = Icons.school_outlined;
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: accentGold.withOpacity(0.12),
              shape: BoxShape.circle,
              border: Border.all(
                color: accentGold.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Icon(
              badgeIcon,
              size: 50,
              color: accentGold,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Quiz Completed!",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "$score out of ${questions.length} correct",
            style: const TextStyle(
              fontSize: 18,
              color: textMuted,
            ),
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: badgeColor.withOpacity(0.4),
                width: 1.5,
              ),
            ),
            child: Text(
              badge,
              style: TextStyle(
                color: badgeColor,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 44),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: accentGold,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              onPressed: () {
                setState(() {
                  currentQuestion = 0;
                  score = 0;
                  quizFinished = false;
                });
              },
              child: const Text(
                "Restart Quiz",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}