import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trust_hire_app/Utilities/Constants/colors.dart';
import 'package:trust_hire_app/Utilities/Constants/text_strings.dart';
import 'package:trust_hire_app/Utilities/Validation/validation.dart';
import 'package:trust_hire_app/common/styles/spacing_styles.dart';

import '../../Authentication/Services/auth_service.dart';
import '../../Utilities/Constants/image_strings.dart';
import '../../Utilities/Constants/size.dart';
import '../../common/widgets_login_signup/form_divider.dart';
import '../../common/widgets_login_signup/social_buttons.dart';

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
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _fNameController.dispose();
    _lNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void signup() async {
    final fName = _fNameController.text;
    final lName = _lNameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if(!_formKey.currentState!.validate()) return;

    if(password != confirmPassword){
      ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text("Password don't match!"),
      backgroundColor: Colors.red,));
      return;
    }

    try{
      await authService.signUpWithEmailAndPassword(fName, lName, email, password);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(
          content: Text("Registration Complete"),
          backgroundColor: Colors.green,
        ));
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
    final width = size.width;

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
                passwordController: _passwordController,
                confirmPasswordController: _confirmPasswordController,
                onSignup: signup,
              ),

              //Divider
              TDivider(dividerText: Ttexts.orSignUpWith.capitalize! ),

              const SizedBox( height: Tsize.spaceBtwSections,),

              //Footer
              const TSocialButton()

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
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback onSignup;

  const TForm({
    super.key,
    required this.formKey,
    required this.fNameController,
    required this.lNameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
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
              obscureText: true,
                controller: passwordController,
                validator: (value) => TValidator.validatePassword(value),
                decoration: InputDecoration(
                    prefixIcon : Icon(Icons.lock_outline_rounded), labelText: Ttexts.password,  suffixIcon: Icon(Iconsax.eye_slash),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))
                )
            ),
            const SizedBox( height: Tsize.spaceBtwinputfield,),
            TextFormField(
                obscureText: true,
                controller: confirmPasswordController,
                decoration: InputDecoration(
                    prefixIcon : Icon(Iconsax.password_check), labelText: "Confirm password",  suffixIcon: Icon(Iconsax.eye_slash),
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
    final height = size.height;
    final width = size.width;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage(Timages.appLogo),
                ),
              ),
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



