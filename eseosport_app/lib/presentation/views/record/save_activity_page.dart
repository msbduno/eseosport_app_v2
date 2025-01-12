import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/activity_model.dart';
import '../../viewmodels/activity_viewmodel.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../activity/activities_page.dart';

class SaveActivityPage extends StatefulWidget {
  final Activity activity;

  const SaveActivityPage({Key? key, required this.activity}) : super(key: key);

  @override
  _SaveActivityPageState createState() => _SaveActivityPageState();
}

class _SaveActivityPageState extends State<SaveActivityPage> {
  final _formKey = GlobalKey<FormState>();
  String? _activityType;
  String? _comment;

  String _getDefaultActivityName() {
    if (_activityType == null) return 'Select activity type first';
    return ' ${_activityType!} activity';
  }

  void _showErrorDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <CupertinoDialogAction>[
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
  }

  @override
  void dispose() {
    super.dispose();
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
        return Icons.fitness_center;
    }
  }

  @override
  Widget build(BuildContext context) {
    final activityViewModel = Provider.of<ActivityViewModel>(context);
    final authViewModel = Provider.of<AuthViewModel>(context);

    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: const Text('Activity Details'),
            leading: CupertinoNavigationBarBackButton(
              previousPageTitle: 'Record',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          SliverFillRemaining(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Activity Type Selection moved before name
                    CupertinoFormSection(
                      header: const Text('Activity Type'),
                      children: [
                        CupertinoFormRow(
                          child: CupertinoButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                if (_activityType != null) ...[
                                  Icon(_getActivityIcon(_activityType!)),
                                  const SizedBox(width: 20),
                                ],
                                DefaultTextStyle(
                                  style: TextStyle(
                                    color: CupertinoColors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  child: Text(
                                      _activityType ?? 'Select Activity Type'),
                                ),
                              ],
                            ),
                            onPressed: () {
                              showCupertinoModalPopup(
                                context: context,
                                builder: (BuildContext context) {
                                  return CupertinoActionSheet(
                                    title: const Text('Select Activity Type'),
                                    actions: ['Cycling', 'Running', 'Walking']
                                        .map((String type) {
                                      return CupertinoActionSheetAction(
                                        onPressed: () {
                                          setState(() {
                                            _activityType = type;
                                            widget.activity.name =
                                                _getDefaultActivityName();
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Text(type),
                                      );
                                    }).toList(),
                                    cancelButton: CupertinoActionSheetAction(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    // Activity Name Section with updated placeholder
                    CupertinoFormSection(
                      header: const Text('Activity Name'),
                      children: [
                        CupertinoTextField(
                          placeholder: _getDefaultActivityName(),
                          onChanged: (value) {
                            setState(() {
                              widget.activity.name = value;
                            });
                          },
                        ),
                      ],
                    ),
                    CupertinoFormSection(
                      header: const Text('Activity Details'),
                      children: [
                        CupertinoListTile(
                          title: Text(
                              'Duration: ${widget.activity.formattedDuration}'),
                        ),
                        CupertinoListTile(
                          title: Text(
                              'Distance: ${widget.activity.distance.toStringAsFixed(3)} km'),
                        ),
                        CupertinoListTile(
                          title: Text(
                              'Elevation: ${widget.activity.elevation} meters'),
                        ),
                        CupertinoListTile(
                          title: Text(
                              'Average Speed: ${widget.activity.averageSpeed} km/h'),
                        ),
                        CupertinoListTile(
                          title: Text(
                              'Average BPM: ${widget.activity.averageBPM} bpm'),
                        ),
                      ],
                    ),
                    CupertinoFormSection(
                      header: const Text('Add a comment'),
                      children: [
                        CupertinoTextField(
                          placeholder: '',
                          prefix: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Comment : ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: CupertinoColors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '(optional)',
                                    style: TextStyle(
                                      color: CupertinoColors.systemGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _comment = value;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    CupertinoButton.filled(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (authViewModel.user == null) {
                            _showErrorDialog('User not authenticated');
                            return;
                          }

                          if (_activityType == null) {
                            _showErrorDialog('Please select an activity type');
                            return;
                          }

                          final updatedActivity = widget.activity.copyWith(
                            comment: _comment,
                            activityType: _activityType!,
                            name: widget.activity.name,
                          );

                          try {
                            await activityViewModel
                                .saveActivity(updatedActivity);
                            Navigator.of(context).pushAndRemoveUntil(
                              CupertinoPageRoute(
                                builder: (context) => const ActivitiesPage(),
                              ),
                              (route) => false,
                            );
                          } catch (e) {
                            _showErrorDialog('Error saving activity: $e');
                          }
                        }
                      },
                      child: const Text('Save Activity'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
