import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/activity_model.dart';
import '../../viewmodels/activity_viewmodel.dart';
import '../../viewmodels/auth_viewmodel.dart';

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

  @override
  Widget build(BuildContext context) {
    final activityViewModel = Provider.of<ActivityViewModel>(context);
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Activity Details',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: _activityType,
                  onChanged: (value) {
                    setState(() {
                      _activityType = value;
                    });
                  },
                  items: ['Cycling', 'Running', 'Walking']
                      .map((type) => DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  ))
                      .toList(),
                  decoration: const InputDecoration(
                    labelText: 'Activity Type',
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.primaryColor),
                    ),
                  ),
                  validator: (value) => value == null ? 'Please select an activity type' : null,
                ),
                const SizedBox(height: 30),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    title: Text(
                      'Durée: ${widget.activity.formattedDuration} \n'
                          'Distance: ${widget.activity.distance.toStringAsFixed(3)} km\n'
                          'Dénivelé: ${widget.activity.elevation} mètres',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    title: Text(
                      'Vitesse moyenne: ${widget.activity.averageSpeed} km/h\n'
                          'Fréquence cardiaque moyenne: ${widget.activity.averageBPM} bpm',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Comment',
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.primaryColor),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _comment = value;
                    });
                  },
                ),
                const SizedBox(height: 200),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: AppTheme.backgroundColor,
                    backgroundColor: AppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    minimumSize: const Size(350, 40),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (authViewModel.user == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('User not authenticated')),
                        );
                        return;
                      }

                      final updatedActivity = widget.activity.copyWith(
                        comment: _comment,
                        activityType: _activityType!,
                      );

                      try {
                        await activityViewModel.saveActivity(updatedActivity);
                        Navigator.pushReplacementNamed(context, '/activities');
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error saving activity: $e')),
                        );
                      }
                    }
                  },
                  child: Text('Save Activity'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}