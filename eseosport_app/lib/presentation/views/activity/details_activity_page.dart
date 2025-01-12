import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../data/models/activity_model.dart';



class ActivityDetailsPage extends StatelessWidget {
  final Activity activity;

  const ActivityDetailsPage({Key? key, required this.activity}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.white,
        middle: const Text(
          'Activity Details',
        ),
        leading: CupertinoNavigationBarBackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: CupertinoColors.systemGrey3,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              _getActivityIcon(activity.activityType),
                              size: 30,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activity.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              activity.date.toString().split(' ')[0],
                              style: const TextStyle(
                                color: CupertinoColors.systemGrey,
                              ),
                            ),
                            Text(
                              activity.activityType,
                              style: const TextStyle(
                                color: CupertinoColors.systemGrey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Container(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildMetricColumn(
                            'TIME',
                            activity.formattedDuration,
                            ' ',
                          ),
                          _buildMetricColumn(
                            'DISTANCE',
                            activity.distance.toString(),
                            'KILOMETERS',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildMetricRow('ELEVATION', '${activity.elevation ?? 0}', 'METERS'),
                    const SizedBox(height: 24),
                    _buildMetricRow('AVERAGE SPEED', activity.averageSpeed.toString(), 'KM/H'),
                    const SizedBox(height: 24),
                    _buildMetricRow('AVERAGE BPM', '${activity.averageBPM ?? 0}', 'BPM'),
                    const SizedBox(height: 24),
                    if (activity.comment != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'COMMENT',
                            style: const TextStyle(
                              color: CupertinoColors.systemGrey,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            activity.comment!,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricColumn(String label, String value, String unit) {
  return Expanded(
    child: Column(
      children: [
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(
            color: CupertinoColors.systemGrey,
            fontSize: 16, // Reduced font size
          ),
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: const TextStyle(
            fontSize: 28, // Reduced font size
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          unit,
          style: const TextStyle(
            color: CupertinoColors.systemGrey,
            fontSize: 12, // Reduced font size
          ),
        ),
      ],
    ),
  );
}

  Widget _buildMetricRow(String label, String value, String unit) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: CupertinoColors.systemGrey4,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: CupertinoColors.systemGrey,
              fontSize: 14,
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: const TextStyle(
                  color: CupertinoColors.systemGrey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}