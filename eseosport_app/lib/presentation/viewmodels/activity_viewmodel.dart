import 'package:flutter/material.dart';
import '../../data/models/activity_model.dart';
import '../../data/repositories/activity_repository.dart';

class ActivityViewModel extends ChangeNotifier {
  final ActivityRepository _activityRepository;
  List<Activity> _activities = [];
  bool _isLoading = false;
  String? _errorMessage;

  ActivityViewModel(this._activityRepository) {
    fetchActivities(); // Fetch activities when the ViewModel is created
  }

  List<Activity> get activities => _activities;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchActivities() async {
    _isLoading = true;
    notifyListeners();

    try {
      _activities = await _activityRepository.getActivities();
    } catch (e) {
      _errorMessage = 'An error occurred while loading activities.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveActivity(Activity activity) async {
    await _activityRepository.saveActivity(activity);
    await fetchActivities(); // Update the list of activities
  }

  Future<void> deleteActivity(int id) async {
    await _activityRepository.deleteActivity(id);
    _activities.removeWhere((activity) => activity.idActivity == id);
    notifyListeners();
  }
}
/*class MockActivityViewModel extends ChangeNotifier {
  final List<Activity> _activities = [
    Activity(idActivity: 1, date: DateTime.parse('2023-10-02'), duration: 30, distance: 20.0, elevation: 352.1, averageSpeed: 15, averageBPM: 120, userId: 1),
    Activity(idActivity: 2,  date: DateTime.parse('2023-10-02'), duration: 40, distance: 10.0, elevation: 12.2, averageSpeed: 8, averageBPM: 160, userId: 1),
  ];

  List<Activity> get activities => _activities;

  void deleteActivity(int id) {
    _activities.removeWhere((activity) => activity.idActivity == id);
    notifyListeners();
  }
}*/
