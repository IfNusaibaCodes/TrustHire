

import 'package:flutter/material.dart';

const Color primary  = Color(0xFF3B5BDB);
const Color bgColor  = Color(0xFFF5F6FA);
const Color textDark = Color(0xFF1A1A2E);
const Color textGrey = Color(0xFF9CA3AF);
const Color success  = Color(0xFF10B981);

// ── White card wrapper ───────────────────────────────────────
Widget profileCard({required Widget child}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
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
    child: child,
  );
}

// ── Stat card (Applied / Views / Saved) ─────────────────────
Widget statCard(IconData icon, String value, String label) {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: primary, size: 18),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: textDark)),
          const SizedBox(height: 2),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, color: textGrey)),
        ],
      ),
    ),
  );
}

// ── Section header row ───────────────────────────────────────
Widget sectionHeader({
  required IconData icon,
  required String title,
  String? action,
  IconData? actionIcon,
  VoidCallback? onAction,
}) {
  return Row(
    children: [
      Icon(icon, color: primary, size: 18),
      const SizedBox(width: 8),
      Text(title,
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: textDark)),
      const Spacer(),
      if (action != null && onAction != null)
        GestureDetector(
          onTap: onAction,
          child: Row(
            children: [
              if (actionIcon != null)
                Icon(actionIcon, color: primary, size: 16),
              const SizedBox(width: 4),
              Text(action,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: primary)),
            ],
          ),
        ),
    ],
  );
}

// ── Info row (icon + text) ───────────────────────────────────
Widget infoRow(IconData icon, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      children: [
        Icon(icon, size: 16, color: textGrey),
        const SizedBox(width: 10),
        Expanded(
            child: Text(value,
                style: const TextStyle(fontSize: 13, color: textDark))),
      ],
    ),
  );
}

// ── Completeness step row ────────────────────────────────────
Widget completenessStep(String label, bool done) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: Row(
      children: [
        Icon(
          done ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 16,
          color: done ? success : textGrey,
        ),
        const SizedBox(width: 8),
        Text(label,
            style: TextStyle(
                fontSize: 12,
                color: done ? textDark : textGrey,
                fontWeight: done ? FontWeight.w600 : FontWeight.normal)),
      ],
    ),
  );
}

// ── Reusable text field ──────────────────────────────────────
Widget profileField(
    String label,
    TextEditingController ctrl,
    String hint, {
      int lines = 1,
      bool autofocus = false,
    }) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600, color: textDark)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          maxLines: lines,
          autofocus: autofocus,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: primary, width: 2)),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ],
    ),
  );
}

// ── Primary button ───────────────────────────────────────────
Widget primaryButton(String label, VoidCallback onTap) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 0,
      ),
      child: Text(label,
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
    ),
  );
}

// ── Bottom sheet wrapper ─────────────────────────────────────
Widget bottomSheetWrapper({
  required BuildContext context,
  required String title,
  required Widget child,
}) {
  return Container(
    padding: EdgeInsets.only(
      left: 24,
      right: 24,
      top: 24,
      bottom: MediaQuery.of(context).viewInsets.bottom + 24,
    ),
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 20),
          Text(title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textDark)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    ),
  );
}