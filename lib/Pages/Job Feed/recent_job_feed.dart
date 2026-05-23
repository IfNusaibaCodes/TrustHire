import 'package:flutter/material.dart';
import 'package:trust_hire_app/Pages/Job%20Feed/all_jobs.dart';
import 'package:http/http.dart' as http;
import 'package:trust_hire_app/Utilities/Constants/colors.dart';
import 'package:trust_hire_app/Utilities/Constants/text_strings.dart';

import '../../Utilities/Constants/size.dart';

class RecentJobFeedPage extends StatelessWidget {
  const RecentJobFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2, child: Scaffold(
      appBar: AppBar(
        leading: BackButton(
            onPressed: (){
              Navigator.pop(context);
            }
        ),
        title: Center(child:
        Text("Recent Jobs",
          style: Theme.of(context).textTheme.titleMedium
        ),
        ),
      ),
      body: TabBarView(children:
      [
        AllJobs(),
      ])

    )
    );
  }
}

