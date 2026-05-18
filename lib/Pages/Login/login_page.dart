import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:trust_hire_app/Authentication/Services/auth_service.dart';
import 'package:trust_hire_app/Utilities/Constants/colors.dart';
import 'package:trust_hire_app/Utilities/Constants/text_strings.dart';
import 'package:trust_hire_app/common/styles/spacing_styles.dart';

import '../../Utilities/Constants/image_strings.dart';
import '../../Utilities/Constants/size.dart';
import '../../common/widgets_login_signup/form_divider.dart';
import '../../common/widgets_login_signup/social_buttons.dart';
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

  void login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try{
      await authService.signInWithEmailAndPassword(email, password);
    } catch(e){
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: TSpacingStyle.paddingWithAppBarHeight,
        child: Column(
          children: [

            //Logo, Title, SubTitle
            const TLoginHeader(),

            //Form
            const TForm(),

            //Divider
            TDivider(dividerText: Ttexts.orSignInWith.capitalize! ),

            const SizedBox( height: Tsize.spaceBtwSections,),

            //Footer
            const TSocialButton()

          ],

        ),),
      ),
    );
  }
}


class TForm extends StatelessWidget {
  const TForm({
    super.key,
  });

  TextEditingController? get _emailController => null;
  TextEditingController? get _passwordController => null;



  @override
  Widget build(BuildContext context) {
    return Form(
      child:
      Padding(
        padding: const EdgeInsets.symmetric(vertical: Tsize.spaceBtwSections),
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
                decoration: InputDecoration(
                    prefixIcon : Icon(Icons.email_outlined),
                    labelText: Ttexts.email,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))


                )),
            const SizedBox( height: Tsize.spaceBtwinputfield,),

            TextFormField(
              controller: _passwordController,
                decoration: InputDecoration(
                    prefixIcon : Icon(Iconsax.password_check), labelText: Ttexts.password,  suffixIcon: Icon(Iconsax.eye_slash),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))
                )
            ),
            const SizedBox( height: Tsize.spaceBtwinputfield/2 ,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(value: true, onChanged: (value){}),
                    const Text(Ttexts.rememberMe, style: TextStyle(
                        fontSize: Tsize.Fontxs
                    ),),
                  ],
                ),
                TextButton(onPressed: (){},
                    child: const Text(Ttexts.forgetPassword, style: TextStyle(
                        fontSize: Tsize.Fontxs,
                        fontWeight: FontWeight.w600,
                        color: Colors.black

                    ))),
              ],
            ),
            const SizedBox(height:  Tsize.spaceBtwSections,),

            SizedBox(width: double.infinity, child: ElevatedButton(
                onPressed: (){

                },
                child: Text(Ttexts.login))),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 45,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage(Timages.appLogo),
              ),
            ),
            const SizedBox( width:  Tsize.spaceBtwItems,),

            Text(Ttexts.login, style: Theme.of(context).textTheme.headlineLarge,),
          ],

        ),
        const SizedBox( height: Tsize.md,),
        Text(Ttexts.loginTitle, style: Theme.of(context).textTheme.bodyLarge,),

      ],
    );
  }
}