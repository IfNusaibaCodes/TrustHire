import 'package:flutter/material.dart';
import 'package:trust_hire_app/Pages/Job%20Feed/job_feed_page.dart';
import 'package:trust_hire_app/Pages/Job%20Feed/recent_job_feed.dart';
import 'package:iconsax/iconsax.dart';
import '../Pages/profile_page.dart';
class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {


  int selectedIndex = 0;
  var pageData = [
    JobFeedPage(),
    ProfilePage(),


  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: pageData[selectedIndex],
      ),

      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        items:[
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_sharp), label: 'Jobs'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: 'Planner'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),

        ],
        currentIndex: selectedIndex,
        onTap: (setValue){
          setState(() {
            selectedIndex= setValue;
          });
        },
      ),

    );
  }

}
