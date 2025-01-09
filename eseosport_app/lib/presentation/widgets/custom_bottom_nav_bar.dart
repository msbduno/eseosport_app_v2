import 'package:flutter/cupertino.dart';
import '../../core/theme/app_theme.dart';

class CustomCupertinoNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomCupertinoNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoTabBar(
      items: const [
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Icon(CupertinoIcons.home),
          ),
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Icon(CupertinoIcons.add_circled),
          ),
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Icon(CupertinoIcons.graph_square),
          ),
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Icon(CupertinoIcons.person),
          ),
        ),
      ],
      currentIndex: currentIndex,
      onTap: onTap,
      activeColor: AppTheme.primaryColor,
      inactiveColor: CupertinoColors.systemGrey,
      backgroundColor: CupertinoColors.white,
    );
  }
}