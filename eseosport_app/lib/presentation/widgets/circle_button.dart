import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

Widget CircleButton({
  required VoidCallback onPressed,
  required IconData icon,
  required Color color,
  double size = 50,
}) {
  return Container(
    height: size,
    width: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color,
    ),
    child: IconButton(
      icon: Icon(icon, color: AppTheme.backgroundColor),
      onPressed: onPressed,
      iconSize: size * 0.5,
    ),
  );
}
