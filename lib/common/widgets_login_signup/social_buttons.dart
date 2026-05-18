import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:trust_hire_app/Utilities/Constants/colors.dart';
import 'package:trust_hire_app/Utilities/Constants/text_strings.dart';
import 'package:trust_hire_app/common/styles/spacing_styles.dart';

import '../../Utilities/Constants/image_strings.dart';
import '../../Utilities/Constants/size.dart';



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
}