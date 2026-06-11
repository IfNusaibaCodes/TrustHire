import 'package:flutter/material.dart';

import '../../Utilities/Constants/image_strings.dart';
import '../../Utilities/Constants/size.dart';


/*
class TSocialButton extends StatelessWidget {
  const TSocialButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(100)
          ),
          child: IconButton(onPressed: (){},
              icon: const Image(
                  width: Tsize.Iconmd,
                  height: Tsize.Iconmd,
                  image: AssetImage(Timages.google))
          ),
        ),
        const SizedBox(
          width: Tsize.spaceBtwItems,
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(100)
          ),
          child: IconButton(onPressed: (){},
              icon: const Image(
                  width: Tsize.Iconmd,
                  height: Tsize.Iconmd,
                  image: AssetImage(Timages.facebook))
          ),
        ),
      ],
    );
  }
}  */


class TAuthInfo extends StatelessWidget {
  final bool isLogin;

  const TAuthInfo({
    super.key,
    required this.isLogin,
  });

  @override
  Widget build(BuildContext context) {
    if (isLogin) {
      return Center(
        child: Text(
          'For any information please call +8801733850274',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      );
    }

    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: Theme.of(context).textTheme.bodySmall,
          children: const [
            TextSpan(
              text: 'By signing up, you agree to our ',
            ),
            TextSpan(
              text: 'Terms & Conditions',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
            TextSpan(
              text: ' and ',
            ),
            TextSpan(
              text: 'Privacy Policy',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
            TextSpan(
              text: '.',
            ),
          ],
        ),
      ),
    );
  }
}