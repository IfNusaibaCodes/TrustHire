import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:trust_hire_app/Model/job_model.dart';

import '../../Pages/Job Feed/job_details.dart';

class JobItemList extends StatefulWidget {
  final JobModel jobModel;
  const JobItemList({Key? key, required this.jobModel}) : super(key: key);

  @override
  State<JobItemList> createState() => _JobItemListState();
}

class _JobItemListState extends State<JobItemList> {
  bool _isSaved = false;

  @override
  Widget build(BuildContext context) {
    final job = widget.jobModel;
    final days = job.published != null
        ? DateTime.now().difference(job.published!).inDays
        : null;
    final postedLabel = days == null
        ? ''
        : days == 0
        ? 'Today'
        : days == 1
        ? 'Yesterday'
        : '$days days ago';

    final location = job.cities != null && job.cities!.isNotEmpty
        ? job.hasRemote == true
        ? '${job.cities!.first.name} (Remote)'
        : job.cities!.first.name ?? ''
        : job.location ?? '';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Row 1: Logo + Title + Company + Bookmark
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Logo
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xFFE0E0E0)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: CachedNetworkImage(
                    fit: BoxFit.contain,
                    imageUrl: job.company?.logo ?? '',
                    placeholder: (context, url) => Padding(
                      padding: EdgeInsets.all(10),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    errorWidget: (context, url, error) =>
                        Icon(Icons.business_rounded, size: 26, color: Colors.black45),
                  ),
                ),

                SizedBox(width: 12),

                // Title + Company
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        job.company?.name ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                ),

                // Bookmark
                GestureDetector(
                  onTap: () => setState(() => _isSaved = !_isSaved),
                  child: Icon(
                    _isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                    color: _isSaved ? Colors.black87 : Colors.black38,
                    size: 24,
                  ),
                ),

              ],
            ),

            SizedBox(height: 14),

            // Row 2: Safe badge + Job type chip + Location chip
            Row(
              children: [
                // "Safe" badge (green filled)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Color(0xFFB6F2C8),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Verified',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF1A7A3C)),
                  ),
                ),
                SizedBox(width: 8),
                // Job type chip (outlined)
                if (job.types != null && job.types!.isNotEmpty)
                  _outlineChip(job.types!.first.name ?? ''),
                SizedBox(width: 8),
                // Location chip (outlined)
                if (location.isNotEmpty)
                  _outlineChip(location),
              ],
            ),

            SizedBox(height: 14),

            // Description snippet
            Text(
              job.descriptionMd != null
                  ? job.descriptionMd!.replaceAll(RegExp(r'#+ |[*_`]|\n'), ' ').trim()
                  : '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13, color: Colors.black54, height: 1.5),
            ),

            SizedBox(height: 14),
            Divider(height: 1, color: Color(0xFFE0E0E0)),
            SizedBox(height: 12),

            // Row 3: Salary + posted | View More button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                // Salary + posted
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.salaryMin != null && job.salaryMax != null
                          ? '${job.salaryCurrency ?? ''} ${job.salaryMin!.toStringAsFixed(0)}–${job.salaryMax!.toStringAsFixed(0)}'
                          : 'Salary not disclosed',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    if (postedLabel.isNotEmpty)
                      Text(postedLabel, style: TextStyle(fontSize: 12, color: Colors.black45)),
                  ],
                ),

                // View More button
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => JobDetails(jobModel: job)));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'View More',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

              ],
            ),

          ],
        ),
      ),
    );
  }

  Widget _outlineChip(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Color(0xFFD0D0D0)),
      ),
      child: Text(label, style: TextStyle(fontSize: 12, color: Colors.black87)),
    );
  }
}