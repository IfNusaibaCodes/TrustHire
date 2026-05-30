import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:trust_hire_app/Pages/Job%20Feed/job_feed_page.dart';
import 'package:trust_hire_app/profile/profile_page.dart';
import 'package:trust_hire_app/Pages/Planner/planner_page.dart';
import 'package:trust_hire_app/Pages/Planner/planner_controller.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {

  int selectedIndex = 0;

  final pageData = [
    JobFeedPage(),
    PlannerPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    Get.put(PlannerController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: pageData[selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.work_outline),   label: 'Jobs'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Planner'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
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