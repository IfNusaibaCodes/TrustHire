import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../Pages/Login/login_page.dart';
import 'package:trust_hire_app/profile/profile_page.dart';


class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Supabase.instance.client.auth.onAuthStateChange,

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(child: CircularProgressIndicator(),),
            );
          }
          final session = snapshot.hasData ? snapshot.data!.session : null;

          if (session != null) {
            return ProfilePage();
          } else {
            return LoginPage();
          }
        });
  }
}