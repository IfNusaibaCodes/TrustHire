import 'package:flutter/material.dart';

/// Displays a company logo from a URL, or falls back to initials from [companyName].
///
/// Used across job cards, trending list, applied/saved job lists, and job details.
class CompanyLogo extends StatelessWidget {
  final String? logoUrl;
  final String? companyName;
  final double size;
  final double borderRadius;
  final Color background;
  final bool showBorder;
  final bool showShadow;
  final double initialsSize;

  const CompanyLogo({
    super.key,
    this.logoUrl,
    this.companyName,
    this.size = 48,
    this.borderRadius = 12,
    this.background = const Color(0xFFF0F2FF),
    this.showBorder = true,
    this.showShadow = false,
    this.initialsSize = 16,
  });

  String get _initials {
    if (companyName == null || companyName!.isEmpty) return '?';
    return companyName!.trim().split(' ').take(2).map((w) => w[0].toUpperCase()).join();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(borderRadius),
        border: showBorder ? Border.all(color: const Color(0xFFE5E7EB)) : null,
        boxShadow: showShadow
            ? [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 4))]
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: logoUrl != null && logoUrl!.isNotEmpty
          ? Image.network(
              logoUrl!,
              fit: BoxFit.contain,
              webHtmlElementStrategy: WebHtmlElementStrategy.fallback,  //when run in chrome then this helps to load logo
              errorBuilder: (context, error, stackTrace) => _buildInitials(),
            )
          : _buildInitials(),
    );
  }

  Widget _buildInitials() => Center(
        child: Text(
          _initials,
          style: TextStyle(
            fontSize: initialsSize,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF4F6EF7),
          ),
        ),
      );
}
