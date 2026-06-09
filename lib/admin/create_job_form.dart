import 'package:flutter/material.dart';
import '../Pages/Job Feed/jobs_database.dart';

class CreateJobForm extends StatefulWidget {
  final VoidCallback onJobCreated;
  const CreateJobForm({super.key, required this.onJobCreated});

  @override
  State<CreateJobForm> createState() => _CreateJobFormState();
}

class _CreateJobFormState extends State<CreateJobForm> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  // Controllers
  final _titleCtrl       = TextEditingController();
  final _companyCtrl     = TextEditingController();
  final _logoCtrl        = TextEditingController();
  final _websiteCtrl     = TextEditingController();
  final _linkedinCtrl    = TextEditingController();
  final _locationCtrl    = TextEditingController();
  final _cityCtrl        = TextEditingController();
  final _countryCtrl     = TextEditingController();
  final _appUrlCtrl      = TextEditingController();
  final _languageCtrl    = TextEditingController();
  final _currencyCtrl    = TextEditingController();
  final _descCtrl        = TextEditingController();

  String  _jobType    = 'Full-time';
  String? _jobType2;
  String  _expLevel   = 'Mid-level';
  bool    _hasRemote  = false;
  bool    _isTrending = false;
  bool    _isAgency   = false;

  static const _jobTypes  = ['Full-time', 'Part-time', 'Contract', 'Freelance'];
  static const _expLevels = ['Junior', 'Mid-level', 'Senior', 'Lead'];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _companyCtrl.dispose();
    _logoCtrl.dispose();
    _websiteCtrl.dispose();
    _linkedinCtrl.dispose();
    _locationCtrl.dispose();
    _cityCtrl.dispose();
    _countryCtrl.dispose();
    _appUrlCtrl.dispose();
    _languageCtrl.dispose();
    _currencyCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      final types = [
        {'name': _jobType},
        if (_jobType2 != null) {'name': _jobType2},
      ];

      await JobsDatabaseService.createJob({
        'title':            _titleCtrl.text.trim(),
        'company': {
          'name':        _companyCtrl.text.trim(),
          'logo':        _logoCtrl.text.trim().isEmpty    ? null : _logoCtrl.text.trim(),
          'website_url': _websiteCtrl.text.trim().isEmpty ? null : _websiteCtrl.text.trim(),
          'linkedin_url':_linkedinCtrl.text.trim().isEmpty? null : _linkedinCtrl.text.trim(),
          'is_agency':   _isAgency,
        },
        'location':         _locationCtrl.text.trim().isEmpty ? null : _locationCtrl.text.trim(),
        'cities':           _cityCtrl.text.trim().isEmpty
            ? []
            : [{'name': _cityCtrl.text.trim(), 'asciiname': _cityCtrl.text.trim(), 'country': {'name': _countryCtrl.text.trim()}}],
        'types':            types,
        'experience_level': _expLevel,
        'application_url':  _appUrlCtrl.text.trim(),
        'language':         _languageCtrl.text.trim().isEmpty ? null : _languageCtrl.text.trim(),
        'salary_currency':  _currencyCtrl.text.trim().isEmpty ? null : _currencyCtrl.text.trim(),
        'description_md':   _descCtrl.text.trim().isEmpty     ? null : _descCtrl.text.trim(),
        'has_remote':       _hasRemote,
        'is_trending':      _isTrending,
        'published':        DateTime.now().toIso8601String(),
      });

      if (mounted) {
        Navigator.pop(context);
        widget.onJobCreated();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Job posted successfully'),
          backgroundColor: const Color(0xFF4F6EF7),
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

              // ── Header row: title + close button ──────────────
              Row(
                children: [
                  const Text(
                    'Post New Job',
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

              // ── Job info ───────────────────────────────────────
              _sectionLabel('Job Info'),
              _field(_titleCtrl,   'Job Title',        required: true),
              _field(_appUrlCtrl,  'Application URL',  required: true),
              _field(_locationCtrl,'Location (e.g. Remote, New York)'),
              _field(_languageCtrl,'Language (e.g. English)'),
              _field(_currencyCtrl,'Salary Currency (e.g. USD)'),

              // Primary job type
              _sectionLabel('Primary Job Type'),
              _dropdown(_jobType, _jobTypes, (v) => setState(() => _jobType = v!)),

              // Secondary job type
              _sectionLabel('Secondary Job Type (optional)'),
              _dropdownNullable(_jobType2, _jobTypes, (v) => setState(() => _jobType2 = v)),

              // Experience level
              _sectionLabel('Experience Level'),
              _dropdown(_expLevel, _expLevels, (v) => setState(() => _expLevel = v!)),

              // ── Location ───────────────────────────────────────
              _sectionLabel('City & Country'),
              _field(_cityCtrl,    'City'),
              _field(_countryCtrl, 'Country'),

              // ── Company info ───────────────────────────────────
              _sectionLabel('Company Info'),
              _field(_companyCtrl,  'Company Name',       required: true),
              _field(_logoCtrl,     'Company Logo URL'),
              _field(_websiteCtrl,  'Company Website URL'),
              _field(_linkedinCtrl, 'Company LinkedIn URL'),

              // ── Toggles ────────────────────────────────────────
              _sectionLabel('Options'),
              _toggle('Remote available',   _hasRemote,  (v) => setState(() => _hasRemote  = v)),
              _toggle('Mark as Trending',   _isTrending, (v) => setState(() => _isTrending = v)),
              _toggle('Company is Agency',  _isAgency,   (v) => setState(() => _isAgency   = v)),

              // ── Description ────────────────────────────────────
              _sectionLabel('Description'),
              _field(_descCtrl, 'Job description (optional)', maxLines: 4),

              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A1F36),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: _loading
                      ? const SizedBox(width: 22, height: 22,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Post Job', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

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

  Widget _dropdown(String value, List<String> items, void Function(String?) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        border: Border.all(color: const Color(0xFFD1D5DB)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // Nullable dropdown with a "None" option
  Widget _dropdownNullable(String? value, List<String> items, void Function(String?) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        border: Border.all(color: const Color(0xFFD1D5DB)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: value,
          isExpanded: true,
          items: [
            const DropdownMenuItem<String?>(value: null, child: Text('None', style: TextStyle(color: Color(0xFF9CA3AF)))),
            ...items.map((e) => DropdownMenuItem(value: e, child: Text(e))),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _toggle(String label, bool value, void Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1A1F36))),
          Switch(value: value, onChanged: onChanged, activeThumbColor: const Color(0xFF4F6EF7)),
        ],
      ),
    );
  }
}
