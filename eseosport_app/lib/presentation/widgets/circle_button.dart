import 'package:flutter/cupertino.dart';

class CupertinoCircleButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData? icon;
  final Color color;
  final double size;

  const CupertinoCircleButton({
    Key? key,
    required this.onPressed,
    this.icon,
    required this.color,
    this.size = 50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        child: Icon(
          icon,
          color: CupertinoColors.white,
          size: size * 0.5,
        ),
      ),
    );
  }
}