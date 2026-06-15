import 'package:flutter/material.dart';
import 'package:trust_hire_app/Utilities/Constants/colors.dart';

/// A selectable, vertical option card: an icon above a label, with a solid
/// [color] fill + shadow when [selected]. Designed to sit inside a [Row]
/// (it wraps itself in [Expanded]) as a segmented choice — e.g. the
/// "Paste Text / Screenshot" input-method toggle.
///
/// Example:
/// ```dart
/// Row(children: [
///   OptionCard(icon: Icons.description_outlined, label: 'Paste Text',
///       selected: method == 0, onTap: () => setMethod(0)),
///   const SizedBox(width: 12),
///   OptionCard(icon: Icons.image_outlined, label: 'Screenshot',
///       selected: method == 1, onTap: () => setMethod(1)),
/// ])
/// ```
class OptionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  /// Accent / fill colour when [selected].
  final Color color;

  const OptionCard({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.color = TColors.appNavy,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected ? color : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: selected ? color : const Color(0xFFE5E7EB)),
            boxShadow: [
              BoxShadow(
                color: selected
                    ? color.withValues(alpha: 0.18)
                    : Colors.black.withValues(alpha: 0.04),
                blurRadius: selected ? 10 : 6,
                offset: Offset(0, selected ? 4 : 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 24, color: selected ? Colors.white : const Color(0xFF6B7280)),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
