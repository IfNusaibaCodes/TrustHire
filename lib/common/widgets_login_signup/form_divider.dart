import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:trust_hire_app/Utilities/Constants/colors.dart';
import 'package:trust_hire_app/Utilities/Constants/text_strings.dart';
import 'package:trust_hire_app/common/styles/spacing_styles.dart';

import '../../Utilities/Constants/image_strings.dart';
import '../../Utilities/Constants/size.dart';


class TDivider extends StatelessWidget {
  const TDivider({
    super.key, required this.dividerText,
  });

  final String dividerText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(child: Divider(color: Colors.grey, thickness: 0.5, indent:  60, endIndent: 5)),
        Text(dividerText, style: Theme.of(context).textTheme.labelMedium,),
        Flexible(child: Divider(color: Colors.grey, thickness: 0.5, indent:  5, endIndent: 60))
      ],
    );
  }
}