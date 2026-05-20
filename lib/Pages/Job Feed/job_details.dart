import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:trust_hire_app/Model/job_model.dart';

class JobDetails extends StatefulWidget {
  final JobModel jobModel;
  const JobDetails({Key? key, required this.jobModel}) : super(key: key);

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  bool _isSaved = false;

  @override
  Widget build(BuildContext context) {
    final job = widget.jobModel;

    final location = job.cities != null && job.cities!.isNotEmpty
        ? job.hasRemote == true
        ? '${job.cities!.first.name} (Remote)'
        : job.cities!.first.name ?? ''
        : job.location ?? '';

    final days = job.published != null
        ? DateTime.now().difference(job.published!).inDays
        : null;
    final postedLabel = days == null ? '' : days == 0 ? 'Today' : days == 1 ? 'Yesterday' : '$days days ago';

    return Scaffold(
      appBar: AppBar(
        title: Text(job.title ?? 'Job Details'),
        actions: [
          IconButton(
            icon: Icon(_isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded),
            onPressed: () => setState(() => _isSaved = !_isSaved),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: 8),

              // Company logo
              CachedNetworkImage(
                height: 200,
                width: double.infinity,
                fit: BoxFit.contain,
                imageUrl: job.company?.logo ?? '',
                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(Icons.business, size: 80, color: Colors.black45),
              ),

              SizedBox(height: 8),

              // Company name badge + posted date
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(color: Color(0xFFB6F2C8), borderRadius: BorderRadius.circular(50)),
                    child: Text(
                      job.company?.name ?? '',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1A7A3C)),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(postedLabel, style: TextStyle(color: Colors.black45, fontSize: 12)),
                ],
              ),

              SizedBox(height: 8),

              // Job title
              Text(
                job.title ?? '',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),

              SizedBox(height: 8),

              // Location + type chips
              Row(
                children: [
                  if (location.isNotEmpty)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Color(0xFFD0D0D0)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.location_on_outlined, size: 12, color: Colors.black54),
                          SizedBox(width: 4),
                          Text(location, style: TextStyle(fontSize: 12, color: Colors.black54)),
                        ],
                      ),
                    ),
                  SizedBox(width: 8),
                  if (job.types != null && job.types!.isNotEmpty)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Color(0xFFD0D0D0)),
                      ),
                      child: Text(job.types!.first.name ?? '', style: TextStyle(fontSize: 12, color: Colors.black54)),
                    ),
                ],
              ),

              SizedBox(height: 8),

              // Salary
              Text(
                job.salaryMin != null && job.salaryMax != null
                    ? '${job.salaryCurrency ?? ''} ${job.salaryMin!.toStringAsFixed(0)} – ${job.salaryMax!.toStringAsFixed(0)}'
                    : 'Salary not disclosed',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: job.salaryMin != null ? Color(0xFF2E7D32) : Colors.black38,
                ),
              ),

              SizedBox(height: 8),

              // Description
              Text(
                job.descriptionMd != null
                    ? job.descriptionMd!.replaceAll(RegExp(r'#{1,6} |[*_`]|\[.*?\]\(.*?\)'), '').trim()
                    : 'No description available.',
                style: TextStyle(fontSize: 13, color: Colors.black54, height: 1.7),
              ),

              SizedBox(height: 16),

              // Apply button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () async {
                    final Uri uri = Uri.parse(job.applicationUrl ?? '');
                    if (!await launchUrl(uri)) {
                      throw Exception('Could not launch');
                    }
                  },
                  child: Text('Apply Now', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                ),
              ),

              SizedBox(height: 16),

            ],
          ),
        ),
      ),
    );
  }
}