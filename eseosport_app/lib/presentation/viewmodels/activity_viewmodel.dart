import 'package:flutter/material.dart';
import '../../data/models/activity_model.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/activity_repository.dart';
import '../../data/repositories/auth_repository.dart';

class ActivityViewModel extends ChangeNotifier {
  final ActivityRepository _activityRepository;
  final AuthRepository _authRepository;
  int? _currentUserId;
  List<Activity> _activities = [];
  bool _isLoading = false;
  String? _errorMessage;

  ActivityViewModel(this._activityRepository, this._authRepository) {
    _initializeUser();
  }

  List<Activity> get activities => _activities;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;


  Future<void> refreshUserActivities() async {
    _currentUserId = await _authRepository.getCachedUserId();
    await fetchUserActivities();
  }


  Future<void> _initializeUser() async {
    try {
      UserModel? cachedUser = await _authRepository.getCachedUser();
      if (cachedUser == null) {
        throw Exception('No authenticated user found');
      }
      _currentUserId = cachedUser.id;
    } catch (e) {
      _errorMessage = 'Error initializing user: $e';
      _currentUserId = null;
      _activities = [];
      notifyListeners();
    }
  }

  Future<void> fetchUserActivities() async {

    if (_currentUserId == null) {
      print('No user ID found');
      _errorMessage = 'User not authenticated';
      _activities = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _activities = await _activityRepository.getActivitiesByUserId(_currentUserId!);

      if (_activities.isEmpty) {
        _errorMessage = 'No activities found for this user';
      }
    } catch (e) {
      _errorMessage = 'Error loading activities: $e';
      _activities = [];
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveActivity(Activity activity) async {
    try {
      UserModel? user = await _authRepository.getCachedUser();
      if (user == null) {
        throw Exception('No authenticated user found');
      }

      Activity newActivity = activity.copyWith(
        user: user,
        idActivity: 0
      );

      await _activityRepository.saveActivity(newActivity);
      await fetchUserActivities();
    } catch (e) {
      _errorMessage = 'Error saving activity: $e';
      print('Full error details: $e');
      notifyListeners();
      rethrow;
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

  void clearActivities() {
    _activities = [];
    _currentUserId = null;
    _errorMessage = null;
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
