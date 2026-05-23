import 'package:flutter/material.dart';
import 'package:trust_hire_app/Utilities/Constants/colors.dart';

import '../../Constants/size.dart';
import '../../Constants/text_strings.dart';

class TTextField {
  TTextField._();

  static final InputDecorationTheme inputDecoration = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: TColors.grey,
    suffixIconColor: TColors.grey,
    hintStyle: const TextStyle(
      fontSize: Tsize.Fontxs,
      color: TColors.grey
    ),
    labelStyle: const TextStyle(
      fontSize: Tsize.Fontxs,
      color: TColors.grey
    ),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20))

  );

}