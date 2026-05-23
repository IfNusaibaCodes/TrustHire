import 'package:flutter/material.dart';
import 'package:trust_hire_app/Utilities/Constants/colors.dart';

class TCheckbox {
  TCheckbox._();

  static CheckboxThemeData lightCheckboxTheme = CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(4)),
    checkColor: MaterialStateProperty.resolveWith((states){
      if(states.contains(MaterialState.selected)){
        return Colors.white;
      }else{
        return Colors.black;
      }
    }),
    fillColor: MaterialStateProperty.resolveWith((states){
      if(states.contains(MaterialState.selected)){
        return TColors.primaryColor;
      }else{
        return Colors.transparent;
      }
    })
  );


}