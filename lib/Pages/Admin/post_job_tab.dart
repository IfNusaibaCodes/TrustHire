import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'select_or_type_field.dart';

// ─── POST JOB TAB ─────────────────────────────────────────────────────────────
// Tab 1 of AdminPanelPage. Shows a form to post a new job to Supabase.
// Calls onSuccess(job) when job is inserted successfully.

class PostJobTab extends StatefulWidget {
  final void Function(Map<String, dynamic>) onSuccess;
  const PostJobTab({super.key, required this.onSuccess});

  @override
  State<PostJobTab> createState() => _PostJobTabState();
}

class _PostJobTabState extends State<PostJobTab> {
  final _formKey      = GlobalKey<FormState>();
  final _titleCtrl    = TextEditingController();
  final _companyCtrl  = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _cityCtrl     = TextEditingController();
  final _appUrlCtrl   = TextEditingController();
  final _descCtrl     = TextEditingController();
  final _salaryCtrl   = TextEditingController();

  String _jobType      = 'Full-time';
  String _expLevel     = 'Mid-level';
  String _currency     = '';
  String _country      = '';
  bool   _isRemote     = false;
  bool   _isSubmitting = false;

  static const _jobTypes  = ['Full-time', 'Part-time', 'Contract', 'Freelance', 'Internship'];
  static const _expLevels = ['Entry-level', 'Mid-level', 'Senior', 'Lead', 'Manager', 'Director'];

  static const _currencies = [
    'BDT', 'USD', 'EUR', 'GBP', 'INR',
    'AED', 'SAR', 'MYR', 'SGD', 'CAD', 'AUD',
  ];
  static const _countries = [
    'Bangladesh', 'India', 'Pakistan', 'United States', 'United Kingdom',
    'Canada', 'Australia', 'Germany', 'Singapore', 'UAE',
    'Saudi Arabia', 'Malaysia', 'Netherlands', 'Sweden', 'Remote / Worldwide',
  ];

  @override
  void dispose() {
    for (final c in [
      _titleCtrl, _companyCtrl, _locationCtrl,
      _cityCtrl, _appUrlCtrl, _descCtrl, _salaryCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    // ── TODO(backend): Supabase call এখানে আসবে ──────────────────────────
    // Backend ready হলে নিচের commented code uncomment করুন
    // এবং উপরের mock block টা সরিয়ে দিন
    //
    // final existing = await Supabase.instance.client
    //     .from('jobs')
    //     .select('id')
    //     .eq('application_url', _appUrlCtrl.text.trim())
    //     .maybeSingle();
    //
    // final job = <String, dynamic>{
    //   'title':            _titleCtrl.text.trim(),
    //   'company':          _companyCtrl.text.trim(),
    //   'location':         _locationCtrl.text.trim(),
    //   'city':             _cityCtrl.text.trim(),
    //   'country':          _country,
    //   'has_remote':       _isRemote,
    //   'experience_level': _expLevel,
    //   'job_type':         _jobType,
    //   'salary':           _salaryCtrl.text.trim(),
    //   'currency':         _currency,
    //   'application_url':  _appUrlCtrl.text.trim(),
    //   'description_md':   _descCtrl.text.trim(),
    //   'published':        DateTime.now().toIso8601String(),
    // };
    //
    // await Supabase.instance.client.from('jobs').insert(job);
    // ── TODO(backend) END ─────────────────────────────────────────────────

    // Mock: Frontend test এর জন্য — Supabase ছাড়াই success দেখাবে
    await Future.delayed(const Duration(milliseconds: 600)); // loading দেখানোর জন্য

    final mockJob = <String, dynamic>{
      'title':            _titleCtrl.text.trim(),
      'company':          _companyCtrl.text.trim(),
      'location':         _locationCtrl.text.trim(),
      'city':             _cityCtrl.text.trim(),
      'country':          _country,
      'has_remote':       _isRemote,
      'experience_level': _expLevel,
      'job_type':         _jobType,
      'salary':           '${_salaryCtrl.text.trim()} $_currency'.trim(),
      'currency':         _currency,
      'application_url':  _appUrlCtrl.text.trim(),
      'description_md':   _descCtrl.text.trim(),
      'published':        DateTime.now().toIso8601String(),
    };

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Job posted successfully! (Frontend test mode)'),
          backgroundColor: Color(0xFF006C4B),
          behavior: SnackBarBehavior.floating,
        ),
      );
      widget.onSuccess(mockJob);
      _clearForm();
      setState(() => _isSubmitting = false);
    }
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    for (final c in [
      _titleCtrl, _companyCtrl, _locationCtrl,
      _cityCtrl, _appUrlCtrl, _descCtrl, _salaryCtrl,
    ]) {
      c.clear();
    }
    setState(() {
      _jobType  = 'Full-time';
      _expLevel = 'Mid-level';
      _currency = '';
      _country  = '';
      _isRemote = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Header Banner ─────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A6BFF), Color(0xFF0053D3)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(Icons.work_outline_rounded, color: Colors.white, size: 28),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Post a New Job',
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 16,
                              fontWeight: FontWeight.bold, color: Colors.white)),
                      Text('Fill all fields to publish listing',
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 11,
                              color: Colors.white70)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Job Information ───────────────────────────────────
            _sectionLabel('Job Information'),
            const SizedBox(height: 12),
            _card(children: [
              _field(controller: _titleCtrl, label: 'Job Title *',
                  hint: 'e.g. Senior Flutter Developer', icon: Icons.title_rounded,
                  validator: (v) => (v == null || v.isEmpty) ? 'Job title required' : null),
              const SizedBox(height: 14),
              _field(controller: _companyCtrl, label: 'Company Name *',
                  hint: 'e.g. TrustHire Inc.', icon: Icons.business_rounded,
                  validator: (v) => (v == null || v.isEmpty) ? 'Company name required' : null),
              const SizedBox(height: 14),
              _field(controller: _appUrlCtrl, label: 'Application URL *',
                  hint: 'https://company.com/apply  or  email  or  phone',
                  icon: Icons.link_rounded,
                  keyboardType: TextInputType.url,
                  validator: (v) => (v == null || v.isEmpty) ? 'Application URL required' : null),
            ]),

            const SizedBox(height: 16),

            // ── Job Type & Level ──────────────────────────────────
            _sectionLabel('Job Type & Level'),
            const SizedBox(height: 12),
            _card(children: [
              Row(children: [
                Expanded(child: _dropdown(
                    label: 'Job Type', value: _jobType,
                    items: _jobTypes, icon: Icons.category_outlined,
                    onChanged: (v) => setState(() => _jobType = v!))),
                const SizedBox(width: 12),
                Expanded(child: _dropdown(
                    label: 'Experience Level', value: _expLevel,
                    items: _expLevels, icon: Icons.bar_chart_rounded,
                    onChanged: (v) => setState(() => _expLevel = v!))),
              ]),
              const SizedBox(height: 14),
              _field(
                controller: _salaryCtrl,
                label: 'Salary Amount (Optional)',
                hint: 'e.g. 50,000 – 80,000',
                icon: Icons.attach_money_rounded,
              ),
              const SizedBox(height: 14),
              SelectOrTypeField(
                label: 'Currency (Optional)',
                icon: Icons.currency_exchange_rounded,
                options: _currencies,
                hint: 'Select currency',
                typeHint: 'e.g. BDT, USD, EUR',
                onChanged: (v) => setState(() => _currency = v),
              ),
              const SizedBox(height: 14),
              // Remote toggle
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: _isRemote ? const Color(0xFFEEF4FF) : const Color(0xFFF7F9FC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _isRemote
                        ? const Color(0xFF1A6BFF).withOpacity(0.4)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Row(children: [
                  Icon(Icons.laptop_mac_rounded, size: 18,
                      color: _isRemote ? const Color(0xFF1A6BFF) : const Color(0xFF727687)),
                  const SizedBox(width: 10),
                  const Expanded(child: Text('Remote Job',
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 13,
                          fontWeight: FontWeight.w500, color: Color(0xFF131B2E)))),
                  Switch.adaptive(
                      value: _isRemote,
                      onChanged: (v) => setState(() => _isRemote = v),
                      activeColor: const Color(0xFF1A6BFF)),
                ]),
              ),
            ]),

            const SizedBox(height: 16),

            // ── Location ──────────────────────────────────────────
            _sectionLabel('Location'),
            const SizedBox(height: 12),
            _card(children: [
              _field(controller: _locationCtrl, label: 'Location *',
                  hint: 'e.g. Dhaka, Bangladesh or Remote',
                  icon: Icons.location_on_outlined,
                  validator: (v) => (v == null || v.isEmpty) ? 'Location required' : null),
              const SizedBox(height: 14),
              _field(controller: _cityCtrl, label: 'City (Optional)',
                  hint: 'e.g. Dhaka', icon: Icons.location_city_rounded),
              const SizedBox(height: 14),
              SelectOrTypeField(
                label: 'Country (Optional)',
                icon: Icons.flag_outlined,
                options: _countries,
                hint: 'Select country',
                typeHint: 'e.g. Bangladesh, Germany',
                onChanged: (v) => setState(() => _country = v),
              ),
            ]),

            const SizedBox(height: 16),

            // ── Job Description ───────────────────────────────────
            _sectionLabel('Job Description'),
            const SizedBox(height: 12),
            _card(children: [
              TextFormField(
                controller: _descCtrl,
                maxLines: 8,
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 13,
                    color: Color(0xFF131B2E), height: 1.6),
                decoration: InputDecoration(
                  hintText: 'Write job description in Markdown...\n\n## Responsibilities\n- Task 1\n\n## Requirements\n- Requirement 1',
                  hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 12,
                      color: Color(0xFFADB5BD)),
                  filled: true, fillColor: const Color(0xFFF7F9FC),
                  contentPadding: const EdgeInsets.all(14),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF1A6BFF), width: 1.5)),
                  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFBA1A1A))),
                ),
                validator: (v) => (v == null || v.isEmpty) ? 'Description required' : null,
              ),
            ]),

            const SizedBox(height: 24),

            // ── Buttons ───────────────────────────────────────────
            Row(children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _clearForm,
                  icon: const Icon(Icons.clear_rounded, size: 16),
                  label: const Text('Clear Form',
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 13)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF727687),
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: _isSubmitting ? null : _submit,
                  icon: _isSubmitting
                      ? const SizedBox(width: 16, height: 16,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.publish_rounded, size: 18),
                  label: Text(_isSubmitting ? 'Publishing...' : 'Publish Job',
                      style: const TextStyle(fontFamily: 'Poppins', fontSize: 14,
                          fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A6BFF),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ]),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ── Helper Widgets ─────────────────────────────────────────────────────────

  Widget _sectionLabel(String label) {
    return Row(children: [
      Container(width: 3, height: 16,
          decoration: BoxDecoration(color: const Color(0xFF1A6BFF),
              borderRadius: BorderRadius.circular(4))),
      const SizedBox(width: 8),
      Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 13,
          fontWeight: FontWeight.w700, color: Color(0xFF131B2E), letterSpacing: 0.2)),
    ]);
  }

  Widget _card({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04),
            blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11,
          fontWeight: FontWeight.w600, color: Color(0xFF424655), letterSpacing: 0.3)),
      const SizedBox(height: 6),
      TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: Color(0xFF131B2E)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFFADB5BD)),
          prefixIcon: Icon(icon, size: 18, color: const Color(0xFF727687)),
          filled: true, fillColor: const Color(0xFFF7F9FC),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF1A6BFF), width: 1.5)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFBA1A1A))),
        ),
      ),
    ]);
  }

  Widget _dropdown({
    required String label,
    required String value,
    required List<String> items,
    required IconData icon,
    required void Function(String?) onChanged,
  }) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 11,
          fontWeight: FontWeight.w600, color: Color(0xFF424655), letterSpacing: 0.3)),
      const SizedBox(height: 6),
      DropdownButtonFormField<String>(
        value: value,
        onChanged: onChanged,
        items: items.map((e) => DropdownMenuItem(
            value: e,
            child: Text(e, style: const TextStyle(fontFamily: 'Poppins',
                fontSize: 12, color: Color(0xFF131B2E))))).toList(),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, size: 16, color: const Color(0xFF727687)),
          filled: true, fillColor: const Color(0xFFF7F9FC),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF1A6BFF), width: 1.5)),
        ),
        style: const TextStyle(fontFamily: 'Poppins', fontSize: 12),
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(12),
        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF727687)),
      ),
    ]);
  }
}

