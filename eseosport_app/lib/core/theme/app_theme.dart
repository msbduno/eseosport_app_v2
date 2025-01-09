import 'package:flutter/cupertino.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFFE53935);
  static const Color secondaryColor = Color(0xFF757575);
  static const Color backgroundColor = CupertinoColors.white;

  static CupertinoThemeData get cupertinoTheme {
    return const CupertinoThemeData(
      primaryColor: primaryColor,
      textTheme: CupertinoTextThemeData(
        primaryColor: primaryColor,
        textStyle: TextStyle(
          color: CupertinoColors.black,
          fontSize: 16,
        ),
        navTitleTextStyle: TextStyle(
          color: CupertinoColors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}