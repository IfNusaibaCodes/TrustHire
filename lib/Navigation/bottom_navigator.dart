import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trust_hire_app/Pages/Job%20Feed/job_feed_page.dart';
import 'package:trust_hire_app/Pages/scam_detection/scam_detection_page.dart';
import 'package:trust_hire_app/Pages/Planner/planner_page.dart';
import 'package:trust_hire_app/Pages/Growth/growth_page.dart';
import 'package:trust_hire_app/Pages/Notifications/notification_controller.dart';

import '../Utilities/Constants/colors.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    Get.put(NotificationController());
  }

  final pageData = [
    JobFeedPage(),
    ScamDetectorPage(),
    PlannerPage(),
    GrowthPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.appBackground,
      extendBody: true,
      body: IndexedStack(
        index: selectedIndex,
        children: pageData,
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: TColors.appNavy,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.work_outline),   label: 'Jobs'),
          BottomNavigationBarItem(icon: Icon(Icons.scanner), label: 'Detect Scam'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: 'Planner'),
          BottomNavigationBarItem(icon: Icon(Icons.trending_up_rounded), label: 'Growth'),
        ],
        currentIndex: selectedIndex,
        onTap: (setValue) {
          setState(() {
            selectedIndex = setValue;
          });
        },
      ),
    );
  }
}