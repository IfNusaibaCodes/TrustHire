import 'package:flutter/material.dart';
import 'package:trust_hire_app/profile/profile_models.dart';
import 'package:trust_hire_app/Model/job_model.dart';
import 'growth_database.dart';

class GrowthPage extends StatefulWidget {
  const GrowthPage({super.key});

  @override
  State<GrowthPage> createState() => _GrowthPageState();
}

class _GrowthPageState extends State<GrowthPage> {
  static const _bg      = Color(0xFFF5F6FA);
  static const _primary = Color(0xFF3B5BDB);
  static const _dark    = Color(0xFF1A1A2E);
  static const _grey    = Color(0xFF9CA3AF);
  static const _green   = Color(0xFF10B981);
  static const _weekly  = 5; // weekly application goal

  late Future<_GrowthData> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_GrowthData> _load() async {
    final results = await Future.wait([
      GrowthDatabase.loadStats(),
      GrowthDatabase.loadStreak(),
      GrowthDatabase.loadProfile(),
      GrowthDatabase.loadSkillCount(),
      GrowthDatabase.loadExperienceCount(),
      GrowthDatabase.loadRecentApplied(),
      GrowthDatabase.loadAppliedThisWeek(),
    ]);
    return _GrowthData(
      stats:           results[0] as ProfileStats,
      streak:          results[1] as int,
      profile:         results[2] as ProfileModel,
      skillCount:      results[3] as int,
      experienceCount: results[4] as int,
      recentApplied:   results[5] as List<JobModel>,
      appliedThisWeek: results[6] as int,
    );
  }

  int _profileCompletion(_GrowthData d) {
    int score = 0;
    if ((d.profile.firstName ?? '').isNotEmpty) score++;
    if ((d.profile.bio ?? '').isNotEmpty)       score++;
    if ((d.profile.cvUrl ?? '').isNotEmpty)     score++;
    if (d.skillCount > 0)                       score++;
    if (d.experienceCount > 0)                  score++;
    if (d.profile.universityIdVerified)         score++;
    return ((score / 6) * 100).round();
  }

  List<String> _tips(_GrowthData d) {
    final tips = <String>[];
    if ((d.profile.bio ?? '').isEmpty)      tips.add('Add a bio to your profile');
    if ((d.profile.cvUrl ?? '').isEmpty)    tips.add('Upload your CV');
    if (d.skillCount == 0)                  tips.add('Add your skills to stand out');
    if (d.experienceCount == 0)             tips.add('Add work or internship experience');
    if (!d.profile.universityIdVerified)    tips.add('Verify your university ID');
    if (d.appliedThisWeek < _weekly)        tips.add('Apply to ${_weekly - d.appliedThisWeek} more jobs this week');
    return tips.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: FutureBuilder<_GrowthData>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final d = snap.data!;
          return RefreshIndicator(
            onRefresh: () async {
              setState(() { _future = _load(); });
            },
            child: CustomScrollView(
              slivers: [
                _buildHeader(d),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _statsRow(d),
                      const SizedBox(height: 20),
                      _profileCompletionCard(d),
                      const SizedBox(height: 16),
                      _weeklyGoalCard(d),
                      const SizedBox(height: 16),
                      _recentAppliedCard(d),
                      const SizedBox(height: 16),
                      _tipsCard(d),
                      const SizedBox(height: 80),
                    ]),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(_GrowthData d) {
    final name = (d.profile.firstName ?? '').isNotEmpty
        ? d.profile.firstName!
        : 'there';
    return SliverToBoxAdapter(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A1F36), Color(0xFF2D3561)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.fromLTRB(20, 56, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.trending_up_rounded, color: Colors.white70, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Your Growth',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Hey, $name! 👋',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Here's how your job search is going.",
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statsRow(_GrowthData d) {
    return Row(
      children: [
        Expanded(child: _statCard('Applied', d.stats.appliedCount.toString(), Icons.send_outlined, _primary)),
        const SizedBox(width: 12),
        Expanded(child: _statCard('Saved', d.stats.savedCount.toString(), Icons.bookmark_outline, Colors.orange)),
        const SizedBox(width: 12),
        Expanded(child: _statCard('Streak', '${d.streak}d', Icons.local_fire_department_outlined, _green)),
      ],
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: _dark)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 11, color: _grey)),
        ],
      ),
    );
  }

  Widget _profileCompletionCard(_GrowthData d) {
    final pct = _profileCompletion(d);
    return _card(
      title: 'Profile Completion',
      icon: Icons.person_outline_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$pct% complete', style: TextStyle(fontSize: 13, color: _grey)),
              Text('$pct / 100', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: pct == 100 ? _green : _primary)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: pct / 100,
              minHeight: 8,
              backgroundColor: const Color(0xFFEEF0F8),
              valueColor: AlwaysStoppedAnimation(pct == 100 ? _green : _primary),
            ),
          ),
          const SizedBox(height: 14),
          _completionItem('Name added',           (d.profile.firstName ?? '').isNotEmpty),
          _completionItem('Bio written',          (d.profile.bio ?? '').isNotEmpty),
          _completionItem('CV uploaded',          (d.profile.cvUrl ?? '').isNotEmpty),
          _completionItem('Skills added',         d.skillCount > 0),
          _completionItem('Experience added',     d.experienceCount > 0),
          _completionItem('University verified',  d.profile.universityIdVerified),
        ],
      ),
    );
  }

  Widget _completionItem(String label, bool done) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(
            done ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
            size: 16,
            color: done ? _green : _grey,
          ),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(fontSize: 13, color: done ? _dark : _grey)),
        ],
      ),
    );
  }

  Widget _weeklyGoalCard(_GrowthData d) {
    final applied = d.appliedThisWeek.clamp(0, _weekly);
    final pct     = applied / _weekly;
    return _card(
      title: 'Weekly Application Goal',
      icon: Icons.flag_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$applied / $_weekly this week', style: TextStyle(fontSize: 13, color: _grey)),
              Text(
                applied >= _weekly ? 'Goal reached! 🎉' : '${_weekly - applied} to go',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: applied >= _weekly ? _green : _primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 8,
              backgroundColor: const Color(0xFFEEF0F8),
              valueColor: AlwaysStoppedAnimation(applied >= _weekly ? _green : _primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _recentAppliedCard(_GrowthData d) {
    return _card(
      title: 'Recent Applications',
      icon: Icons.work_history_outlined,
      child: d.recentApplied.isEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text('No applications yet', style: TextStyle(color: _grey, fontSize: 13)),
            )
          : Column(
              children: d.recentApplied.map((job) {
                final company = job.companyName ?? 'Unknown';
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF0F8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.business_rounded, size: 18, color: _primary),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(job.title ?? '', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _dark)),
                            Text(company, style: const TextStyle(fontSize: 11, color: _grey)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _green.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text('Applied', style: TextStyle(fontSize: 10, color: _green, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }

  Widget _tipsCard(_GrowthData d) {
    final tips = _tips(d);
    if (tips.isEmpty) {
      return _card(
        title: 'Tips',
        icon: Icons.lightbulb_outline_rounded,
        child: Row(
          children: [
            const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
            const SizedBox(width: 8),
            Text('Your profile looks great! Keep applying.', style: TextStyle(fontSize: 13, color: _dark)),
          ],
        ),
      );
    }
    return _card(
      title: 'Tips to Improve',
      icon: Icons.lightbulb_outline_rounded,
      child: Column(
        children: tips.map((tip) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.arrow_right_rounded, color: _primary, size: 20),
              const SizedBox(width: 4),
              Expanded(child: Text(tip, style: TextStyle(fontSize: 13, color: _dark))),
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget _card({required String title, required IconData icon, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: _primary),
              const SizedBox(width: 8),
              Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: _dark)),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _GrowthData {
  final ProfileStats   stats;
  final int            streak;
  final ProfileModel   profile;
  final int            skillCount;
  final int            experienceCount;
  final List<JobModel> recentApplied;
  final int            appliedThisWeek;

  _GrowthData({
    required this.stats,
    required this.streak,
    required this.profile,
    required this.skillCount,
    required this.experienceCount,
    required this.recentApplied,
    required this.appliedThisWeek,
  });
}
