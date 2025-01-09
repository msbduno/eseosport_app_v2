import 'package:eseosport_app/core/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../viewmodels/activity_viewmodel.dart';

class WeeklyActivityChart extends StatefulWidget {
  @override
  _WeeklyActivityChartState createState() => _WeeklyActivityChartState();
}

class _WeeklyActivityChartState extends State<WeeklyActivityChart> {
  String selectedActivityType = 'All';

  Widget _buildSegmentedControlChild(String text, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16),
          SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activityViewModel = Provider.of<ActivityViewModel>(context);
    final activitiesPerDay = activityViewModel.getActivitiesForCurrentWeek(selectedActivityType);

    return Column(
      children: [
        Container(
          //add space vertically
          padding: EdgeInsets.symmetric(vertical: 15),

          child: CupertinoSlidingSegmentedControl<String>(
            backgroundColor: CupertinoColors.white,
            thumbColor: CupertinoColors.white,
            groupValue: selectedActivityType,
            children: {
              'All': _buildSegmentedControlChild('All', CupertinoIcons.square_grid_2x2),
              'Running': _buildSegmentedControlChild('Run', Icons.directions_run),
              'Cycling': _buildSegmentedControlChild('Bike', Icons.directions_bike),
              'Walking': _buildSegmentedControlChild('Walk', Icons.directions_walk),
            },
            onValueChanged: (String? value) {
              if (value != null) {
                setState(() {
                  selectedActivityType = value;
                });
              }
            },
          ),
        ),
        SizedBox(height: 20),
        Expanded(
          child: BarChart(
            BarChartData(
              backgroundColor: Colors.transparent,
              borderData: FlBorderData(show: false),
              gridData: FlGridData(show: false),
              alignment: BarChartAlignment.spaceAround,
              barGroups: _createBarGroups(activitiesPerDay),
              titlesData: FlTitlesData(
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      if (value == value.roundToDouble()) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            color: CupertinoColors.systemGrey,
                            fontSize: 12,
                          ),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _mapIntToDay(value.toInt()),
                          style: TextStyle(
                            color: CupertinoColors.systemGrey,
                            fontSize: 12,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<BarChartGroupData> _createBarGroups(Map<String, int> activitiesPerDay) {
    return activitiesPerDay.entries.map((entry) {
      return BarChartGroupData(
        x: _mapDayToInt(entry.key),
        barRods: [
          BarChartRodData(
            toY: entry.value.toDouble(),
            color: _getBarColor(selectedActivityType),
            width: 15,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();
  }

  Color _getBarColor(String activityType) {
    switch (activityType) {
      case 'Running':
        return AppTheme.primaryColor;
      case 'Cycling':
        return AppTheme.primaryColor;
      case 'Walking':
        return AppTheme.primaryColor;
      default:
        return AppTheme.primaryColor;
    }
  }

  int _mapDayToInt(String day) {
    final date = DateTime.parse(day);
    return date.weekday;
  }

  String _mapIntToDay(int day) {
    switch (day) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }
}