import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/activity_viewmodel.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import '../home_page.dart';
import '../profile/profile_page.dart';
import '../record/record_page.dart';
import 'details_activity_page.dart';

class ActivitiesPage extends StatelessWidget {
  const ActivitiesPage({super.key});

  IconData _getActivityIcon(String activityType) {
    switch (activityType.toLowerCase()) {
      case 'cycling':
        return Icons.directions_bike;
      case 'running':
        return Icons.directions_run;
      case 'walking':
        return Icons.directions_walk;
      default:
        return Icons.fitness_center;
    }
  }

  void _showDeleteConfirmation(
      BuildContext context, ActivityViewModel viewModel, int? activityId) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Delete Activity'),
        content: const Text('Are you sure you want to delete this activity?'),
        actions: <Widget>[
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              if (activityId != null) {
                viewModel.deleteActivity(activityId);
              }
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activityViewModel = Provider.of<ActivityViewModel>(context);
    final sortedActivities = activityViewModel.activities
      ..sort((a, b) => b.date.compareTo(a.date));

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text(
          'Activities',
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: activityViewModel.activities.length,
                itemBuilder: (context, index) {
                  final activity = activityViewModel.activities[index];
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => ActivityDetailsPage(
                                activity: activity,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          width: double.infinity,
                          color: CupertinoColors.systemBackground,
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: CupertinoColors.systemGrey4,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            _getActivityIcon(
                                                activity.activityType),
                                            color: CupertinoColors.black,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Activity ${activity.idActivity}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${activity.date.toLocal()}'
                                                  .split(' ')[0],
                                              style: TextStyle(
                                                color: CupertinoColors.systemGrey,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'TIME',
                                                style: TextStyle(
                                                  color:
                                                      CupertinoColors.systemGrey,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '${activity.formattedDuration} ',
                                                style: const TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 1,
                                          height: 50,
                                          color: CupertinoColors.systemGrey4,
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 16),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'DISTANCE',
                                                  style: TextStyle(
                                                    color: CupertinoColors
                                                        .systemGrey,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${activity.distance} km',
                                                  style: const TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                const Text(
                                                  'KILOMETERS',
                                                  style: TextStyle(
                                                    color: CupertinoColors
                                                        .systemGrey,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () => _showDeleteConfirmation(
                                    context,
                                    activityViewModel,
                                    activity.idActivity,
                                  ),
                                  child: Icon(
                                    CupertinoIcons.clear,
                                    color: CupertinoColors.systemRed,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (index < activityViewModel.activities.length - 1)
                        Container(
                          height: 1,
                          color: CupertinoColors.separator,
                        ),
                    ],
                  );
                },
              ),
            ),
            CustomCupertinoNavBar(
              currentIndex: 2,
              onTap: (index) {
                switch (index) {
                  case 1:
                    Navigator.of(context).pushAndRemoveUntil(
                      CupertinoPageRoute(
                        builder: (context) => const RecordPage(),
                      ),
                          (route) => false,
                    );
                    break;
                  case 0:
                    Navigator.of(context).pushAndRemoveUntil(
                      CupertinoPageRoute(
                        builder: (context) => HomePage(),
                      ),
                          (route) => false,
                    );
                    break;
                  case 3:
                    Navigator.of(context).pushAndRemoveUntil(
                      CupertinoPageRoute(
                        builder: (context) =>  ProfilePage(),
                      ),
                          (route) => false,
                    );
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