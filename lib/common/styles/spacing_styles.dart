import 'package:flutter/material.dart';

import '../../Utilities/Constants/size.dart';

class TSpacingStyle{
  static const EdgeInsetsGeometry paddingWithAppBarHeight = EdgeInsets.only(
    top: Tsize.appBarHeight,
    left: Tsize.defaultSpace,
    bottom: Tsize.defaultSpace,
    right: Tsize.defaultSpace
  );
}