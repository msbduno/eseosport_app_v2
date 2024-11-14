import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
        title: Text('Save Activity'),
      ),
      body: Padding(
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
                items: ['Running', 'Cycling', 'Swimming']
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                decoration: InputDecoration(labelText: 'Activity Type'),
                validator: (value) => value == null ? 'Please select an activity type' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Comment'),
                onChanged: (value) {
                  setState(() {
                    _comment = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
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
)
            ],
          ),
        ),
      ),
    );
  }

}
