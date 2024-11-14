import 'package:flutter/material.dart';
import '../../data/models/activity_model.dart';
import '../../data/repositories/activity_repository.dart';
import '../../data/repositories/auth_repository.dart';

class ActivityViewModel extends ChangeNotifier {
  final ActivityRepository _activityRepository;
  final AuthRepository _authRepository;
  int? _currentUserId ;
  List<Activity> _activities = [];
  bool _isLoading = false;
  String? _errorMessage;

  ActivityViewModel(this._activityRepository, this._authRepository) {
    _initializeUser();
  }

  int get currentUserId {
    if (_currentUserId == null || _currentUserId! <= 0) {
      throw Exception('User not authenticated');
    }
    return _currentUserId!;
  }

  List<Activity> get activities => _activities;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> _initializeUser() async {
    try {
      _currentUserId = await _authRepository.getCachedUserId();
      if (_currentUserId != null) {
        await fetchUserActivities();
      } else {
        throw Exception('No authenticated user found');
      }
    } catch (e) {
      _errorMessage = 'Error initializing user: $e';
      notifyListeners();
    }
  }

  Future<void> fetchUserActivities() async {
    if (_currentUserId == null) {
      _errorMessage = 'User not authenticated';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _activities = await _activityRepository.getActivitiesByUserId(_currentUserId!);
    } catch (e) {
      _errorMessage = 'Error loading activities: $e';
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveActivity(Activity activity) async {
    try {
      if (_currentUserId == null || _currentUserId! <= 0) {
        throw Exception('User not authenticated');
      }

      print('Saving activity for user: $_currentUserId'); // Log pour déboguer
      activity = activity.copyWith(userId: _currentUserId);
      await _activityRepository.saveActivity(activity);
      await fetchUserActivities();
    } catch (e) {
      _errorMessage = 'Error saving activity: $e';
      print(_errorMessage);
      notifyListeners();
      throw e;
    }
  }

  Future<void> deleteActivity(int id) async {
    try {
      await _activityRepository.deleteActivity(id);
      _activities.removeWhere((activity) => activity.idActivity == id);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error deleting activity: $e';
      print(_errorMessage);
      notifyListeners();
      throw e;
    }
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
