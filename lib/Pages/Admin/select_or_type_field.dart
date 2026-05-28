import 'package:flutter/material.dart';

// ─── SELECT OR TYPE WIDGET ────────────────────────────────────────────────────
// Reusable widget used in PostJobTab for Currency and Country fields.
// Shows a Dropdown OR a free-text field, toggled by Select/Type buttons.

class SelectOrTypeField extends StatefulWidget {
  final String label;
  final IconData icon;
  final List<String> options;
  final String hint;
  final String typeHint;
  final void Function(String) onChanged;

  const SelectOrTypeField({
    super.key,
    required this.label,
    required this.icon,
    required this.options,
    required this.hint,
    required this.typeHint,
    required this.onChanged,
  });

  @override
  State<SelectOrTypeField> createState() => _SelectOrTypeFieldState();
}

class _SelectOrTypeFieldState extends State<SelectOrTypeField> {
  bool _isTyping = false;
  String? _selected;
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _switchMode(bool typing) {
    setState(() {
      _isTyping = typing;
      _selected = null;
      _ctrl.clear();
    });
    widget.onChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(widget.label,
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF424655),
                    letterSpacing: 0.3)),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF0F2F5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  _modeBtn('Select', !_isTyping, () => _switchMode(false)),
                  _modeBtn('Type', _isTyping, () => _switchMode(true)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        if (!_isTyping)
          DropdownButtonFormField<String>(
            value: _selected,
            hint: Text(widget.hint,
                style: const TextStyle(
                    fontFamily: 'Poppins', fontSize: 12, color: Color(0xFFADB5BD))),
            onChanged: (v) {
              setState(() => _selected = v);
              widget.onChanged(v ?? '');
            },
            items: widget.options
                .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e,
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: Color(0xFF131B2E)))))
                .toList(),
            decoration: InputDecoration(
              prefixIcon: Icon(widget.icon, size: 16, color: const Color(0xFF727687)),
              filled: true,
              fillColor: const Color(0xFFF7F9FC),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF1A6BFF), width: 1.5)),
            ),
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 12),
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(12),
            icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF727687)),
          )
        else
          TextFormField(
            controller: _ctrl,
            onChanged: widget.onChanged,
            style: const TextStyle(
                fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF131B2E)),
            decoration: InputDecoration(
              hintText: widget.typeHint,
              hintStyle: const TextStyle(
                  fontFamily: 'Poppins', fontSize: 12, color: Color(0xFFADB5BD)),
              prefixIcon: Icon(widget.icon, size: 18, color: const Color(0xFF727687)),
              filled: true,
              fillColor: const Color(0xFFF7F9FC),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF1A6BFF), width: 1.5)),
            ),
          ),
      ],
    );
  }

  Widget _modeBtn(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF1A6BFF) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: active ? Colors.white : const Color(0xFF727687),
          ),
        ),
      ),
    );
  }
}
