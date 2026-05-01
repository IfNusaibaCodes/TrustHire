import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("TrustHire",style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20
        ),),
        leading: Icon(Icons.menu),
        actions: [
          TextButton(onPressed: (){}, child: Text("Skip >",style: TextStyle(color: Colors.black,fontSize: 16),))
        ],
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 500,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 30,vertical: 15),
                textStyle: TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(10)
                ),
              ),
              onPressed: (){},
              child: Text("Login/Sign Up"),
            )
          ],


        ),
      ),

    );
  }
}
