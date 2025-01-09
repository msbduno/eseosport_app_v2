import 'package:flutter/cupertino.dart';

Widget buildDataColumn(String label, String value, String unit, {double fontSize = 16.0}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            color: CupertinoColors.systemGrey,
            fontSize: fontSize,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: fontSize * 2,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          unit,
          style: TextStyle(
            color: CupertinoColors.systemGrey,
            fontSize: fontSize * 0.65,
          ),
        ),
      ],
    ),
  );
}