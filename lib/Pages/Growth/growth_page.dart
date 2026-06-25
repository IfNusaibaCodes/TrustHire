import 'dart:math';
import 'package:flutter/material.dart';
import 'package:trust_hire_app/Model/profile_models.dart';
import 'package:trust_hire_app/Model/job_model.dart';
import 'package:trust_hire_app/Utilities/Customs/Reuseable_Widgets/reusable_widgets.dart';
import 'package:trust_hire_app/Utilities/Customs/Reuseable_Widgets/trust_hire_app_bar.dart';
import 'package:trust_hire_app/Utilities/Constants/colors.dart';
import 'growth_database.dart';


class GrowthPage extends StatefulWidget {
  const GrowthPage({super.key});

  @override
  State<GrowthPage> createState() => GrowthPageState();
}

class GrowthPageState extends State<GrowthPage> {
  static const _weeklyGoal = 5;

  late Future<_GrowthData> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  void reload() {
    if (!mounted) return;
    setState(() { _future = _load(); });
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
    return ((s / 5) * 100).round();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.appBackgroundBlue,
      appBar: const TrustHireAppBar(title: 'Your Growth'),
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
            onRefresh: () async {
              final data = _load();
              setState(() { _future = data; });
              await data;
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
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

  Widget _header(_GrowthData d) {
    final name = (d.profile.firstName ?? '').isNotEmpty
        ? d.profile.firstName!
        : 'there';
    final initials = d.profile.initials;
    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'Good morning' : hour < 17 ? 'Good afternoon' : 'Good evening';

    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1A1F36), Color(0xFF2D3A8C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1A1F36).withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: TColors.appBlue,
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
                color: TColors.appSuccess.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: TColors.appSuccess.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_fire_department_rounded, color: TColors.appSuccess, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${d.streak}d',
                    style: const TextStyle(color: TColors.appSuccess, fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _kpiRow(_GrowthData d) {
    return Row(
      children: [
        Expanded(child: StatCard(label: 'Applied', value: d.stats.appliedCount.toString(), icon: Icons.send_rounded, color: TColors.appBlue, background: const Color(0xFFEEF2FF))),
        const SizedBox(width: 12),
        Expanded(child: StatCard(label: 'Saved', value: d.stats.savedCount.toString(), icon: Icons.bookmark_rounded, color: TColors.appAmber, background: const Color(0xFFFFF8EB))),
        const SizedBox(width: 12),
        Expanded(child: StatCard(label: 'This Week', value: '${d.appliedThisWeek}/$_weeklyGoal', icon: Icons.calendar_today_rounded, color: TColors.appSuccess, background: const Color(0xFFECFDF5))),
      ],
    );
  }

  Widget _weeklyChart(_GrowthData d) {
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final todayIndex = DateTime.now().weekday - 1;
    final maxVal = d.weeklyActivity.fold(0, max);

    return SectionCard(
      title: 'Weekly Activity',
      subtitle: 'Applications this week',
      icon: Icons.bar_chart_rounded,
      child: SizedBox(
        height: 120,
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
                  Text('$count', style: TextStyle(fontSize: 9, color: isToday ? TColors.appBlue : TColors.appTextGrey, fontWeight: FontWeight.w600)),
                const SizedBox(height: 3),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  width: 28,
                  height: barH,
                  decoration: BoxDecoration(
                    color: isToday ? TColors.appBlue : (count > 0 ? TColors.appBlue.withValues(alpha: 0.3) : const Color(0xFFE8ECF8)),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  days[i],
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                    color: isToday ? TColors.appBlue : TColors.appTextGrey,
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _profileStrength(_GrowthData d, int pct) {
    final checks = [
      ('Name added',       (d.profile.firstName ?? '').isNotEmpty),
      ('Bio written',      (d.profile.bio ?? '').isNotEmpty),
      ('CV uploaded',      (d.profile.cvUrl ?? '').isNotEmpty),
      ('Skills added',     d.skillCount > 0),
      ('Experience added', d.experienceCount > 0),
    ];

    return SectionCard(
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
                    valueColor: AlwaysStoppedAnimation(pct == 100 ? TColors.appSuccess : TColors.appBlue),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('$pct%', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: pct == 100 ? TColors.appSuccess : TColors.appTextDark)),
                    Text('score', style: const TextStyle(fontSize: 10, color: TColors.appTextGrey)),
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
                      color: c.$2 ? TColors.appSuccess : TColors.appTextGrey,
                    ),
                    const SizedBox(width: 7),
                    Text(c.$1, style: TextStyle(fontSize: 12, color: c.$2 ? TColors.appTextDark : TColors.appTextGrey)),
                  ],
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _achievements(_GrowthData d, int pct) {
    final badges = [
      _Badge('First Apply',      Icons.rocket_launch_rounded,  d.stats.appliedCount >= 1,  TColors.appBlue),
      _Badge('5 Jobs Saved',     Icons.bookmark_rounded,       d.stats.savedCount >= 5,    TColors.appAmber),
      _Badge('10 Applications',  Icons.send_rounded,           d.stats.appliedCount >= 10, const Color(0xFF8B5CF6)),
      _Badge('7-Day Streak',     Icons.local_fire_department_rounded, d.streak >= 7,       TColors.appSuccess),
      _Badge('Profile Complete', Icons.verified_rounded,        pct == 100,                 const Color(0xFFEC4899)),
    ];

    return SectionCard(
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
                      color: b.earned ? b.color : TColors.appTextGrey,
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
                        color: b.earned ? TColors.appTextDark : TColors.appTextGrey,
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

  Widget _recentApplied(_GrowthData d) {
    return SectionCard(
      title: 'Recent Applications',
      subtitle: 'Last ${d.recentApplied.length} applied',
      icon: Icons.work_history_outlined,
      child: d.recentApplied.isEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.inbox_outlined, color: TColors.appTextGrey, size: 18),
                  const SizedBox(width: 8),
                  Text('No applications yet', style: TextStyle(color: TColors.appTextGrey, fontSize: 13)),
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
                      child: const Icon(Icons.business_rounded, size: 20, color: TColors.appBlue),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.title ?? 'Untitled',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: TColors.appTextDark),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            job.companyName ?? 'Unknown',
                            style: const TextStyle(fontSize: 11, color: TColors.appTextGrey),
                          ),
                        ],
                      ),
                    ),
                    const StatusPill(
                      text: 'Applied',
                      color: TColors.appSuccess,
                      fontSize: 10,
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    ),
                  ],
                ),
              )).toList(),
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
