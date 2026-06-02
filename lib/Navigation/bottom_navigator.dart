import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:trust_hire_app/Pages/Guide/work_guide_page.dart';
import 'package:trust_hire_app/Pages/Job%20Feed/job_feed_page.dart';
import 'package:trust_hire_app/Pages/scam_detection_page.dart';
import 'package:trust_hire_app/profile/profile_page.dart';
import 'package:trust_hire_app/Pages/Planner/planner_page.dart';
import 'package:trust_hire_app/Pages/Planner/planner_controller.dart';

import '../Utilities/Constants/colors.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {

  int selectedIndex = 0;

  final pageData = [
    JobFeedPage(),
    ScamDetectorPage(),
    PlannerPage(),
    RemoteWorkGuidePage(),
  ];

  @override
  void initState() {
    super.initState();
    Get.put(PlannerController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: selectedIndex,
        children: pageData,
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: TColors.primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.work_outline),   label: 'Jobs'),
          BottomNavigationBarItem(icon: Icon(Icons.scanner), label: 'Detect Scam'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: 'Planner'),
          BottomNavigationBarItem(icon: Icon(Icons.library_add_check_outlined), label: 'Guide'),
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