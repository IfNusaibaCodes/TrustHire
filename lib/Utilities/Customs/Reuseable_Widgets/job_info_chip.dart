import 'package:flutter/material.dart';

/// Small icon + label chip used to display job metadata (location, type, experience, salary).
/// [accent] switches to an orange variant for highlighted fields (e.g. experience level).
class JobInfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool accent;

  const JobInfoChip({
    super.key,
    required this.icon,
    required this.label,
    this.accent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: accent ? const Color(0xFFFFF7ED) : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: accent ? const Color(0xFFFED7AA) : const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 13,
            color: accent ? const Color(0xFFF97316) : const Color(0xFF6B7280),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: accent ? const Color(0xFFF97316) : const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}
