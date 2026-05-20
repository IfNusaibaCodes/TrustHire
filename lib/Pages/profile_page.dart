import 'package:flutter/material.dart';
import 'package:trust_hire_app/Authentication/Services/auth_service.dart';
import 'package:trust_hire_app/Pages/landing_page.dart';
import 'package:trust_hire_app/Utilities/Constants/size.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {


  final authService = AuthService();

  void logout() async {


    try{
      await authService.signOut();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(
          content: Text("Logging out"),
          backgroundColor: Colors.green,
        ));
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LandingPage()));
      }
    } catch(e){
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final currentEmail = authService.getCurrentEmail();
    final currentFName = authService.getCurrentFName();
    final currentLName = authService.getCurrentLName();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Demo"),
      ),
      body: Center(
        child: Column(
          children: [
            Text(currentLName.toString()),
            SizedBox(
              height: Tsize.spaceBtwItems,
            ),
            ElevatedButton(onPressed: (){
              logout();
            }, child: Text("Log Out")
            )

          ],
        ),
      )





    );
  }
}
