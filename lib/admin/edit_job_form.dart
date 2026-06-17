import 'package:flutter/material.dart';
import '../Model/job_model.dart';
import '../Pages/Job Feed/jobs_database.dart';

class EditJobForm extends StatefulWidget {
  final JobModel job;
  final VoidCallback onSaved;

  const EditJobForm({super.key, required this.job, required this.onSaved});

  @override
  State<EditJobForm> createState() => _EditJobFormState();
}

class _EditJobFormState extends State<EditJobForm> {
  final _formKey = GlobalKey<FormState>();
  bool _loading  = false;

  late final _titleCtrl    = TextEditingController(text: widget.job.title ?? '');
  late final _companyCtrl  = TextEditingController(text: widget.job.companyName ?? '');
  late final _logoCtrl     = TextEditingController(text: widget.job.companyLogo ?? '');
  late final _websiteCtrl  = TextEditingController(text: widget.job.companyWebsiteUrl ?? '');
  late final _locationCtrl = TextEditingController(text: widget.job.location ?? '');
  late final _cityCtrl     = TextEditingController(text: widget.job.cityName ?? '');
  late final _countryCtrl  = TextEditingController(text: widget.job.cityCountryName ?? '');
  late final _appUrlCtrl   = TextEditingController(text: widget.job.applicationUrl ?? '');
  late final _languageCtrl = TextEditingController(text: widget.job.language ?? '');
  late final _currencyCtrl = TextEditingController(text: widget.job.salaryCurrency ?? '');
  late final _descCtrl     = TextEditingController(text: widget.job.descriptionMd ?? '');

  static const _jobTypes  = ['Full-time', 'Part-time', 'Contract', 'Freelance'];
  static const _expLevels = ['Junior', 'Mid-level', 'Senior', 'Lead'];

  late String  _jobType   = _jobTypes.contains(widget.job.typePrimary)
      ? widget.job.typePrimary! : _jobTypes[0];
  late String  _expLevel  = _expLevels.contains(widget.job.experienceLevel)
      ? widget.job.experienceLevel! : _expLevels[1];
  late bool    _hasRemote  = widget.job.hasRemote  ?? false;
  late bool    _isTrending = widget.job.isTrending ?? false;

  @override
  void dispose() {
    for (final c in [_titleCtrl, _companyCtrl, _logoCtrl, _websiteCtrl,
      _locationCtrl, _cityCtrl, _countryCtrl, _appUrlCtrl,
      _languageCtrl, _currencyCtrl, _descCtrl]) { c.dispose(); }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      await JobsDatabaseService.updateJob(widget.job.id, {
        'title':            _titleCtrl.text.trim(),
        'company': {
          'name':        _companyCtrl.text.trim(),
          'logo':        _logoCtrl.text.trim().isEmpty    ? null : _logoCtrl.text.trim(),
          'website_url': _websiteCtrl.text.trim().isEmpty ? null : _websiteCtrl.text.trim(),
        },
        'location': _locationCtrl.text.trim().isEmpty ? null : _locationCtrl.text.trim(),
        'cities':   _cityCtrl.text.trim().isEmpty
            ? []
            : [{'name': _cityCtrl.text.trim(), 'asciiname': _cityCtrl.text.trim(),
                'country': {'name': _countryCtrl.text.trim()}}],
        'types':            [{'name': _jobType}],
        'experience_level': _expLevel,
        'application_url':  _appUrlCtrl.text.trim(),
        'language':         _languageCtrl.text.trim().isEmpty ? null : _languageCtrl.text.trim(),
        'salary_currency':  _currencyCtrl.text.trim().isEmpty ? null : _currencyCtrl.text.trim(),
        'description_md':   _descCtrl.text.trim().isEmpty     ? null : _descCtrl.text.trim(),
        'has_remote':       _hasRemote,
        'is_trending':      _isTrending,
      });

      if (mounted) {
        Navigator.pop(context);
        widget.onSaved();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Job updated successfully'),
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
              Row(
                children: [
                  const Text('Edit Job',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1F36))),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 34, height: 34,
                      decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.close_rounded, size: 18, color: Color(0xFF6B7280)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              _label('Job Info'),
              _field(_titleCtrl,   'Job Title',       required: true),
              _field(_appUrlCtrl,  'Application URL', required: true),
              _field(_locationCtrl,'Location'),
              _field(_languageCtrl,'Language (e.g. English)'),
              _field(_currencyCtrl,'Salary Currency (e.g. USD)'),

              _label('Job Type'),
              _dropdown(_jobType, _jobTypes, (v) => setState(() => _jobType = v!)),

              _label('Experience Level'),
              _dropdown(_expLevel, _expLevels, (v) => setState(() => _expLevel = v!)),

              _label('City & Country'),
              _field(_cityCtrl,    'City'),
              _field(_countryCtrl, 'Country'),

              _label('Company Info'),
              _field(_companyCtrl, 'Company Name', required: true),
              _field(_logoCtrl,    'Company Logo URL'),
              _field(_websiteCtrl, 'Company Website URL'),

              _label('Options'),
              _toggle('Remote available', _hasRemote,  (v) => setState(() => _hasRemote  = v)),
              _toggle('Mark as Trending', _isTrending, (v) => setState(() => _isTrending = v)),

              _label('Description'),
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
                      : const Text('Save Changes',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8, top: 4),
    child: Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
        color: Color(0xFF6B7280), letterSpacing: 0.5)),
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
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF4F6EF7), width: 2)),
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

  Widget _toggle(String label, bool value, void Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600,
              color: Color(0xFF1A1F36))),
          Switch(value: value, onChanged: onChanged,
              activeThumbColor: const Color(0xFF4F6EF7)),
        ],
      ),
    );
  }
}
