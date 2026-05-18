import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:trust_hire_app/Utilities/Constants/colors.dart';
import 'package:trust_hire_app/Utilities/Constants/text_strings.dart';
import 'package:trust_hire_app/common/styles/spacing_styles.dart';

import '../../Utilities/Constants/image_strings.dart';
import '../../Utilities/Constants/size.dart';
import '../../common/widgets_login_signup/form_divider.dart';
import '../../common/widgets_login_signup/social_buttons.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Positioned(
              top: 20,
              left: 20,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios_new),color: Colors.black, iconSize: Tsize.Iconmd,)),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [


              //Logo, Title, SubTitle
              const TSignUpHeader(),

              //Form
              const TForm(),

              //Divider
              TDivider(dividerText: Ttexts.orSignUpWith.capitalize! ),

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

  @override
  Widget build(BuildContext context) {
    return Form(
      child:
      Padding(
        padding: const EdgeInsets.symmetric(vertical: Tsize.spaceBtwSections),
        child: Column(
          children: [
            TextFormField(
                decoration: InputDecoration(
                    prefixIcon : Icon(Icons.person),
                    labelText: Ttexts.firstName,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))


                )),
            const SizedBox( height: Tsize.spaceBtwinputfield,),
            TextFormField(
                decoration: InputDecoration(
                    prefixIcon : Icon(Icons.person),
                    labelText: Ttexts.lastName,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))


                )),
            const SizedBox( height: Tsize.spaceBtwinputfield,),
            TextFormField(
                decoration: InputDecoration(
                    prefixIcon : Icon(Icons.email_outlined),
                    labelText: Ttexts.email,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))


                )),
            const SizedBox( height: Tsize.spaceBtwinputfield,),
            TextFormField(
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

              ],
            ),
            const SizedBox(height:  Tsize.spaceBtwSections,),

            const SizedBox(height:  Tsize.spaceBtwItems,),

            SizedBox(width: double.infinity, child: OutlinedButton(onPressed: (

                ){}, child: Text(Ttexts.signUp))),
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

            Text(Ttexts.signUp, style: Theme.of(context).textTheme.headlineLarge,),
          ],

        ),

        const SizedBox( height: Tsize.md,),
        Text(Ttexts.SignUpTitle, style: Theme.of(context).textTheme.bodyLarge,),

      ],
    );
  }
}



