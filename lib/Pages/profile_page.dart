// ============================================================
//  FILE: lib/Pages/profile_page.dart
// ============================================================
//
//  ── CURRENT MODE: FRONTEND / UI TESTING ──────────────────
//  All Supabase calls are commented out.
//  Dummy data is used so you can test every UI element.
//
//  ── WHEN BACKEND IS READY ────────────────────────────────
//  1. Remove dummy data block (marked with 🟡 DUMMY DATA)
//  2. Uncomment _loadAll() in initState (marked with 🔵 BACKEND)
//  3. Uncomment all Supabase methods (loadProfile, addSkill, etc.)
//
//  ── SUPABASE TABLES (run once when backend phase starts) ──
//
//  create table profiles (
//    id                      uuid references auth.users(id) primary key,
//    phone                   text,
//    location                text,
//    university              text,
//    study_year              text,
//    bio                     text,
//    cv_url                  text,
//    university_id_verified  boolean default false,
//    created_at              timestamp default now(),
//    updated_at              timestamp default now()
//  );
//
//  create table skills (
//    id         uuid default gen_random_uuid() primary key,
//    user_id    uuid references auth.users(id),
//    name       text not null,
//    created_at timestamp default now()
//  );
//
//  create table experiences (
//    id          uuid default gen_random_uuid() primary key,
//    user_id     uuid references auth.users(id),
//    title       text not null,
//    company     text not null,
//    start_date  text,
//    end_date    text,
//    is_current  boolean default false,
//    created_at  timestamp default now()
//  );
//
//  create table profile_stats (
//    user_id        uuid references auth.users(id) primary key,
//    applied_count  int default 0,
//    saved_count    int default 0,
//    profile_views  int default 0
//  );
//
// ============================================================

import 'package:flutter/material.dart';
import 'package:trust_hire_app/Authentication/Services/auth_service.dart';
import 'package:trust_hire_app/Pages/landing_page.dart';
// 🔵 BACKEND: uncomment this when wiring up Supabase
// import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  // ── AUTH SERVICE ──────────────────────────────────────────
  final authService = AuthService();

  // 🔵 BACKEND: uncomment when wiring Supabase
  // final supabase = Supabase.instance.client;

  // ── LOADING STATE ─────────────────────────────────────────
  bool isLoading = true;

  // ── PROFILE DATA ──────────────────────────────────────────
  // 🔵 BACKEND: replace with → Map<String, dynamic> profile = {};
  Map<String, dynamic> profile = {};

  // ── SKILLS ────────────────────────────────────────────────
  // 🔵 BACKEND: replace with → List<Map<String, dynamic>> skills = [];
  List<Map<String, dynamic>> skills = [];

  // ── EXPERIENCES ───────────────────────────────────────────
  // 🔵 BACKEND: replace with → List<Map<String, dynamic>> experiences = [];
  List<Map<String, dynamic>> experiences = [];

  // ── STATS ─────────────────────────────────────────────────
  // 🔵 BACKEND: these will be loaded from profile_stats table
  int appliedCount = 0;
  int profileViews = 0;
  int savedCount   = 0;

  // ── COLORS ───────────────────────────────────────────────
  static const Color primary  = Color(0xFF3B5BDB);
  static const Color bgColor  = Color(0xFFF5F6FA);
  static const Color textDark = Color(0xFF1A1A2E);
  static const Color textGrey = Color(0xFF9CA3AF);
  static const Color success  = Color(0xFF10B981);

  // ── TRUST SCORE (computed locally, no backend needed) ─────
  int get trustScore {
    int score = 0;
    final fName  = _firstName;
    final phone  = profile['phone']?.toString()      ?? '';
    final uni    = profile['university']?.toString() ?? '';
    final cvUrl  = profile['cv_url']?.toString()     ?? '';
    final verified = profile['university_id_verified'] == true;

    if (fName.isNotEmpty) score += 20;
    if (phone.isNotEmpty) score += 15;
    if (uni.isNotEmpty)   score += 15;
    if (cvUrl.isNotEmpty) score += 20;
    if (skills.isNotEmpty) score += 15;
    if (verified) score += 15;
    return score;
  }

  // ── PROFILE COMPLETENESS ──────────────────────────────────
  double get completeness {
    int filled = 0;
    const int total = 5;
    if (_firstName.isNotEmpty) filled++;
    if (skills.isNotEmpty) filled++;
    if ((profile['cv_url'] ?? '').toString().isNotEmpty) filled++;
    if (experiences.isNotEmpty) filled++;
    if (profile['university_id_verified'] == true) filled++;
    return filled / total;
  }

  Color get trustColor {
    if (trustScore >= 80) return success;
    if (trustScore >= 50) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  String get trustLabel {
    if (trustScore >= 80) return 'Safe Profile ✅';
    if (trustScore >= 50) return 'Moderate Profile';
    return 'Complete your profile';
  }

  // ── HELPERS: name + initials ──────────────────────────────
  // 🔵 BACKEND: these read from AuthService (auth metadata)
  // During frontend testing we use dummy strings below.
  // When AuthService is connected they will auto-populate.

  // 🟡 DUMMY DATA: change to authService.getCurrentFName() ?? ''
  String get _firstName => 'Anika';

  // 🟡 DUMMY DATA: change to authService.getCurrentLName() ?? ''
  String get _lastName  => 'Tarannum';

  // 🟡 DUMMY DATA: change to authService.getCurrentEmail() ?? ''
  String get _email => 'anikatarannum@gmail.com';

  String get initials {
    final f = _firstName.trim();
    final l = _lastName.trim();
    if (f.isNotEmpty && l.isNotEmpty) return '${f[0]}${l[0]}'.toUpperCase();
    if (f.isNotEmpty) return f[0].toUpperCase();
    return '?';
  }

  String get fullName => '$_firstName $_lastName'.trim();

  // ════════════════════════════════════════════════════════════
  //  INIT STATE
  // ════════════════════════════════════════════════════════════
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAll();
    });
  }

  // ════════════════════════════════════════════════════════════
  //  _loadAll
  //  🟡 FRONTEND MODE: loads dummy data and stops spinner
  //  🔵 BACKEND MODE:  uncomment Future.wait block below
  // ════════════════════════════════════════════════════════════
  Future<void> _loadAll() async {
    setState(() => isLoading = true);

    // ── 🟡 DUMMY DATA: simulates a brief network delay ────────
    await Future.delayed(const Duration(milliseconds: 400));
    _loadDummyData();

    // ── 🔵 BACKEND: replace above 2 lines with this block ─────
    // await Future.wait([
    //   loadProfile(),
    //   loadSkills(),
    //   loadExperiences(),
    //   loadStats(),
    // ]);

    if (mounted) setState(() => isLoading = false);
  }

  // ════════════════════════════════════════════════════════════
  //  🟡 DUMMY DATA LOADER
  //  Remove this entire method when switching to backend.
  // ════════════════════════════════════════════════════════════
  void _loadDummyData() {
    profile = {
      'phone':                  '01759613090',
      'location':               'Sylhet, Bangladesh',
      'university':             'Leading University',
      'study_year':             '3rd Year',
      'bio':                    'Flutter developer passionate about building clean, user-friendly apps.',
      'cv_url':                 '',               // set to any string to test "CV Uploaded ✅"
      'university_id_verified': false,            // set to true to test verified badge
    };

    skills = [
      {'id': 'sk-1', 'name': 'Flutter'},
      {'id': 'sk-2', 'name': 'Dart'},
      {'id': 'sk-3', 'name': 'UI/UX'},
      {'id': 'sk-4', 'name': 'Firebase'},
    ];

    experiences = [
      {
        'id':         'ex-1',
        'title':      'Flutter Intern',
        'company':    'TechCo BD',
        'start_date': 'Jun 2026',
        'end_date':   'Aug 2025',
        'is_current': false,
      },
      {
        'id':         'ex-2',
        'title':      'Junior Developer',
        'company':    'StartupXYZ',
        'start_date': 'Sep 2024',
        'end_date':   'Present',
        'is_current': true,
      },
    ];

    appliedCount = 7;
    profileViews = 34;
    savedCount   = 12;
  }

  // ════════════════════════════════════════════════════════════
  //  SUPABASE METHODS
  //  🔵 BACKEND: uncomment all methods below when ready
  // ════════════════════════════════════════════════════════════

  // Future<void> loadProfile() async {
  //   try {
  //     final userId = supabase.auth.currentSession?.user.id;
  //     if (userId == null) return;
  //     final response = await supabase
  //         .from('profiles')
  //         .select()
  //         .eq('id', userId)
  //         .maybeSingle();
  //     if (response == null) {
  //       await supabase.from('profiles').insert({'id': userId});
  //       if (mounted) setState(() => profile = {'id': userId});
  //     } else {
  //       if (mounted) setState(() => profile = response);
  //     }
  //   } catch (e) { /* profile stays empty */ }
  // }

  // Future<void> loadSkills() async {
  //   try {
  //     final userId = supabase.auth.currentSession?.user.id;
  //     if (userId == null) return;
  //     final response = await supabase
  //         .from('skills')
  //         .select()
  //         .eq('user_id', userId)
  //         .order('created_at');
  //     if (mounted) setState(() => skills = List<Map<String, dynamic>>.from(response));
  //   } catch (e) { /* skills stays empty */ }
  // }

  // Future<void> loadExperiences() async {
  //   try {
  //     final userId = supabase.auth.currentSession?.user.id;
  //     if (userId == null) return;
  //     final response = await supabase
  //         .from('experiences')
  //         .select()
  //         .eq('user_id', userId)
  //         .order('created_at', ascending: false);
  //     if (mounted) setState(() => experiences = List<Map<String, dynamic>>.from(response));
  //   } catch (e) { /* experiences stays empty */ }
  // }

  // Future<void> loadStats() async {
  //   try {
  //     final userId = supabase.auth.currentSession?.user.id;
  //     if (userId == null) return;
  //     final response = await supabase
  //         .from('profile_stats')
  //         .select()
  //         .eq('user_id', userId)
  //         .maybeSingle();
  //     if (response == null) {
  //       await supabase.from('profile_stats').insert({
  //         'user_id': userId, 'applied_count': 0, 'saved_count': 0, 'profile_views': 0,
  //       });
  //     } else {
  //       if (mounted) setState(() {
  //         appliedCount = response['applied_count'] ?? 0;
  //         savedCount   = response['saved_count']   ?? 0;
  //         profileViews = response['profile_views'] ?? 0;
  //       });
  //     }
  //   } catch (e) { /* stats stay 0 */ }
  // }

  // Future<void> updateProfile(Map<String, dynamic> updates) async {
  //   try {
  //     final userId = supabase.auth.currentSession?.user.id;
  //     if (userId == null) return;
  //     await supabase.from('profiles').update({
  //       ...updates,
  //       'updated_at': DateTime.now().toIso8601String(),
  //     }).eq('id', userId);
  //     setState(() => profile = {...profile, ...updates});
  //     _showSnack('Profile updated ✅');
  //   } catch (e) {
  //     _showSnack('Could not update profile', isError: true);
  //   }
  // }

  // Future<void> addSkill(String name) async {
  //   if (name.trim().isEmpty) return;
  //   try {
  //     final userId = supabase.auth.currentSession?.user.id;
  //     if (userId == null) return;
  //     final response = await supabase
  //         .from('skills')
  //         .insert({'user_id': userId, 'name': name.trim()})
  //         .select()
  //         .single();
  //     setState(() => skills.add(response));
  //     _showSnack('Skill added ✅');
  //   } catch (e) {
  //     _showSnack('Could not add skill', isError: true);
  //   }
  // }

  // Future<void> deleteSkill(String skillId) async {
  //   try {
  //     await supabase.from('skills').delete().eq('id', skillId);
  //     setState(() => skills.removeWhere((s) => s['id'] == skillId));
  //     _showSnack('Skill removed');
  //   } catch (e) {
  //     _showSnack('Could not remove skill', isError: true);
  //   }
  // }

  // Future<void> addExperience(Map<String, dynamic> data) async {
  //   try {
  //     final userId = supabase.auth.currentSession?.user.id;
  //     if (userId == null) return;
  //     final response = await supabase.from('experiences').insert({
  //       'user_id':    userId,
  //       'title':      data['title'],
  //       'company':    data['company'],
  //       'start_date': data['start'],
  //       'end_date':   data['end'],
  //       'is_current': data['is_current'] ?? false,
  //     }).select().single();
  //     setState(() => experiences.insert(0, response));
  //     _showSnack('Experience added ✅');
  //   } catch (e) {
  //     _showSnack('Could not add experience', isError: true);
  //   }
  // }

  // Future<void> deleteExperience(String expId) async {
  //   try {
  //     await supabase.from('experiences').delete().eq('id', expId);
  //     setState(() => experiences.removeWhere((e) => e['id'] == expId));
  //     _showSnack('Experience removed');
  //   } catch (e) {
  //     _showSnack('Could not remove', isError: true);
  //     loadExperiences();
  //   }
  // }

  // ════════════════════════════════════════════════════════════
  //  🟡 FRONTEND VERSIONS of write methods
  //  These update local state only — no Supabase calls.
  //  🔵 BACKEND: delete these and uncomment the real ones above.
  // ════════════════════════════════════════════════════════════

  // ── Update profile (local only) ──────────────────────────
  Future<void> updateProfile(Map<String, dynamic> updates) async {
    setState(() => profile = {...profile, ...updates});
    _showSnack('Profile updated ✅ (UI only — backend not connected yet)');
  }

  // ── Add skill (local only) ────────────────────────────────
  Future<void> addSkill(String name) async {
    if (name.trim().isEmpty) return;
    // Generate a temp local id so the chip can be deleted by id
    final tempId = 'local-${DateTime.now().millisecondsSinceEpoch}';
    setState(() => skills.add({'id': tempId, 'name': name.trim()}));
    _showSnack('Skill added ✅ (UI only)');
  }

  // ── Delete skill (local only) ─────────────────────────────
  Future<void> deleteSkill(String skillId) async {
    setState(() => skills.removeWhere((s) => s['id'] == skillId));
    _showSnack('Skill removed (UI only)');
  }

  // ── Add experience (local only) ───────────────────────────
  Future<void> addExperience(Map<String, dynamic> data) async {
    final tempId = 'local-${DateTime.now().millisecondsSinceEpoch}';
    setState(() => experiences.insert(0, {
      'id':         tempId,
      'title':      data['title'],
      'company':    data['company'],
      'start_date': data['start'],
      'end_date':   data['end'],
      'is_current': data['is_current'] ?? false,
    }));
    _showSnack('Experience added ✅ (UI only)');
  }

  // ── Delete experience (local only) ───────────────────────
  Future<void> deleteExperience(String expId) async {
    setState(() => experiences.removeWhere((e) => e['id'] == expId));
    _showSnack('Experience removed (UI only)');
  }

  // ════════════════════════════════════════════════════════════
  //  SIGN OUT
  // ════════════════════════════════════════════════════════════
  void logout() async {
    try {
      await authService.signOut();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LandingPage()),
        );
      }
    } catch (e) {
      if (mounted) _showSnack('Error signing out: $e', isError: true);
    }
  }

  // ════════════════════════════════════════════════════════════
  //  BOTTOM SHEET: EDIT BASIC INFO
  // ════════════════════════════════════════════════════════════
  void _showEditSheet() {
    final phoneCtrl    = TextEditingController(text: profile['phone']      ?? '');
    final locationCtrl = TextEditingController(text: profile['location']   ?? '');
    final uniCtrl      = TextEditingController(text: profile['university'] ?? '');
    final yearCtrl     = TextEditingController(text: profile['study_year'] ?? '');
    final bioCtrl      = TextEditingController(text: profile['bio']        ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _bottomSheet(
        title: 'Edit Profile',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _field('Phone',        phoneCtrl,    '+880 17xx-xxxxxx'),
            _field('Location',     locationCtrl, 'City, Bangladesh'),
            _field('University',   uniCtrl,      'e.g. SUST, BUET'),
            _field('Year / Batch', yearCtrl,     'e.g. 3rd Year'),
            _field('Bio',          bioCtrl,      'A short intro about yourself', lines: 3),
            const SizedBox(height: 20),
            _primaryButton('Save Changes', () {
              Navigator.pop(context);
              updateProfile({
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

  // ════════════════════════════════════════════════════════════
  //  BOTTOM SHEET: ADD SKILL
  // ════════════════════════════════════════════════════════════
  void _showAddSkillSheet() {
    final ctrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _bottomSheet(
        title: 'Add Skill',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _field('Skill Name', ctrl, 'e.g. Flutter, Python, UI/UX',
                autofocus: true),
            const SizedBox(height: 20),
            _primaryButton('Add Skill', () {
              if (ctrl.text.trim().isEmpty) return;
              Navigator.pop(context);
              addSkill(ctrl.text.trim());
            }),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  //  BOTTOM SHEET: ADD EXPERIENCE
  // ════════════════════════════════════════════════════════════
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
        builder: (ctx, setSheet) => _bottomSheet(
          title: 'Add Experience',
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _field('Job / Intern Title', titleCtrl,   'e.g. Flutter Intern'),
              _field('Company',            companyCtrl, 'e.g. TechCo BD'),
              _field('Start Date',         startCtrl,   'e.g. Jun 2024'),
              if (!isCurrent)
                _field('End Date', endCtrl, 'e.g. Aug 2024'),
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
              _primaryButton('Add Experience', () {
                if (titleCtrl.text.trim().isEmpty ||
                    companyCtrl.text.trim().isEmpty) return;
                Navigator.pop(context);
                addExperience({
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

  // ════════════════════════════════════════════════════════════
  //  BUILD
  // ════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {

    final email = _email;
    final phone = profile['phone']?.toString()      ?? '';
    final loc   = profile['location']?.toString()   ?? '';
    final uni   = profile['university']?.toString() ?? '';
    final year  = profile['study_year']?.toString() ?? '';
    final bio   = profile['bio']?.toString()         ?? '';

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

                // ══════════════════════════════════════════
                //  HEADER — blue section
                // ══════════════════════════════════════════
                Container(
                  width: double.infinity,
                  color: primary,
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                  child: Column(
                    children: [

                      // ── Brand row ────────────────────────
                      Row(
                        children: [
                          const Icon(Icons.shield, color: Colors.white, size: 26),
                          const SizedBox(width: 6),
                          const Text('TrustHire',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.notifications_outlined,
                                color: Colors.white, size: 24),
                            onPressed: () {
                              // TODO: navigate to notifications page
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.logout,
                                color: Colors.white, size: 22),
                            onPressed: logout,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // ── Avatar + name row ─────────────────
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          // ── Initials avatar ───────────────
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
                                  child: Text(
                                    initials,
                                    style: const TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        color: primary),
                                  ),
                                ),
                              ),
                              // Green verified dot
                              if (profile['university_id_verified'] == true)
                                Positioned(
                                  bottom: 2, right: 2,
                                  child: Container(
                                    width: 20, height: 20,
                                    decoration: BoxDecoration(
                                      color: success,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: primary, width: 2),
                                    ),
                                    child: const Icon(Icons.check,
                                        size: 11, color: Colors.white),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: 16),

                          // ── Name + university ─────────────
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
                                if (uni.isNotEmpty || year.isNotEmpty)
                                  Text(
                                    [uni, year]
                                        .where((s) => s.isNotEmpty)
                                        .join(' · '),
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 13),
                                  ),
                                const SizedBox(height: 6),
                                // Verified student badge
                                if (profile['university_id_verified'] == true)
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

                // ══════════════════════════════════════════
                //  BODY CONTENT
                // ══════════════════════════════════════════
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // ── STATS ROW ─────────────────────────
                      Row(
                        children: [
                          _statCard(Icons.send_outlined,
                              appliedCount.toString(), 'Applied'),
                          const SizedBox(width: 10),
                          _statCard(Icons.remove_red_eye_outlined,
                              profileViews.toString(), 'Profile Views'),
                          const SizedBox(width: 10),
                          _statCard(Icons.bookmark_border,
                              savedCount.toString(), 'Saved Jobs'),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // ── PROFILE COMPLETENESS ──────────────
                      _card(child: Column(
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
                              Text(
                                '${(completeness * 100).toInt()}%',
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: primary),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: completeness,
                              minHeight: 8,
                              backgroundColor: primary.withOpacity(0.12),
                              valueColor:
                              const AlwaysStoppedAnimation<Color>(primary),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _step('Basic info added',    _firstName.isNotEmpty),
                          _step('Skills added',        skills.isNotEmpty),
                          _step('Upload CV / Resume',  (profile['cv_url'] ?? '').toString().isNotEmpty),
                          _step('Add work experience', experiences.isNotEmpty),
                          _step('Link university ID',  profile['university_id_verified'] == true),
                        ],
                      )),
                      const SizedBox(height: 14),

                      // ── BASIC INFO ─────────────────────────
                      _card(child: Column(
                        children: [
                          _sectionHeader(
                            icon: Icons.person_outline,
                            title: 'Basic Info',
                            action: 'Edit',
                            actionIcon: Icons.edit_outlined,
                            onAction: _showEditSheet,
                          ),
                          const SizedBox(height: 10),
                          _infoRow(Icons.mail_outline,         email.isEmpty ? '—' : email),
                          _infoRow(Icons.phone_outlined,       phone.isEmpty ? '—' : phone),
                          _infoRow(Icons.location_on_outlined, loc.isEmpty   ? '—' : loc),
                          _infoRow(Icons.school_outlined,      uni.isEmpty   ? '—' : uni),
                          if (bio.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Text(bio,
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: textGrey,
                                    height: 1.5)),
                          ],
                        ],
                      )),
                      const SizedBox(height: 14),

                      // ── SKILLS ─────────────────────────────
                      // Long press any chip to delete
                      _card(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionHeader(
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
                                  // Long press → confirm delete dialog
                                  onLongPress: () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(18)),
                                        title: const Text('Remove Skill?'),
                                        content: Text(
                                            'Remove "${skill['name']}" from your profile?'),
                                        actions: [
                                          TextButton(
                                              onPressed: () => Navigator.pop(ctx),
                                              child: const Text('Cancel')),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(ctx);
                                              deleteSkill(skill['id']);
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
                                    child: Text(skill['name'].toString(),
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

                      // ── EXPERIENCE ─────────────────────────
                      // Swipe left on any card to delete
                      _card(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionHeader(
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
                              key: Key(exp['id'].toString()),
                              direction: DismissDirection.endToStart,
                              onDismissed: (_) => deleteExperience(exp['id']),
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
                                    Text(exp['title'].toString(),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: textDark)),
                                    const SizedBox(height: 3),
                                    Text(
                                      '${exp['company']} · '
                                          '${exp['start_date'] ?? ''}${exp['end_date'] != null ? ' – ${exp['end_date']}' : ''}',
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

                      // ── TRUST SCORE ────────────────────────
                      _card(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionHeader(
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
                                  child: const Icon(
                                      Icons.verified_user_outlined,
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
                                        profile['university_id_verified'] == true
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

                      // ── CV / RESUME ────────────────────────
                      // cv_url stored in 'profiles' table.
                      // TODO: add file_picker + Supabase Storage
                      // then call updateProfile({'cv_url': downloadUrl})
                      _card(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionHeader(
                            icon: Icons.description_outlined,
                            title: 'Resume / CV',
                            action: 'Upload',
                            actionIcon: Icons.upload_outlined,
                            onAction: () {
                              // TODO: implement file_picker PDF upload
                              _showSnack('CV upload coming soon!');
                            },
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
                                      (profile['cv_url'] ?? '').toString().isNotEmpty
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
                                      style: TextStyle(
                                          fontSize: 11, color: textGrey),
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

  // ════════════════════════════════════════════════════════════
  //  REUSABLE WIDGET BUILDERS
  // ════════════════════════════════════════════════════════════

  Widget _card({required Widget child}) {
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

  Widget _statCard(IconData icon, String value, String label) {
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
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textDark)),
            const SizedBox(height: 2),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10, color: textGrey)),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader({
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
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: textDark)),
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

  Widget _infoRow(IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, size: 16, color: textGrey),
          const SizedBox(width: 10),
          Expanded(
            child: Text(value,
                style: const TextStyle(fontSize: 13, color: textDark)),
          ),
        ],
      ),
    );
  }

  Widget _step(String label, bool done) {
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

  Widget _bottomSheet({required String title, required Widget child}) {
    return Container(
      padding: EdgeInsets.only(
        left: 24, right: 24, top: 24,
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
                width: 40, height: 4,
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

  Widget _field(String label, TextEditingController ctrl, String hint,
      {int lines = 1, bool autofocus = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: textDark)),
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
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _primaryButton(String label, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        child: Text(label,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _showSnack(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg,
          style: const TextStyle(fontWeight: FontWeight.w600)),
      backgroundColor: isError ? const Color(0xFFEF4444) : success,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: const EdgeInsets.all(16),
    ));
  }
}