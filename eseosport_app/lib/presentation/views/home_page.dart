import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_theme.dart';
import '../viewmodels/activity_viewmodel.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../widgets/weekly_chart_widget.dart';
import 'activity/details_activity_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ActivityViewModel>(context, listen: false).getlastActivity();
    });
  }

  IconData _getActivityIcon(String activityType) {
    switch (activityType.toLowerCase()) {
      case 'cycling':
        return Icons.directions_bike;
      case 'running':
        return Icons.directions_run;
      case 'walking':
        return Icons.directions_walk;
      default:
        return CupertinoIcons.question;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: CupertinoColors.white,
        middle: Text(
          'ESEOSPORT',
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 20),
                          Container(
                            decoration: BoxDecoration(
                              color: CupertinoColors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: CupertinoColors.systemGrey
                                      .withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Weekly Report - Activities",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: CupertinoColors.systemGrey,
                                  ),
                                ),
                                SizedBox(
                                  height: 170,
                                  width: 500,
                                  child: WeeklyActivityChart(),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: CupertinoColors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: CupertinoColors.systemGrey
                                          .withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(16.0),
                                child: SizedBox(
                                  height: 125,
                                  width: 135,
                                  child: Consumer<ActivityViewModel>(
                                    builder:
                                        (context, activityViewModel, child) {
                                      if (activityViewModel
                                          .activities.isNotEmpty) {
                                        final lastActivity =
                                            activityViewModel.activities.first;
                                        return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (context) =>
                                                      ActivityDetailsPage(
                                                    activity: lastActivity,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Last Activity",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: CupertinoColors
                                                        .systemGrey,
                                                  ),
                                                ),
                                                SizedBox(height: 20),
                                                Center(
                                                  child: Icon(
                                                    _getActivityIcon(lastActivity
                                                        .activityType), // Activity type icon
                                                    size: 45,
                                                  ),
                                                ),
                                                SizedBox(height: 20),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      CupertinoIcons.location,
                                                      size: 20,
                                                    ),
                                                    SizedBox(width: 4),
                                                    Text(
                                                        " ${lastActivity.distance} km"),
                                                  ],
                                                ),
                                              ],
                                            ));
                                      } else {
                                        return Text(
                                          "No activities found",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: CupertinoColors.systemGrey,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: CupertinoColors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: CupertinoColors.systemGrey
                                          .withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(16.0),
                                child: SizedBox(
                                  height: 125,
                                  width: 135,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          showCupertinoDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                CupertinoAlertDialog(
                                              title: const Text('Notice'),
                                              content: const Text(
                                                  'In development'),
                                              actions: <Widget>[
                                                CupertinoDialogAction(
                                                  isDefaultAction: true,
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Weather ",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: CupertinoColors
                                                    .systemGrey,
                                              ),
                                            ),
                                            const SizedBox(height: 25),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "5°C", // Example temperature
                                                  style: TextStyle(
                                                    fontSize: 24,
                                                  ),
                                                ),
                                                const SizedBox(width: 20),
                                                Icon(
                                                  CupertinoIcons.cloud_sun,
                                                  size: 44,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 40),
                          const Text(
                            'PFE DESCRIPTION',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            'Launch date : September 16, 2024',
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 40),
                          const Text(
                            'The ESEOSPORT project is an innovative project designed to showcase the technological skills and expertise of ESEO, combining electronics and computer science. This application offers an immersive experience allowing users to explore various aspects of a velomobile and evaluate their physical performance.',
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 40),
                          Container(
                            decoration: BoxDecoration(
                              color: CupertinoColors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: CupertinoColors.systemGrey
                                      .withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(16.0),
                            child: Image.asset('assets/solution.png'),
                          ),
                          const SizedBox(height: 40),
                          const Text(
                            'In collaboration with Cycles JV Fenioux, a velomobile manufacturer, this project is designed to be scalable. It is part of a final year project for ESEO students.',
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 30),
                          GestureDetector(
                            onTap: () async {
                              const url = 'https://www.eseo.fr';
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            child: const Text(
                              'You can visit the ESEO website here',
                              style: TextStyle(
                                fontSize: 14,
                                color: CupertinoColors.activeBlue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            CustomCupertinoNavBar(
              currentIndex: 0,
              onTap: (index) {
                switch (index) {
                  case 1:
                    Navigator.pushReplacementNamed(context, '/record');
                    break;
                  case 2:
                    Navigator.pushReplacementNamed(context, '/activity');
                    break;
                  case 3:
                    Navigator.pushReplacementNamed(context, '/profile');
                    break;
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}