import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static Color appColor = const Color(0xff282A3A);
  static Color primary = Color(0xffC59750);
  static Color whiteColor = Colors.white;
  static Color white = Colors.white;

}

Color hexToColor(String hex) {
  assert(RegExp(r'^#([0-9a-fA-F]{6})|([0-9a-fA-F]{8})$').hasMatch(hex),
      'hex color must be #rrggbb or #rrggbbaa');

  return Color(
    int.parse(hex.substring(1), radix: 16) +
        (hex.length == 7 ? 0xff000000 : 0x00000000),
  );
}

class MyColors {
  static Color lightScaffoldBackgroundColor = hexToColor('#F9F9F9');
  static Color darkScaffoldBackgroundColor = hexToColor('#2F2E2E');
  static Color secondaryAppColor = Colors.white;
  static Color secondaryDarkAppColor = Colors.white;
  static Color fareIconsColor = const  Color.fromARGB(255, 218, 210, 231);
  
}