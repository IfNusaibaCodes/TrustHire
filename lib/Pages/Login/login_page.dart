import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trust_hire_app/Authentication/Services/auth_service.dart';
import 'package:trust_hire_app/Common/Widgets_Login_Signup/auth_info.dart';
import 'package:trust_hire_app/Pages/forget_password_page.dart';
import 'package:trust_hire_app/Utilities/Constants/colors.dart';
import 'package:trust_hire_app/Utilities/Constants/text_strings.dart';
import 'package:trust_hire_app/Utilities/Customs/Reuseable_Widgets/app_logo.dart';
import 'package:trust_hire_app/Utilities/Customs/Reuseable_Widgets/app_snackbar.dart';
import 'package:trust_hire_app/common/styles/spacing_styles.dart';

import '../../Navigation/bottom_navigator.dart';
import '../../Utilities/Constants/size.dart';
import '../../Utilities/Validation/validation.dart';
import '../SignUp/signup_page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});


  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  final authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  void login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if(!_formKey.currentState!.validate()) return;


    try{
      setState(() => _isLoading = true);

      await authService.signInWithEmailAndPassword(email, password);
      if (mounted) {
        showAppSnackBar(context, "Login Successful");
        Get.offAll(() => const BottomNavBar());
      }
    } on AuthException catch(e){
      if(mounted){
        final message = e.message.toLowerCase().contains('invalid login credentials')
            ? "Incorrect Password!"
            : e.message;
        showAppSnackBar(context, message, isError: true);
      }
    } catch(e){
      if(mounted){
        showAppSnackBar(context, "Error: $e", isError: true);
      }
    }finally{
      if(mounted){
        setState(() => _isLoading = false);
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
        child: Padding(padding: TSpacingStyle.paddingWithAppBarHeight,
        child: Column(
          children: [

            SizedBox( height: height*0.03,),

            const TLoginHeader(),

            SizedBox( height: height*0.03,),

            TForm(
              formKey: _formKey,
              emailController: _emailController,
              passwordController: _passwordController,
              onLogin: login,
              isLoading: _isLoading,
            ),
            SizedBox( height: height*0.01,),

            const SizedBox( height: Tsize.spaceBtwSections,),

           TAuthInfo(isLogin: true),

          ],

        ),),
      ),
    );
  }
}


class TForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onLogin;
  final bool isLoading;


  const TForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.onLogin,
    required this.isLoading,
  });

  @override
  State<TForm> createState() => _TFormState();
}

class _TFormState extends State<TForm> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child:
      Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextFormField(
              controller: widget.emailController,
                validator: (value) => TValidator.validateEmail(value),
                decoration: InputDecoration(
                    prefixIcon : Icon(Icons.mail_outline_rounded),
                    labelText: Ttexts.email,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))


                )),
            const SizedBox( height: Tsize.spaceBtwinputfield,),

            TextFormField(
              controller: widget.passwordController,
                obscureText: _obscurePassword,
                validator: (value) => TValidator.validatePassword(value),
                decoration: InputDecoration(
                    prefixIcon : Icon(Iconsax.password_check), labelText: Ttexts.password,
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Iconsax.eye_slash : Iconsax.eye),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))
                )
            ),
            const SizedBox( height: Tsize.spaceBtwinputfield/2 ,),
            const SizedBox(height:  Tsize.spaceBtwSections,),

            SizedBox(width: double.infinity, child: ElevatedButton(
                onPressed: widget.isLoading ? null : widget.onLogin,
                child: widget.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : Text(Ttexts.login))),
            const SizedBox(height:  Tsize.spaceBtwItems,),

            SizedBox(width: double.infinity, child: OutlinedButton(onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SignUpPage()));
            }, child: Text(Ttexts.signUp))),
          ],
        ),
      ),
    );
  }
}


class TLoginHeader extends StatelessWidget {
  const TLoginHeader({
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
          Center(child: Text(Ttexts.loginTitle, style: Theme.of(context).textTheme.bodyLarge,)),

        ],
      ),
    );
  }
}