import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trust_hire_app/Common/Widgets_Login_Signup/auth_info.dart';
import 'package:trust_hire_app/Navigation/bottom_navigator.dart';
import 'package:trust_hire_app/Pages/Login/login_page.dart';
import 'package:trust_hire_app/Utilities/Constants/text_strings.dart';
import 'package:trust_hire_app/Utilities/Customs/Reuseable_Widgets/app_logo.dart';
import 'package:trust_hire_app/Utilities/Validation/validation.dart';

import '../../Authentication/Services/auth_service.dart';
import '../../Utilities/Constants/size.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final authService = AuthService();
  final _fNameController = TextEditingController();
  final _lNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _fNameController.dispose();
    _lNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


// sign up method
  void signup() async {
    final fName = _fNameController.text.trim();
    final lName = _lNameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();

    if(!_formKey.currentState!.validate()) return;

    try{
      if (Supabase.instance.client.auth.currentSession != null) {
        await authService.signOut();
      }

      final response = await authService.signUpWithEmailAndPassword(
          fName, lName, email, phone, password);
      if (!mounted) return;
      if (response.session == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "Verification email sent. Please confirm your email, then log in."),
          backgroundColor: Colors.green,
        ));
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const LoginPage()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => BottomNavBar()));
      }
    } catch(e){
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}"),
          backgroundColor: Colors.red,));
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final height = size.height;

    return Scaffold(
      appBar: AppBar(
      automaticallyImplyLeading: false,
      leading: BackButton(
        onPressed: (){
          Navigator.pop(context);
        }
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
      body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: height*0.001,
              ),

              //Logo, Title, SubTitle
              const TSignUpHeader(),

              //Form
              TForm(
                formKey: _formKey,
                fNameController: _fNameController,
                lNameController: _lNameController,
                emailController: _emailController,
                phoneController: _phoneController,
                passwordController: _passwordController,
                onSignup: signup,
              ),

              //Divider
              //TDivider(dividerText: Ttexts.orSignUpWith.capitalize! ),

              const SizedBox( height: Tsize.spaceBtwSections,),

              //Footer
             // const TSocialButton()
             TAuthInfo(isLogin: false),

            ],

          ),),
      );
  }
}


class TForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController fNameController;
  final TextEditingController lNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final VoidCallback onSignup;

  const TForm({
    super.key,
    required this.formKey,
    required this.fNameController,
    required this.lNameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.onSignup,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child:
      Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextFormField(
              controller: fNameController,
                validator: (value) => TValidator.validateEmptyText('First Name', value),
                decoration: InputDecoration(
                    prefixIcon : Icon(Icons.person_outline_rounded),
                    labelText: Ttexts.firstName,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))


                )),
            const SizedBox( height: Tsize.spaceBtwinputfield,),
            TextFormField(
                controller: lNameController,
                validator: (value) => TValidator.validateEmptyText('Last Name', value),
                decoration: InputDecoration(
                    prefixIcon : Icon(Icons.person_outline_rounded),
                    labelText: Ttexts.lastName,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))


                )),
            const SizedBox( height: Tsize.spaceBtwinputfield,),
            TextFormField(
                controller: emailController,
                validator: (value) => TValidator.validateEmail(value),
                decoration: InputDecoration(
                    prefixIcon : Icon(Icons.mail_outline_rounded),
                    labelText: Ttexts.email,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))


                )),

            const SizedBox( height: Tsize.spaceBtwinputfield,),
            TextFormField(
                controller: phoneController,
                validator: (value) => TValidator.validatePhoneNumber(value),
                decoration: InputDecoration(
                    prefixIcon : Icon(Icons.call_end_outlined), labelText: Ttexts.phoneNo,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))
                )
            ),
            const SizedBox( height: Tsize.spaceBtwinputfield,),
            TextFormField(
                controller: passwordController,
                validator: (value) => TValidator.validatePassword(value),
                decoration: InputDecoration(
                    prefixIcon : Icon(Icons.lock_outline_rounded), labelText: Ttexts.password,  suffixIcon: Icon(Iconsax.eye_slash),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))
                )
            ),
            const SizedBox( height: Tsize.spaceBtwinputfield),

            SizedBox(width: double.infinity, child: ElevatedButton(
                onPressed: (){
                  onSignup();
                },
                child: Text(Ttexts.signUp))),
          ],
        ),
      ),
    );
  }
}

class TSignUpHeader extends StatelessWidget {
  const TSignUpHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final width = size.width;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppLogo(),
              SizedBox( width: width*0.01),
              Text(Ttexts.AppName, style: Theme.of(context).textTheme.headlineLarge,),
            ],
          ),
          const SizedBox( height: Tsize.sm,),
          Center(child: Text(Ttexts.SignUpTitle, style: Theme.of(context).textTheme.bodyLarge,)),

        ],
      ),
    );
  }
}



