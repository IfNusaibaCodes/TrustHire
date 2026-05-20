import 'package:flutter/material.dart';
import 'package:trust_hire_app/Pages/Job%20Feed/all_jobs.dart';
import 'package:trust_hire_app/Utilities/Constants/colors.dart';
import 'package:trust_hire_app/Utilities/Constants/text_strings.dart';

import '../../Utilities/Constants/size.dart';
import '../../Utilities/Customs/custom_themes/custom_text.dart';

class JobFeedPage extends StatelessWidget {
  const JobFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2, child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.arrow_back_ios_new),color: Colors.black, iconSize: Tsize.Iconmd,),
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

    ));
  }
}

