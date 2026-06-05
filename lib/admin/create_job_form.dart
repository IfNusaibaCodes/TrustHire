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

  final _titleCtrl = TextEditingController();
  final _companyCtrl = TextEditingController();
  final _logoCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _countryCtrl = TextEditingController();
  final _appUrlCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  String _jobType = 'Full-time';
  String _expLevel = 'Mid-level';
  bool _hasRemote = false;
  bool _isTrending = false;

  final _jobTypes = ['Full-time', 'Part-time', 'Contract', 'Freelance'];
  final _expLevels = ['Junior', 'Mid-level', 'Senior', 'Lead'];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _companyCtrl.dispose();
    _logoCtrl.dispose();
    _locationCtrl.dispose();
    _cityCtrl.dispose();
    _countryCtrl.dispose();
    _appUrlCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    try {
      await JobsDatabaseService.createJob({
        'title': _titleCtrl.text.trim(),
        'company': {
          'name': _companyCtrl.text.trim(),
          'logo': _logoCtrl.text.trim().isEmpty ? null : _logoCtrl.text.trim(),
        },
        'location': _locationCtrl.text.trim().isEmpty ? null : _locationCtrl.text.trim(),
        'cities': _cityCtrl.text.trim().isEmpty
            ? []
            : [
                {
                  'name': _cityCtrl.text.trim(),
                  'asciiname': _cityCtrl.text.trim(),
                  'country': {'name': _countryCtrl.text.trim()},
                }
              ],
        'types': [
          {'name': _jobType}
        ],
        'experience_level': _expLevel,
        'application_url': _appUrlCtrl.text.trim(),
        'description_md': _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
        'has_remote': _hasRemote,
        'is_trending': _isTrending,
        'published': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        Navigator.pop(context);
        widget.onJobCreated();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Job posted successfully'),
            backgroundColor: const Color(0xFF4F6EF7),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
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
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              const Text(
                'Post New Job',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1F36),
                ),
              ),
              const SizedBox(height: 20),

              _field(_titleCtrl, 'Job Title', required: true),
              _field(_companyCtrl, 'Company Name', required: true),
              _field(_logoCtrl, 'Company Logo URL (optional)'),
              _field(_locationCtrl, 'Location (e.g. Remote, New York)'),
              _field(_cityCtrl, 'City'),
              _field(_countryCtrl, 'Country'),
              _field(_appUrlCtrl, 'Application URL', required: true),

              // Job type dropdown
              const Text('Job Type', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1A1F36))),
              const SizedBox(height: 6),
              _dropdown(_jobType, _jobTypes, (v) => setState(() => _jobType = v!)),
              const SizedBox(height: 16),

              // Experience level dropdown
              const Text('Experience Level', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1A1F36))),
              const SizedBox(height: 6),
              _dropdown(_expLevel, _expLevels, (v) => setState(() => _expLevel = v!)),
              const SizedBox(height: 16),

              // Toggles
              _toggle('Remote available', _hasRemote, (v) => setState(() => _hasRemote = v)),
              _toggle('Mark as Trending', _isTrending, (v) => setState(() => _isTrending = v)),

              _field(_descCtrl, 'Description (optional)', maxLines: 4),

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
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('Post Job', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String label,
      {bool required = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: ctrl,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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

  Widget _toggle(String label, bool value, void Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1A1F36))),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF4F6EF7),
          ),
        ],
      ),
    );
  }
}
