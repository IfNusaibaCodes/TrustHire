import 'package:flutter/material.dart';
import 'package:trust_hire_app/Model/job_model.dart';
import 'package:trust_hire_app/Utilities/Customs/Reuseable_Widgets/company_logo.dart';
import 'package:trust_hire_app/Utilities/Customs/Reuseable_Widgets/job_info_chip.dart';


class CompactJobCard extends StatelessWidget {
  final JobModel job;
  final VoidCallback? onTap;

  const CompactJobCard({super.key, required this.job, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CompanyLogo(
              logoUrl: job.companyLogo,
              companyName: job.companyName,
              size: 52,
              borderRadius: 14,
              showBorder: false,
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    job.companyName ?? "Unknown Company",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF6B7280),
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    job.title ?? "Untitled Position",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1F36),
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (job.cityName != null)
                        JobInfoChip(
                          icon: Icons.location_on_outlined,
                          label: job.cityName!,
                        ),

                      if (job.typePrimary != null)
                        JobInfoChip(
                          icon: Icons.work_outline_rounded,
                          label: job.typePrimary!,
                        ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            // ARROW
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Color(0xFF9CA3AF),
            ),
          ],
        ),
      ),
    );
  }
}
