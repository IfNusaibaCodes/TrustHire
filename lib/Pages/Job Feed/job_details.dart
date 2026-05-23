import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Model/job_model.dart';

class JobDetailsPage extends StatelessWidget {
  final JobModel job;

  const JobDetailsPage({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCards(),
                  const SizedBox(height: 24),
                  if (job.descriptionMd != null && job.descriptionMd!.isNotEmpty) ...[
                    _buildSectionTitle('About the Role'),
                    const SizedBox(height: 12),
                    _buildDescription(),
                    const SizedBox(height: 24),
                  ],
                  _buildCompanySection(),
                  const SizedBox(height: 100), // space for FAB
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: job.applicationUrl != null
          ? _buildApplyButton(context)
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: const Color(0xFF1A1F36),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A1F36), Color(0xFF2D3561)],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildLogoBox(),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.companyName ?? 'Unknown Company',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            job.title ?? 'Untitled Position',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoBox() {
    final initials = job.companyName != null && job.companyName!.isNotEmpty
        ? job.companyName!.trim().split(' ').take(2).map((w) => w[0].toUpperCase()).join()
        : '?';

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: job.companyLogo != null && job.companyLogo!.isNotEmpty
          ? Image.network(
        job.companyLogo!,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Center(
          child: Text(
            initials,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF4F6EF7),
            ),
          ),
        ),
      )
          : Center(
        child: Text(
          initials,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF4F6EF7),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCards() {
    final chips = <_InfoItem>[
      if (job.cityName != null)
        _InfoItem(
          icon: Icons.location_on_rounded,
          label: 'Location',
          value: [job.cityName, job.cityCountryName].where((e) => e != null).join(', '),
          color: const Color(0xFF4F6EF7),
          bg: const Color(0xFFEEF2FF),
        ),
      if (job.experienceLevel != null)
        _InfoItem(
          icon: Icons.bar_chart_rounded,
          label: 'Experience',
          value: job.experienceLevel!,
          color: const Color(0xFFF97316),
          bg: const Color(0xFFFFF7ED),
        ),
      if (job.typePrimary != null)
        _InfoItem(
          icon: Icons.access_time_rounded,
          label: 'Job Type',
          value: job.typePrimary!,
          color: const Color(0xFF10B981),
          bg: const Color(0xFFECFDF5),
        ),
      if (job.salaryCurrency != null)
        _InfoItem(
          icon: Icons.payments_rounded,
          label: 'Currency',
          value: job.salaryCurrency!,
          color: const Color(0xFF8B5CF6),
          bg: const Color(0xFFF5F3FF),
        ),
      if (job.hasRemote == true)
        _InfoItem(
          icon: Icons.wifi_rounded,
          label: 'Work Style',
          value: 'Remote OK',
          color: const Color(0xFF4F6EF7),
          bg: const Color(0xFFEEF2FF),
        ),
      if (job.language != null)
        _InfoItem(
          icon: Icons.language_rounded,
          label: 'Language',
          value: job.language!.toUpperCase(),
          color: const Color(0xFFEC4899),
          bg: const Color(0xFFFDF2F8),
        ),
      if (job.published != null)
        _InfoItem(
          icon: Icons.calendar_today_rounded,
          label: 'Posted',
          value: _formatDate(job.published!),
          color: const Color(0xFF6B7280),
          bg: const Color(0xFFF9FAFB),
        ),
    ];

    if (chips.isEmpty) return const SizedBox.shrink();

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2.6,
      children: chips.map((item) => _InfoCard(item: item)).toList(),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: const Color(0xFF4F6EF7),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1F36),
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    // Strip markdown symbols for a clean readable view
    final cleaned = job.descriptionMd!
        .replaceAll(RegExp(r'#{1,6}\s*'), '')
        .replaceAll(RegExp(r'\*\*(.*?)\*\*'), r'\1')
        .replaceAll(RegExp(r'\*(.*?)\*'), r'\1')
        .replaceAll(RegExp(r'`(.*?)`'), r'\1')
        .replaceAll(RegExp(r'\[([^\]]+)\]\([^)]+\)'), r'\1')
        .trim();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        cleaned,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF374151),
          height: 1.7,
        ),
      ),
    );
  }

  Widget _buildCompanySection() {
    final hasLinks = [
      job.companyWebsiteUrl,
      job.companyLinkedinUrl,
      job.companyGithubUrl,
      job.companyTwitterHandle,
    ].any((e) => e != null && e.isNotEmpty);

    if (!hasLinks && job.companyIsAgency == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('About the Company'),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (job.companyIsAgency == true)
                Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7ED),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFED7AA)),
                  ),
                  child: const Text(
                    '🏢 Staffing / Agency',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFF97316),
                    ),
                  ),
                ),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  if (job.companyWebsiteUrl != null)
                    _LinkButton(
                      label: 'Website',
                      icon: Icons.language_rounded,
                      url: job.companyWebsiteUrl!,
                      color: const Color(0xFF4F6EF7),
                    ),
                  if (job.companyLinkedinUrl != null)
                    _LinkButton(
                      label: 'LinkedIn',
                      icon: Icons.work_rounded,
                      url: job.companyLinkedinUrl!,
                      color: const Color(0xFF0077B5),
                    ),
                  if (job.companyGithubUrl != null)
                    _LinkButton(
                      label: 'GitHub',
                      icon: Icons.code_rounded,
                      url: job.companyGithubUrl!,
                      color: const Color(0xFF1A1F36),
                    ),
                  if (job.companyTwitterHandle != null)
                    _LinkButton(
                      label: '@${job.companyTwitterHandle}',
                      icon: Icons.tag_rounded,
                      url: 'https://twitter.com/${job.companyTwitterHandle}',
                      color: const Color(0xFF1DA1F2),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildApplyButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: () async {
            final uri = Uri.tryParse(job.applicationUrl!);
            if (uri != null && await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Could not open application link')),
                );
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4F6EF7),
            foregroundColor: Colors.white,
            elevation: 4,
            shadowColor: const Color(0xFF4F6EF7).withOpacity(0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Apply Now',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.open_in_new_rounded, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class _InfoItem {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Color bg;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.bg,
  });
}

class _InfoCard extends StatelessWidget {
  final _InfoItem item;

  const _InfoCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: item.bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: item.color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(item.icon, size: 18, color: item.color),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: item.color.withOpacity(0.7),
                  ),
                ),
                Text(
                  item.value,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: item.color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LinkButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final String url;
  final Color color;

  const _LinkButton({
    required this.label,
    required this.icon,
    required this.url,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final uri = Uri.tryParse(url);
        if (uri != null && await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(10),
          color: color.withOpacity(0.06),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}