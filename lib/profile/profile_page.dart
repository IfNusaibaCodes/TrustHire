import 'package:flutter/material.dart';
import 'package:trust_hire_app/Authentication/Services/auth_service.dart';
import 'package:trust_hire_app/Pages/landing_page.dart';
import 'package:trust_hire_app/profile/profile_models.dart';
import 'package:trust_hire_app/profile/profile_service.dart';
import 'package:trust_hire_app/profile/profile_widgets.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final _authService = AuthService();
  final _service     = ProfileService();

  bool                  isLoading   = true;
  ProfileModel          profile     = ProfileModel();
  List<SkillModel>      skills      = [];
  List<ExperienceModel> experiences = [];
  ProfileStats          stats       = ProfileStats();

  String get _uid       => _authService.getCurrentUid()   ?? '';
  String get _firstName => _authService.getCurrentFName() ?? '';
  String get _lastName  => _authService.getCurrentLName() ?? '';
  String get _email     => _authService.getCurrentEmail() ?? '';

  String get fullName => '$_firstName $_lastName'.trim();

  String get initials {
    final f = _firstName.trim();
    final l = _lastName.trim();
    if (f.isNotEmpty && l.isNotEmpty) return '${f[0]}${l[0]}'.toUpperCase();
    if (f.isNotEmpty) return f[0].toUpperCase();
    return '?';
  }

  int get trustScore {
    int score = 0;
    if (_firstName.isNotEmpty)                 score += 20;
    if ((profile.phone ?? '').isNotEmpty)      score += 15;
    if ((profile.university ?? '').isNotEmpty) score += 15;
    if ((profile.cvUrl ?? '').isNotEmpty)      score += 20;
    if (skills.isNotEmpty)                     score += 15;
    if (profile.universityIdVerified)          score += 15;
    return score;
  }

  double get completeness {
    int filled = 0;
    if (_firstName.isNotEmpty)            filled++;
    if (skills.isNotEmpty)                filled++;
    if ((profile.cvUrl ?? '').isNotEmpty) filled++;
    if (experiences.isNotEmpty)           filled++;
    if (profile.universityIdVerified)     filled++;
    return filled / 5;
  }

  Color get trustColor {
    if (trustScore >= 80) return const Color(0xFF10B981);
    if (trustScore >= 50) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  String get trustLabel {
    if (trustScore >= 80) return 'Safe Profile ✅';
    if (trustScore >= 50) return 'Moderate Profile';
    return 'Complete your profile';
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadAll());
  }

  Future<void> _loadAll() async {
    setState(() => isLoading = true);
    final uid = _uid;
    final results = await Future.wait([
      _service.loadProfile(uid),
      _service.loadSkills(uid),
      _service.loadExperiences(uid),
      _service.loadStats(uid),
    ]);
    if (mounted) {
      setState(() {
        profile     = results[0] as ProfileModel;
        skills      = results[1] as List<SkillModel>;
        experiences = results[2] as List<ExperienceModel>;
        stats       = results[3] as ProfileStats;
        isLoading   = false;
      });
    }
  }

  Future<void> _updateProfile(Map<String, dynamic> updates) async {
    await _service.updateProfile(_uid, updates);
    setState(() => profile = profile.copyWith(updates));
    _showSnack('Profile updated ✅');
  }

  Future<void> _addSkill(String name) async {
    if (name.trim().isEmpty) return;
    final skill = await _service.addSkill(_uid, name);
    setState(() => skills.add(skill));
    _showSnack('Skill added ✅');
  }

  Future<void> _deleteSkill(String skillId) async {
    await _service.deleteSkill(skillId);
    setState(() => skills.removeWhere((s) => s.id == skillId));
    _showSnack('Skill removed');
  }

  Future<void> _addExperience(Map<String, dynamic> data) async {
    final exp = await _service.addExperience(_uid, data);
    setState(() => experiences.insert(0, exp));
    _showSnack('Experience added ✅');
  }

  Future<void> _deleteExperience(String expId) async {
    await _service.deleteExperience(expId);
    setState(() => experiences.removeWhere((e) => e.id == expId));
    _showSnack('Experience removed');
  }

  void _logout() async {
    try {
      await _authService.signOut();
      if (mounted) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const LandingPage()));
      }
    } catch (e) {
      _showSnack('Error signing out: $e', isError: true);
    }
  }

  void _showEditSheet() {
    final phoneCtrl    = TextEditingController(text: profile.phone       ?? '');
    final locationCtrl = TextEditingController(text: profile.location    ?? '');
    final uniCtrl      = TextEditingController(text: profile.university  ?? '');
    final yearCtrl     = TextEditingController(text: profile.studyYear   ?? '');
    final bioCtrl      = TextEditingController(text: profile.bio         ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => bottomSheetWrapper(
        context: context,
        title: 'Edit Profile',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            profileField('Phone',        phoneCtrl,    '+880 17xx-xxxxxx'),
            profileField('Location',     locationCtrl, 'City, Bangladesh'),
            profileField('University',   uniCtrl,      'e.g. SUST, BUET'),
            profileField('Year / Batch', yearCtrl,     'e.g. 3rd Year'),
            profileField('Bio',          bioCtrl,      'A short intro about yourself', lines: 3),
            const SizedBox(height: 20),
            primaryButton('Save Changes', () {
              Navigator.pop(context);
              _updateProfile({
                'phone':      phoneCtrl.text.trim(),
                'location':   locationCtrl.text.trim(),
                'university': uniCtrl.text.trim(),
                'study_year': yearCtrl.text.trim(),
                'bio':        bioCtrl.text.trim(),
              });
            }),
          ],
        ),
      ),
    );
  }

  void _showAddSkillSheet() {
    final ctrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => bottomSheetWrapper(
        context: context,
        title: 'Add Skill',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            profileField('Skill Name', ctrl, 'e.g. Flutter, Python, UI/UX',
                autofocus: true),
            const SizedBox(height: 20),
            primaryButton('Add Skill', () {
              if (ctrl.text.trim().isEmpty) return;
              Navigator.pop(context);
              _addSkill(ctrl.text.trim());
            }),
          ],
        ),
      ),
    );
  }

  void _showAddExpSheet() {
    final titleCtrl   = TextEditingController();
    final companyCtrl = TextEditingController();
    final startCtrl   = TextEditingController();
    final endCtrl     = TextEditingController();
    bool isCurrent    = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheet) => bottomSheetWrapper(
          context: context,
          title: 'Add Experience',
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              profileField('Job / Intern Title', titleCtrl,   'e.g. Flutter Intern'),
              profileField('Company',            companyCtrl, 'e.g. TechCo BD'),
              profileField('Start Date',         startCtrl,   'e.g. Jun 2024'),
              if (!isCurrent)
                profileField('End Date', endCtrl, 'e.g. Aug 2024'),
              Row(
                children: [
                  Checkbox(
                    value: isCurrent,
                    activeColor: primary,
                    onChanged: (v) => setSheet(() => isCurrent = v ?? false),
                  ),
                  const Text('I currently work here',
                      style: TextStyle(fontSize: 13, color: textDark)),
                ],
              ),
              const SizedBox(height: 12),
              primaryButton('Add Experience', () {
                if (titleCtrl.text.trim().isEmpty ||
                    companyCtrl.text.trim().isEmpty) return;
                Navigator.pop(context);
                _addExperience({
                  'title':      titleCtrl.text.trim(),
                  'company':    companyCtrl.text.trim(),
                  'start':      startCtrl.text.trim(),
                  'end':        isCurrent ? 'Present' : endCtrl.text.trim(),
                  'is_current': isCurrent,
                });
              }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator(color: primary))
            : RefreshIndicator(
          color: primary,
          onRefresh: _loadAll,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [

                Container(
                  width: double.infinity,
                  color: primary,
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.shield,
                              color: Colors.white, size: 26),
                          const SizedBox(width: 6),
                          const Text('TrustHire',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(
                                Icons.notifications_outlined,
                                color: Colors.white, size: 24),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.logout,
                                color: Colors.white, size: 22),
                            onPressed: _logout,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: 72, height: 72,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.4),
                                      width: 3),
                                ),
                                child: Center(
                                  child: Text(initials,
                                      style: const TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                          color: primary)),
                                ),
                              ),
                              if (profile.universityIdVerified)
                                Positioned(
                                  bottom: 2, right: 2,
                                  child: Container(
                                    width: 20, height: 20,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF10B981),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: primary, width: 2),
                                    ),
                                    child: const Icon(Icons.check,
                                        size: 11, color: Colors.white),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  fullName.isEmpty ? 'Your Name' : fullName,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 3),
                                if ((profile.university ?? '').isNotEmpty ||
                                    (profile.studyYear ?? '').isNotEmpty)
                                  Text(
                                    [profile.university, profile.studyYear]
                                        .where((s) => (s ?? '').isNotEmpty)
                                        .join(' · '),
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 13),
                                  ),
                                const SizedBox(height: 6),
                                if (profile.universityIdVerified)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.verified,
                                            size: 13, color: Colors.white),
                                        SizedBox(width: 4),
                                        Text('Verified Student',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        children: [
                          statCard(Icons.send_outlined,
                              stats.appliedCount.toString(), 'Applied'),
                          const SizedBox(width: 10),
                          statCard(Icons.remove_red_eye_outlined,
                              stats.profileViews.toString(), 'Profile Views'),
                          const SizedBox(width: 10),
                          statCard(Icons.bookmark_border,
                              stats.savedCount.toString(), 'Saved Jobs'),
                        ],
                      ),
                      const SizedBox(height: 14),

                      profileCard(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text('Profile Completeness',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: textDark)),
                              const Spacer(),
                              Text('${(completeness * 100).toInt()}%',
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: primary)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: completeness,
                              minHeight: 8,
                              backgroundColor: primary.withOpacity(0.12),
                              valueColor: const AlwaysStoppedAnimation<Color>(primary),
                            ),
                          ),
                          const SizedBox(height: 12),
                          completenessStep('Basic info added',    _firstName.isNotEmpty),
                          completenessStep('Skills added',        skills.isNotEmpty),
                          completenessStep('Upload CV / Resume',  (profile.cvUrl ?? '').isNotEmpty),
                          completenessStep('Add work experience', experiences.isNotEmpty),
                          completenessStep('Link university ID',  profile.universityIdVerified),
                        ],
                      )),
                      const SizedBox(height: 14),

                      profileCard(child: Column(
                        children: [
                          sectionHeader(
                            icon: Icons.person_outline,
                            title: 'Basic Info',
                            action: 'Edit',
                            actionIcon: Icons.edit_outlined,
                            onAction: _showEditSheet,
                          ),
                          const SizedBox(height: 10),
                          infoRow(Icons.mail_outline,
                              _email.isEmpty ? '—' : _email),
                          infoRow(Icons.phone_outlined,
                              (profile.phone ?? '').isEmpty ? '—' : profile.phone!),
                          infoRow(Icons.location_on_outlined,
                              (profile.location ?? '').isEmpty ? '—' : profile.location!),
                          infoRow(Icons.school_outlined,
                              (profile.university ?? '').isEmpty ? '—' : profile.university!),
                          if ((profile.bio ?? '').isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Text(profile.bio!,
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: textGrey,
                                    height: 1.5)),
                          ],
                        ],
                      )),
                      const SizedBox(height: 14),

                      profileCard(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sectionHeader(
                            icon: Icons.build_outlined,
                            title: 'Skills',
                            action: 'Add',
                            actionIcon: Icons.add_circle_outline,
                            onAction: _showAddSkillSheet,
                          ),
                          const SizedBox(height: 10),
                          if (skills.isEmpty)
                            const Text('No skills yet. Tap Add to get started.',
                                style: TextStyle(fontSize: 13, color: textGrey))
                          else
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: skills.map((skill) {
                                return GestureDetector(
                                  onLongPress: () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(18)),
                                        title: const Text('Remove Skill?'),
                                        content: Text('Remove "${skill.name}" from your profile?'),
                                        actions: [
                                          TextButton(
                                              onPressed: () => Navigator.pop(ctx),
                                              child: const Text('Cancel')),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(ctx);
                                              _deleteSkill(skill.id);
                                            },
                                            child: const Text('Remove',
                                                style: TextStyle(color: Colors.red)),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: primary.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          color: primary.withOpacity(0.2)),
                                    ),
                                    child: Text(skill.name,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: primary)),
                                  ),
                                );
                              }).toList(),
                            ),
                        ],
                      )),
                      const SizedBox(height: 14),

                      profileCard(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sectionHeader(
                            icon: Icons.work_outline,
                            title: 'Experience',
                            action: 'Add',
                            actionIcon: Icons.add_circle_outline,
                            onAction: _showAddExpSheet,
                          ),
                          const SizedBox(height: 10),
                          if (experiences.isEmpty)
                            const Text(
                                'No experience yet. Add your internships or jobs.',
                                style: TextStyle(fontSize: 13, color: textGrey))
                          else
                            ...experiences.map((exp) => Dismissible(
                              key: Key(exp.id),
                              direction: DismissDirection.endToStart,
                              onDismissed: (_) => _deleteExperience(exp.id),
                              background: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade400,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 16),
                                child: const Icon(Icons.delete_outline,
                                    color: Colors.white),
                              ),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: bgColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border: const Border(
                                    left: BorderSide(color: primary, width: 3),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(exp.title,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: textDark)),
                                    const SizedBox(height: 3),
                                    Text(
                                      '${exp.company} · ${exp.startDate ?? ''}${exp.endDate != null ? ' – ${exp.endDate}' : ''}',
                                      style: const TextStyle(
                                          fontSize: 12, color: textGrey),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                        ],
                      )),
                      const SizedBox(height: 14),

                      profileCard(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sectionHeader(
                            icon: Icons.shield_outlined,
                            title: 'Trust Score',
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: primary.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 48, height: 48,
                                  decoration: BoxDecoration(
                                    color: primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.verified_user_outlined,
                                      color: primary, size: 26),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(trustLabel,
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: trustColor)),
                                      const SizedBox(height: 3),
                                      Text(
                                        profile.universityIdVerified
                                            ? 'Verified email · Student ID linked'
                                            : 'Complete profile to raise score',
                                        style: const TextStyle(
                                            fontSize: 11, color: textGrey),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text('$trustScore',
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.w900,
                                            color: trustColor)),
                                    const Text('/ 100',
                                        style: TextStyle(
                                            fontSize: 11, color: textGrey)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                      const SizedBox(height: 14),

                      profileCard(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sectionHeader(
                            icon: Icons.description_outlined,
                            title: 'Resume / CV',
                            action: 'Upload',
                            actionIcon: Icons.upload_outlined,
                            onAction: () => _showSnack('CV upload coming soon!'),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: primary.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.picture_as_pdf_outlined,
                                    color: primary, size: 28),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (profile.cvUrl ?? '').isNotEmpty
                                          ? 'CV Uploaded ✅'
                                          : 'No CV uploaded yet',
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: textDark),
                                    ),
                                    const SizedBox(height: 2),
                                    const Text(
                                      'Upload PDF or generate from profile',
                                      style: TextStyle(fontSize: 11, color: textGrey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSnack(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg,
          style: const TextStyle(fontWeight: FontWeight.w600)),
      backgroundColor:
      isError ? const Color(0xFFEF4444) : const Color(0xFF10B981),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: const EdgeInsets.all(16),
    ));
  }
}