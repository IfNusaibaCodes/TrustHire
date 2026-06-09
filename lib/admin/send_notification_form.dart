import 'package:flutter/material.dart';
import '../Pages/Notifications/notification_database.dart';

class SendNotificationForm extends StatefulWidget {
  final VoidCallback onSent;
  const SendNotificationForm({super.key, required this.onSent});

  @override
  State<SendNotificationForm> createState() => _SendNotificationFormState();
}

class _SendNotificationFormState extends State<SendNotificationForm> {
  final _formKey   = GlobalKey<FormState>();
  bool  _loading   = false;

  final _titleCtrl      = TextEditingController();
  final _bodyCtrl       = TextEditingController();
  final _universityCtrl = TextEditingController();
  final _studyYearCtrl  = TextEditingController();

  String  _type       = 'general';
  String? _targetRole;

  static const _types = ['general', 'job_alert', 'trending', 'tip'];
  static const _typeLabels = {
    'general':   'General',
    'job_alert': 'Job Alert',
    'trending':  'Trending',
    'tip':       'Tip',
  };

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    _universityCtrl.dispose();
    _studyYearCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      await NotificationService.createBroadcast(
        title:            _titleCtrl.text.trim(),
        body:             _bodyCtrl.text.trim(),
        type:             _type,
        targetRole:       _targetRole,
        targetUniversity: _universityCtrl.text.trim().isEmpty ? null : _universityCtrl.text.trim(),
        targetStudyYear:  _studyYearCtrl.text.trim().isEmpty  ? null : _studyYearCtrl.text.trim(),
      );

      if (mounted) {
        Navigator.pop(context);
        widget.onSent();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Notification sent!'),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20, right: 20, top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [

              // ── Header ─────────────────────────────────────────
              Row(
                children: [
                  const Text(
                    'Send Notification',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1A1F36)),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 34, height: 34,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.close_rounded, size: 18, color: Color(0xFF6B7280)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ── Content ────────────────────────────────────────
              _sectionLabel('Message'),
              _field(_titleCtrl, 'Title', required: true),
              _field(_bodyCtrl,  'Body',  required: true, maxLines: 3),

              // ── Type ───────────────────────────────────────────
              _sectionLabel('Notification Type'),
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  border: Border.all(color: const Color(0xFFD1D5DB)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _type,
                    isExpanded: true,
                    items: _types.map((t) => DropdownMenuItem(
                      value: t,
                      child: Row(
                        children: [
                          Icon(_typeIcon(t), size: 16, color: _typeColor(t)),
                          const SizedBox(width: 8),
                          Text(_typeLabels[t] ?? t),
                        ],
                      ),
                    )).toList(),
                    onChanged: (v) => setState(() => _type = v!),
                  ),
                ),
              ),

              // ── Audience (optional) ────────────────────────────
              _sectionLabel('Target Audience (leave blank = everyone)'),
              Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  border: Border.all(color: const Color(0xFFD1D5DB)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String?>(
                    value: _targetRole,
                    isExpanded: true,
                    hint: const Text('Role (Everyone)', style: TextStyle(color: Color(0xFF9CA3AF))),
                    items: const [
                      DropdownMenuItem(value: null,    child: Text('Everyone')),
                      DropdownMenuItem(value: 'admin', child: Text('Admins only')),
                    ],
                    onChanged: (v) => setState(() => _targetRole = v),
                  ),
                ),
              ),
              _field(_universityCtrl, 'Target University (optional)'),
              _field(_studyYearCtrl,  'Target Study Year (optional, e.g. 2nd Year)'),

              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _loading ? null : _submit,
                  icon: _loading
                      ? const SizedBox(width: 18, height: 18,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.send_rounded, size: 18),
                  label: const Text('Send', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A1F36),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String label) => Padding(
    padding: const EdgeInsets.only(bottom: 8, top: 4),
    child: Text(label, style: const TextStyle(
      fontSize: 13, fontWeight: FontWeight.w700,
      color: Color(0xFF6B7280), letterSpacing: 0.5,
    )),
  );

  Widget _field(TextEditingController ctrl, String label,
      {bool required = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: ctrl,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border:        OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF4F6EF7), width: 2),
          ),
          filled: true,
          fillColor: const Color(0xFFF9FAFB),
        ),
        validator: required
            ? (v) => (v == null || v.trim().isEmpty) ? '$label is required' : null
            : null,
      ),
    );
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'job_alert': return Icons.work_outline_rounded;
      case 'trending':  return Icons.trending_up_rounded;
      case 'tip':       return Icons.lightbulb_outline_rounded;
      default:          return Icons.campaign_outlined;
    }
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'job_alert': return const Color(0xFF4F6EF7);
      case 'trending':  return const Color(0xFF10B981);
      case 'tip':       return const Color(0xFFF59E0B);
      default:          return const Color(0xFF8B5CF6);
    }
  }
}
