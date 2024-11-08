import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/activity_model.dart';
import '../../viewmodels/activity_viewmodel.dart';
import '../../widgets/custom_bottom_nav_bar.dart';

class SaveActivityPage extends StatefulWidget {
  const SaveActivityPage({super.key});

  @override
  _SaveActivityPageState createState() => _SaveActivityPageState();
}

class _SaveActivityPageState extends State<SaveActivityPage> {
  final TextEditingController _commentController = TextEditingController();
  String _selectedActivity = 'Bike'; // Default selected activity
  final List<String> _activities = ['Bike', 'Run', 'Walk'];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Activity activity = ModalRoute.of(context)!.settings.arguments as Activity;

    Future<void> saveActivity() async {
      final activityViewModel = Provider.of<ActivityViewModel>(context, listen: false);
      activity.updateComment(_commentController.text); // Update the comment
      await activityViewModel.saveActivity(activity);
      if (!mounted) return; // Ensure the widget is still in the widget tree
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(
            'Activity saved successfully!',
            style: TextStyle(color: AppTheme.backgroundColor),
          ),
            backgroundColor: AppTheme.primaryColor,
          ),
        );
        Navigator.pushReplacementNamed(context, '/activities');
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your activity',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600, // Semi-bold
          ),
        ),
        centerTitle: false, // Align to the left
        automaticallyImplyLeading: false, // Remove the back arrow
        backgroundColor: Colors.white, // Set AppBar background color to white
      ),
      backgroundColor: Colors.white, // Set background color to white
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0), // Add padding to the entire body
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${activity.date}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                title: DropdownButton<String>(
                  value: _selectedActivity,
                  items: _activities.map((String activity) {
                    return DropdownMenuItem<String>(
                      value: activity,
                      child: Text(activity),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedActivity = newValue!;
                    });
                  },
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
                  'Duration: ${activity.duration} seconds\n'
                      'Distance: ${activity.distance} km\n'
                      'Elevation: ${activity.elevation} meters',
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
                  'Average Speed: ${activity.averageSpeed} km/h\n'
                      'Average BPM: ${activity.averageBPM}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Add a comment...',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
                maxLines: 3,
              ),
            ),
            const SizedBox(height: 150),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: AppTheme.backgroundColor,
                  backgroundColor: AppTheme.primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  minimumSize: const Size(350, 40),
                ),
                onPressed: saveActivity,
                child: const Text('Save Activity'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/record');
          }else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/profile');
          }
        },
      ),
    );
  }
}