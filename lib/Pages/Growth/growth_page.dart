import 'dart:math';
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
  static const _bg      = Color(0xFFF0F4FF);
  static const _primary = Color(0xFF3B5BDB);
  static const _dark    = Color(0xFF1A1A2E);
  static const _grey    = Color(0xFF9CA3AF);
  static const _green   = Color(0xFF10B981);
  static const _orange  = Color(0xFFF59E0B);
  static const _weeklyGoal = 5;

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
      GrowthDatabase.loadWeeklyActivity(),
    ]);
    return _GrowthData(
      stats:           results[0] as ProfileStats,
      streak:          results[1] as int,
      profile:         results[2] as ProfileModel,
      skillCount:      results[3] as int,
      experienceCount: results[4] as int,
      recentApplied:   results[5] as List<JobModel>,
      appliedThisWeek: results[6] as int,
      weeklyActivity:  results[7] as List<int>,
    );
  }

  int _completion(_GrowthData d) {
    int s = 0;
    if ((d.profile.firstName ?? '').isNotEmpty) s++;
    if ((d.profile.bio ?? '').isNotEmpty)       s++;
    if ((d.profile.cvUrl ?? '').isNotEmpty)     s++;
    if (d.skillCount > 0)                       s++;
    if (d.experienceCount > 0)                  s++;
    if (d.profile.universityIdVerified)         s++;
    return ((s / 6) * 100).round();
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
          final d   = snap.data!;
          final pct = _completion(d);
          return RefreshIndicator(
            onRefresh: () async => setState(() { _future = _load(); }),
            child: CustomScrollView(
              slivers: [
                _header(d),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: 20),
                      _kpiRow(d),
                      const SizedBox(height: 20),
                      _weeklyChart(d),
                      const SizedBox(height: 16),
                      _profileStrength(d, pct),
                      const SizedBox(height: 16),
                      _achievements(d, pct),
                      const SizedBox(height: 16),
                      _recentApplied(d),
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

  // ─────────────────────────────────────────────────────────── Header
  Widget _header(_GrowthData d) {
    final name = (d.profile.firstName ?? '').isNotEmpty
        ? d.profile.firstName!
        : 'there';
    final initials = d.profile.initials;
    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'Good morning' : hour < 17 ? 'Good afternoon' : 'Good evening';

    return SliverToBoxAdapter(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A1F36), Color(0xFF2D3A8C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 56, 20, 28),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: _primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white24, width: 2),
              ),
              alignment: Alignment.center,
              child: Text(
                initials,
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$greeting, $name!',
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Track your job search journey',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 13),
                  ),
                ],
              ),
            ),
            // Streak badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _green.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _green.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_fire_department_rounded, color: _green, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${d.streak}d',
                    style: const TextStyle(color: _green, fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────── KPI Row
  Widget _kpiRow(_GrowthData d) {
    return Row(
      children: [
        Expanded(child: _kpiCard('Applied', d.stats.appliedCount.toString(), Icons.send_rounded, _primary, const Color(0xFFEEF2FF))),
        const SizedBox(width: 12),
        Expanded(child: _kpiCard('Saved', d.stats.savedCount.toString(), Icons.bookmark_rounded, _orange, const Color(0xFFFFF8EB))),
        const SizedBox(width: 12),
        Expanded(child: _kpiCard('This Week', '${d.appliedThisWeek}/$_weeklyGoal', Icons.calendar_today_rounded, _green, const Color(0xFFECFDF5))),
      ],
    );
  }

  Widget _kpiCard(String label, String value, IconData icon, Color color, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 10),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: _dark)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 11, color: _grey)),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────── Weekly Chart
  Widget _weeklyChart(_GrowthData d) {
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final todayIndex = DateTime.now().weekday - 1;
    final maxVal = d.weeklyActivity.fold(0, max);

    return _card(
      title: 'Weekly Activity',
      subtitle: 'Applications this week',
      icon: Icons.bar_chart_rounded,
      child: SizedBox(
        height: 100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(7, (i) {
            final count  = d.weeklyActivity[i];
            final isToday = i == todayIndex;
            final barH   = maxVal == 0 ? 4.0 : max(4.0, (count / maxVal) * 72);
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (count > 0)
                  Text('$count', style: TextStyle(fontSize: 9, color: isToday ? _primary : _grey, fontWeight: FontWeight.w600)),
                const SizedBox(height: 3),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  width: 28,
                  height: barH,
                  decoration: BoxDecoration(
                    color: isToday ? _primary : (count > 0 ? _primary.withValues(alpha: 0.3) : const Color(0xFFE8ECF8)),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  days[i],
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                    color: isToday ? _primary : _grey,
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────── Profile Strength
  Widget _profileStrength(_GrowthData d, int pct) {
    final checks = [
      ('Name added',          (d.profile.firstName ?? '').isNotEmpty),
      ('Bio written',         (d.profile.bio ?? '').isNotEmpty),
      ('CV uploaded',         (d.profile.cvUrl ?? '').isNotEmpty),
      ('Skills added',        d.skillCount > 0),
      ('Experience added',    d.experienceCount > 0),
      ('University verified', d.profile.universityIdVerified),
    ];

    return _card(
      title: 'Profile Strength',
      subtitle: '$pct% complete',
      icon: Icons.person_outline_rounded,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Circular gauge
          SizedBox(
            width: 90,
            height: 90,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 90,
                  height: 90,
                  child: CircularProgressIndicator(
                    value: pct / 100,
                    strokeWidth: 9,
                    backgroundColor: const Color(0xFFEEF0F8),
                    valueColor: AlwaysStoppedAnimation(pct == 100 ? _green : _primary),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('$pct%', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: pct == 100 ? _green : _dark)),
                    Text('score', style: const TextStyle(fontSize: 10, color: _grey)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              children: checks.map((c) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.5),
                child: Row(
                  children: [
                    Icon(
                      c.$2 ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
                      size: 15,
                      color: c.$2 ? _green : _grey,
                    ),
                    const SizedBox(width: 7),
                    Text(c.$1, style: TextStyle(fontSize: 12, color: c.$2 ? _dark : _grey)),
                  ],
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────── Achievements
  Widget _achievements(_GrowthData d, int pct) {
    final badges = [
      _Badge('First Apply',      Icons.rocket_launch_rounded,  d.stats.appliedCount >= 1,  _primary),
      _Badge('5 Jobs Saved',     Icons.bookmark_rounded,       d.stats.savedCount >= 5,    _orange),
      _Badge('10 Applications',  Icons.send_rounded,           d.stats.appliedCount >= 10, const Color(0xFF8B5CF6)),
      _Badge('7-Day Streak',     Icons.local_fire_department_rounded, d.streak >= 7,       _green),
      _Badge('Profile Complete', Icons.verified_rounded,        pct == 100,                 const Color(0xFFEC4899)),
    ];

    return _card(
      title: 'Achievements',
      subtitle: '${badges.where((b) => b.earned).length} / ${badges.length} earned',
      icon: Icons.emoji_events_outlined,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: badges.map((b) {
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: b.earned ? b.color.withValues(alpha: 0.12) : const Color(0xFFF3F4F6),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: b.earned ? b.color.withValues(alpha: 0.4) : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      b.icon,
                      color: b.earned ? b.color : _grey,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: 60,
                    child: Text(
                      b.label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: b.earned ? FontWeight.w600 : FontWeight.w400,
                        color: b.earned ? _dark : _grey,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────── Recent Applied
  Widget _recentApplied(_GrowthData d) {
    return _card(
      title: 'Recent Applications',
      subtitle: 'Last ${d.recentApplied.length} applied',
      icon: Icons.work_history_outlined,
      child: d.recentApplied.isEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.inbox_outlined, color: _grey, size: 18),
                  const SizedBox(width: 8),
                  Text('No applications yet', style: TextStyle(color: _grey, fontSize: 13)),
                ],
              ),
            )
          : Column(
              children: d.recentApplied.map((job) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.business_rounded, size: 20, color: _primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.title ?? 'Untitled',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _dark),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            job.companyName ?? 'Unknown',
                            style: const TextStyle(fontSize: 11, color: _grey),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('Applied', style: TextStyle(fontSize: 10, color: _green, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              )).toList(),
            ),
    );
  }

  // ─────────────────────────────────────────────────────────── Card Shell
  Widget _card({required String title, required String subtitle, required IconData icon, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: _primary),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _dark)),
                    Text(subtitle, style: const TextStyle(fontSize: 11, color: _grey)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────── Data classes
class _GrowthData {
  final ProfileStats   stats;
  final int            streak;
  final ProfileModel   profile;
  final int            skillCount;
  final int            experienceCount;
  final List<JobModel> recentApplied;
  final int            appliedThisWeek;
  final List<int>      weeklyActivity;

  _GrowthData({
    required this.stats,
    required this.streak,
    required this.profile,
    required this.skillCount,
    required this.experienceCount,
    required this.recentApplied,
    required this.appliedThisWeek,
    required this.weeklyActivity,
  });
}

class _Badge {
  final String    label;
  final IconData  icon;
  final bool      earned;
  final Color     color;
  const _Badge(this.label, this.icon, this.earned, this.color);
}
