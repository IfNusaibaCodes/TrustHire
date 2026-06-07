import 'package:flutter/material.dart';


const Color _primary  = Color(0xFF3B5BDB);
const Color _bgColor  = Color(0xFFF5F6FA);
const Color _textDark = Color(0xFF1A1A2E);
const Color _textGrey = Color(0xFF9CA3AF);
const Color _navy     = Color(0xFF1A1F36);

const _ratings = [
  ('😍', 'Excellent',        Color(0xFF16A34A)),
  ('😊', 'Very Good',        Color(0xFF3B5BDB)),
  ('🙂', 'Good',             Color(0xFF0EA5E9)),
  ('😐', 'Satisfactory',     Color(0xFFF59E0B)),
  ('😞', 'Not Satisfactory', Color(0xFFEF4444)),
];

const _features = [
  '🔍  Job Feed',
  '🛡️  Scam Detector',
  '👤  Profile',
  '📅  Planner',
  '📖  Work Guide',
  '📱  General App',
  '💬  Other',
];

class FeedbackSupportPage extends StatefulWidget {
  const FeedbackSupportPage({super.key});

  @override
  State<FeedbackSupportPage> createState() => _FeedbackSupportPageState();
}

class _FeedbackSupportPageState extends State<FeedbackSupportPage> {

  String? _rating;
  String? _feature;

  final _problemCtrl    = TextEditingController();
  final _suggestionCtrl = TextEditingController();
  final _emailCtrl      = TextEditingController();
  final _phoneCtrl      = TextEditingController();
  final _formKey        = GlobalKey<FormState>();

  bool _submitting = false;
  bool _submitted  = false;

  @override
  void dispose() {
    _problemCtrl.dispose();
    _suggestionCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _openRatingPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _PickerSheet(
        title: 'Select Rating',
        items: _ratings.map((r) => (r.$1, r.$2, r.$3)).toList(),
        selected: _rating,
        onSelect: (val) {
          setState(() => _rating = val);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _openFeaturePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _FeatureSheet(
        selected: _feature,
        onSelect: (val) {
          setState(() => _feature = val);
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_rating == null) {
      _snack('Please select a rating', error: true); return;
    }
    if (_feature == null) {
      _snack('Please select a feature', error: true); return;
    }

    setState(() => _submitting = true);

    final rating     = _rating!;
    final feature    = _feature!;
    final problem    = _problemCtrl.text.trim();
    final suggestion = _suggestionCtrl.text.trim();
    final email      = _emailCtrl.text.trim();
    final phone      = _phoneCtrl.text.trim();

    // TODO (backend): insert into Supabase here, e.g.
    // await Supabase.instance.client.from('feedback').insert({
    //   'rating': rating, 'feature': feature, 'problem': problem,
    //   'suggestion': suggestion, 'email': email, 'phone': phone,
    // });

    // TODO (backend): on success → setState(() { _submitting = false; _submitted = true; });
    //                         on error  → _snack('Error message', error: true); setState(() => _submitting = false);
    // ── Remove the two lines below once backend is wired ──────────────────
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) setState(() { _submitting = false; _submitted = true; });
  }

  void _snack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg,
          style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
      backgroundColor: error ? const Color(0xFFEF4444) : const Color(0xFF16A34A),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
    ));
  }

  void _reset() => setState(() {
    _rating = null; _feature = null; _submitted = false;
    _problemCtrl.clear(); _suggestionCtrl.clear();
    _emailCtrl.clear(); _phoneCtrl.clear();
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: _navy,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Feedback & Support',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
            letterSpacing: 0.4,
          ),
        ),
      ),
      body: _submitted
          ? _SuccessView(
        onAgain: _reset,
        onBack: () => Navigator.pop(context),
      )
          : Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 22, 18, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              _DropdownTile(
                hint: 'Choose a feature',
                value: _feature,
                icon: Icons.layers_outlined,
                onTap: _openFeaturePicker,
              ),
              const SizedBox(height: 14),

              _DropdownTile(
                hint: 'How satisfied are you with this module?',
                value: _ratingDisplay,
                icon: Icons.star_outline_rounded,
                onTap: _openRatingPicker,
                ratingColor: _ratingColor,
              ),
              const SizedBox(height: 22),

              _fieldLabel('Are you facing any problem?'),
              const SizedBox(height: 8),
              _multilineField(_problemCtrl, 'Type your message...'),
              const SizedBox(height: 18),


              _fieldLabel('Do you have any suggestions?'),
              const SizedBox(height: 8),
              _multilineField(_suggestionCtrl, 'Type your message...'),
              const SizedBox(height: 18),

              _fieldLabel('Email id'),
              const SizedBox(height: 8),
              _singleField(
                _emailCtrl,
                'Enter your email',
                TextInputType.emailAddress,
                validator: (v) {
                  if (v != null && v.isNotEmpty &&
                      !RegExp(r'^[\w.-]+@[\w.-]+\.\w+$').hasMatch(v)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),

              _fieldLabel('Phone No.'),
              const SizedBox(height: 8),
              _singleField(
                _phoneCtrl,
                'Enter your phone number',
                TextInputType.phone,
              ),
              const SizedBox(height: 30),

              _submitButton(),
            ],
          ),
        ),
      ),
    );
  }


  String? get _ratingDisplay => _rating;

  Color? get _ratingColor {
    if (_rating == null) return null;
    for (final r in _ratings) {
      if (r.$2 == _rating) return r.$3;
    }
    return null;
  }

  Widget _fieldLabel(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: _textDark,
      fontFamily: 'Poppins',
    ),
  );

  Widget _multilineField(TextEditingController ctrl, String hint) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFFE5E7EB)),
      boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2))
      ],
    ),
    child: TextFormField(
      controller: ctrl,
      maxLines: 5,
      style: const TextStyle(
          fontSize: 13, color: _textDark, fontFamily: 'Poppins'),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
            fontSize: 13, color: _textGrey, fontFamily: 'Poppins'),
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: _primary, width: 1.5)),
      ),
    ),
  );

  Widget _singleField(
      TextEditingController ctrl,
      String hint,
      TextInputType type, {
        String? Function(String?)? validator,
      }) =>
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 6,
                offset: const Offset(0, 2))
          ],
        ),
        child: TextFormField(
          controller: ctrl,
          keyboardType: type,
          validator: validator,
          style: const TextStyle(
              fontSize: 13, color: _textDark, fontFamily: 'Poppins'),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
                fontSize: 13, color: _textGrey, fontFamily: 'Poppins'),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: _primary, width: 1.5)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFEF4444))),
          ),
        ),
      );

  Widget _submitButton() => GestureDetector(
    onTap: _submitting ? null : _submit,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _submitting
              ? [Colors.grey.shade400, Colors.grey.shade500]
              : [_navy, _primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: _submitting
            ? []
            : [
          BoxShadow(
              color: _primary.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6))
        ],
      ),
      child: Center(
        child: _submitting
            ? const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
                color: Colors.white, strokeWidth: 2.5))
            : const Text(
          'Submit',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
            letterSpacing: 0.5,
          ),
        ),
      ),
    ),
  );
}

class _DropdownTile extends StatelessWidget {
  final String  hint;
  final String? value;
  final IconData icon;
  final VoidCallback onTap;
  final Color?  ratingColor;

  const _DropdownTile({
    required this.hint,
    required this.value,
    required this.icon,
    required this.onTap,
    this.ratingColor,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value!.isNotEmpty;
    final displayColor = ratingColor ?? _primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: hasValue ? displayColor.withOpacity(0.4) : const Color(0xFFE5E7EB),
            width: hasValue ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 6,
                offset: const Offset(0, 2))
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: hasValue ? displayColor : _textGrey,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                hasValue ? value! : hint,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Poppins',
                  color: hasValue ? _textDark : _textGrey,
                  fontWeight: hasValue ? FontWeight.w600 : FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 20,
              color: hasValue ? displayColor : _textGrey,
            ),
          ],
        ),
      ),
    );
  }
}

class _PickerSheet extends StatelessWidget {
  final String title;
  final List<(String, String, Color)> items;
  final String? selected;
  final ValueChanged<String> onSelect;

  const _PickerSheet({
    required this.title,
    required this.items,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 18),
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: _textDark,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Tap to select your rating',
            style: TextStyle(
                fontSize: 12, color: _textGrey, fontFamily: 'Poppins'),
          ),
          const SizedBox(height: 18),
          Divider(color: Colors.grey.shade100, height: 1),
          const SizedBox(height: 8),


          ...items.map((item) {
            final emoji = item.$1;
            final label = item.$2;
            final color = item.$3;
            final isSelected = selected == label;

            return GestureDetector(
              onTap: () => onSelect(label),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected ? color.withOpacity(0.08) : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? color.withOpacity(0.4) : Colors.transparent,
                  ),
                ),
                child: Row(
                  children: [
                    Text(emoji, style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? color : _textDark,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    if (isSelected)
                      Icon(Icons.check_circle_rounded, color: color, size: 20),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _FeatureSheet extends StatelessWidget {
  final String? selected;
  final ValueChanged<String> onSelect;

  const _FeatureSheet({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 18),
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          const Text(
            'Choose a Feature',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: _textDark,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Which feature are you giving feedback on?',
            style: TextStyle(
                fontSize: 12, color: _textGrey, fontFamily: 'Poppins'),
          ),
          const SizedBox(height: 18),
          Divider(color: Colors.grey.shade100, height: 1),
          const SizedBox(height: 8),

          ..._features.map((f) {
            final isSelected = selected == f;
            return GestureDetector(
              onTap: () => onSelect(f),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected ? _primary.withOpacity(0.07) : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? _primary.withOpacity(0.3) : Colors.transparent,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        f,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? _primary : _textDark,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    if (isSelected)
                      const Icon(Icons.check_circle_rounded,
                          color: _primary, size: 20),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  final VoidCallback onAgain;
  final VoidCallback onBack;
  const _SuccessView({required this.onAgain, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88, height: 88,
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(26),
              ),
              child: const Icon(Icons.check_circle_outline_rounded,
                  size: 48, color: Color(0xFF16A34A)),
            ),
            const SizedBox(height: 22),
            const Text(
              'Feedback Submitted!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: _textDark,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Thank you for helping us improve TrustHire.\nWe really appreciate your time.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 13, color: _textGrey,
                  fontFamily: 'Poppins', height: 1.6),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: onAgain,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [_navy, _primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Submit Another',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: onBack,
              child: const Text(
                'Go Back',
                style: TextStyle(
                    color: _textGrey,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}