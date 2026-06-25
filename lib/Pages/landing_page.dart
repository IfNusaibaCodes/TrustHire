import 'package:flutter/material.dart';
import 'package:trust_hire_app/Pages/Login/login_page.dart';
import 'package:trust_hire_app/Pages/SignUp/signup_page.dart';
import 'package:trust_hire_app/Utilities/Constants/colors.dart';
import 'package:trust_hire_app/Utilities/Customs/Reuseable_Widgets/app_logo.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.appBackground ,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const Spacer(flex: 2),
              AppLogo(),
              const SizedBox(height: 28),

              const Text(
                'Trust Hire',
                style: TextStyle(
                  color: TColors.appNavy,
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Find trusted jobs and build\nyour career with confidence.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: TColors.appNavy,
                  fontSize: 16,
                  height: 1.6,
                ),
              ),

              const Spacer(flex: 3),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignUpPage()),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.appNavy,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Create Account',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: OutlinedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: TColors.appNavy,
                    backgroundColor: Colors.transparent,
                    side: const BorderSide(color:TColors.appNavy, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Log In',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: TColors.appNavy,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }
}
