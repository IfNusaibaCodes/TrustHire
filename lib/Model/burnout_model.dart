import 'package:flutter/material.dart';

// ── ANSWER OPTION ────────────────────────────────────────────
class BurnoutOption {
  final IconData icon;
  final String label;
  final Color color;

  const BurnoutOption({
    required this.icon,
    required this.label,
    required this.color,
  });
}

// ── SINGLE QUESTION ──────────────────────────────────────────
class BurnoutQuestion {
  final int questionNumber;
  final String question;
  final String imagePath;
  final IconData fallbackIcon;
  final List<BurnoutOption> options;

  const BurnoutQuestion({
    required this.questionNumber,
    required this.question,
    required this.imagePath,
    required this.fallbackIcon,
    required this.options,
  });
}

// ── SUGGESTION CARD ──────────────────────────────────────────
class BurnoutSuggestion {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  const BurnoutSuggestion({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });
}

// ── SUBMITTED RECORD (maps to Supabase row) ──────────────────
class BurnoutRecord {
  final String? id;           // uuid — null before insert
  final String userId;
  final int questionNumber;
  final String questionText;
  final String answer;
  final DateTime? createdAt;

  const BurnoutRecord({
    this.id,
    required this.userId,
    required this.questionNumber,
    required this.questionText,
    required this.answer,
    this.createdAt,
  });

  /// Convert to JSON for Supabase insert.
  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'question_number': questionNumber,
    'question_text': questionText,
    'answer': answer,
  };

  /// Build from Supabase row JSON.
  factory BurnoutRecord.fromJson(Map<String, dynamic> json) => BurnoutRecord(
    id: json['id'] as String?,
    userId: json['user_id'] as String,
    questionNumber: json['question_number'] as int,
    questionText: json['question_text'] as String,
    answer: json['answer'] as String,
    createdAt: json['created_at'] != null
        ? DateTime.parse(json['created_at'] as String)
        : null,
  );
}

// ── STATIC DATA ───────────────────────────────────────────────
//  All questions and suggestions live here so the UI and
//  repository never hard-code content.
// ─────────────────────────────────────────────────────────────
class BurnoutData {
  BurnoutData._(); // non-instantiable

  static const List<BurnoutQuestion> questions = [
    BurnoutQuestion(
      questionNumber: 1,
      question: 'How exhausted have you felt this week?',
      imagePath: 'assets/images/burnedout_images/exhausted.png.png',
      fallbackIcon: Icons.battery_alert_rounded,
      options: [
        BurnoutOption(icon: Icons.local_fire_department_rounded, label: 'Burned Out', color: Color(0xFFEF4444)),
        BurnoutOption(icon: Icons.cloud_rounded,                 label: 'Tired',      color: Color(0xFFF59E0B)),
        BurnoutOption(icon: Icons.wb_sunny_rounded,              label: 'Good',       color: Color(0xFF10B981)),
        BurnoutOption(icon: Icons.stars_rounded,                 label: 'Great',      color: Color(0xFF7C3AED)),
      ],
    ),
    BurnoutQuestion(
      questionNumber: 2,
      question: 'What is your stress level right now?',
      imagePath: 'assets/images/burnedout_images/stress.png.png',
      fallbackIcon: Icons.psychology_rounded,
      options: [
        BurnoutOption(icon: Icons.warning_amber_rounded,   label: 'Very High', color: Color(0xFFEF4444)),
        BurnoutOption(icon: Icons.trending_up_rounded,     label: 'High',      color: Color(0xFFF59E0B)),
        BurnoutOption(icon: Icons.trending_down_rounded,   label: 'Low',       color: Color(0xFF10B981)),
        BurnoutOption(icon: Icons.check_circle_rounded,    label: 'None',      color: Color(0xFF7C3AED)),
      ],
    ),
    BurnoutQuestion(
      questionNumber: 3,
      question: 'How motivated do you feel about your work?',
      imagePath: 'assets/images/burnedout_images/motivation.png.png',
      fallbackIcon: Icons.rocket_launch_rounded,
      options: [
        BurnoutOption(icon: Icons.do_not_disturb_rounded,  label: 'Not At All', color: Color(0xFFEF4444)),
        BurnoutOption(icon: Icons.battery_1_bar_rounded,   label: 'A Little',   color: Color(0xFFF59E0B)),
        BurnoutOption(icon: Icons.bolt_rounded,            label: 'Motivated',  color: Color(0xFF10B981)),
        BurnoutOption(icon: Icons.rocket_launch_rounded,   label: 'Very Much',  color: Color(0xFF7C3AED)),
      ],
    ),
    BurnoutQuestion(
      questionNumber: 4,
      question: 'How connected do you feel with your team?',
      imagePath: 'assets/images/burnedout_images/team.png.png',
      fallbackIcon: Icons.people_rounded,
      options: [
        BurnoutOption(icon: Icons.person_off_rounded,   label: 'Isolated',   color: Color(0xFFEF4444)),
        BurnoutOption(icon: Icons.person_rounded,       label: 'Distant',    color: Color(0xFFF59E0B)),
        BurnoutOption(icon: Icons.handshake_rounded,    label: 'Connected',  color: Color(0xFF10B981)),
        BurnoutOption(icon: Icons.favorite_rounded,     label: 'Very Close', color: Color(0xFF7C3AED)),
      ],
    ),
    BurnoutQuestion(
      questionNumber: 5,
      question: 'How is your work-life balance this week?',
      imagePath: 'assets/images/burnedout_images/balance.png.png',
      fallbackIcon: Icons.balance_rounded,
      options: [
        BurnoutOption(icon: Icons.running_with_errors_rounded, label: 'No Balance', color: Color(0xFFEF4444)),
        BurnoutOption(icon: Icons.compare_arrows_rounded,      label: 'Struggling', color: Color(0xFFF59E0B)),
        BurnoutOption(icon: Icons.balance_rounded,             label: 'Managing',   color: Color(0xFF10B981)),
        BurnoutOption(icon: Icons.verified_rounded,            label: 'Balanced',   color: Color(0xFF7C3AED)),
      ],
    ),
    BurnoutQuestion(
      questionNumber: 6,
      question: 'How well have you been sleeping?',
      imagePath: 'assets/images/burnedout_images/sleep.png.png',
      fallbackIcon: Icons.bedtime_rounded,
      options: [
        BurnoutOption(icon: Icons.nights_stay_rounded,   label: 'Very Poor', color: Color(0xFFEF4444)),
        BurnoutOption(icon: Icons.battery_2_bar_rounded, label: 'Poor',      color: Color(0xFFF59E0B)),
        BurnoutOption(icon: Icons.bedtime_rounded,       label: 'Okay',      color: Color(0xFF10B981)),
        BurnoutOption(icon: Icons.star_rounded,          label: 'Great',     color: Color(0xFF7C3AED)),
      ],
    ),
    BurnoutQuestion(
      questionNumber: 7,
      question: 'Overall, how are you feeling today?',
      imagePath: 'assets/images/burnedout_images/overall.png.png',
      fallbackIcon: Icons.favorite_rounded,
      options: [
        BurnoutOption(icon: Icons.sentiment_very_dissatisfied_rounded, label: 'Not Good', color: Color(0xFFEF4444)),
        BurnoutOption(icon: Icons.sentiment_neutral_rounded,           label: 'Okay',     color: Color(0xFFF59E0B)),
        BurnoutOption(icon: Icons.sentiment_satisfied_rounded,         label: 'Good',     color: Color(0xFF10B981)),
        BurnoutOption(icon: Icons.sentiment_very_satisfied_rounded,    label: 'Amazing',  color: Color(0xFF7C3AED)),
      ],
    ),
  ];

  static const List<BurnoutSuggestion> suggestions = [
    BurnoutSuggestion(
      icon: Icons.coffee_outlined,
      color: Color(0xFF7C3AED),
      title: 'Power Break',
      subtitle: 'A 15-min disconnect to reset.',
    ),
    BurnoutSuggestion(
      icon: Icons.directions_walk,
      color: Color(0xFF10B981),
      title: 'Fresh Air Walk',
      subtitle: 'Step outside for 10 minutes.',
    ),
    BurnoutSuggestion(
      icon: Icons.no_cell_outlined,
      color: Color(0xFFEF4444),
      title: 'Screen Limit',
      subtitle: 'Reduce blue light exposure.',
    ),
  ];
}