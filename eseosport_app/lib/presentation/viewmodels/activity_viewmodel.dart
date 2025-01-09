import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  // Getters
  List<Activity> get activities => _activities;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Initialize user
  Future<void> _initializeUser() async {
    try {
      UserModel? cachedUser = await _authRepository.getCachedUser();
      if (cachedUser == null) {
        throw Exception('No authenticated user found');
      }
      _currentUserId = cachedUser.id;
      await fetchUserActivities();
    } catch (e) {
      _errorMessage = 'Error initializing user: $e';
      _currentUserId = null;
      _activities = [];
      notifyListeners();
    }
  }

  // Refresh user activities
  Future<void> refreshUserActivities() async {
    try {
      _currentUserId = await _authRepository.getCachedUserId();
      await fetchUserActivities();
      getlastActivity();
    } catch (e) {
      _errorMessage = 'Error refreshing activities: $e';
      notifyListeners();
    }
  }

  // Fetch user activities
  Future<void> fetchUserActivities() async {
    if (_currentUserId == null) {
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
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save activity
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
      await fetchUserActivities(); // Refresh activities
      getlastActivity(); // Update last activity
      notifyListeners(); // Notify widgets of changes
    } catch (e) {
      _errorMessage = 'Error saving activity: $e';
      print('Full error details: $e');
      notifyListeners();
      rethrow;
    }
  }

  // Delete activity
  Future<void> deleteActivity(int id) async {
    try {
      await _activityRepository.deleteActivity(id);
      _activities.removeWhere((activity) => activity.idActivity == id);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error deleting activity: $e';
      notifyListeners();
      throw e;
    }
  }

  // Clear activities
  void clearActivities() {
    _activities = [];
    _currentUserId = null;
    _errorMessage = null;
    notifyListeners();
  }

  // Get last activity
  void getlastActivity() {
    if (_activities.isNotEmpty) {
      _activities.sort((a, b) => b.date.compareTo(a.date)); // Sort in descending order
      notifyListeners();
    }
  }

  // Get number of activities for a specific day
  int getNumberOfActivitiesOftheDay(DateTime date) {
    if (_activities.isEmpty) return 0;

    String dateStr = DateFormat('yyyy-MM-dd').format(date);
    return _activities.where((activity) =>
    DateFormat('yyyy-MM-dd').format(activity.date) == dateStr
    ).length;
  }

  // Get activities for current week with optional type filter
  Map<String, int> getActivitiesForCurrentWeek([String activityType = 'All']) {
    Map<String, int> activitiesPerDay = {};

    // Get the start of the current week (Monday)
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    // Initialize all days of the week with 0
    for (int i = 0; i < 7; i++) {
      DateTime day = startOfWeek.add(Duration(days: i));
      String formattedDate = DateFormat('yyyy-MM-dd').format(day);
      activitiesPerDay[formattedDate] = 0;
    }

    // Count activities for each day
    for (Activity activity in _activities) {
      if (activityType == 'All' ||
          activity.activityType.toLowerCase() == activityType.toLowerCase()) {
        String activityDate = DateFormat('yyyy-MM-dd').format(activity.date);
        if (activitiesPerDay.containsKey(activityDate)) {
          activitiesPerDay[activityDate] = activitiesPerDay[activityDate]! + 1;
        }
      }
    }

    return activitiesPerDay;
  }

  // Get statistics for a specific period
  Map<String, dynamic> getStatistics(DateTime startDate, DateTime endDate, [String activityType = 'All']) {
    List<Activity> filteredActivities = _activities.where((activity) {
      bool dateInRange = activity.date.isAfter(startDate.subtract(Duration(days: 1))) &&
          activity.date.isBefore(endDate.add(Duration(days: 1)));
      bool typeMatch = activityType == 'All' ||
          activity.activityType.toLowerCase() == activityType.toLowerCase();
      return dateInRange && typeMatch;
    }).toList();

    if (filteredActivities.isEmpty) {
      return {
        'totalActivities': 0,
        'totalDistance': 0.0,
        'averageSpeed': 0.0,
        'totalDuration': 0,
        'averageBPM': 0.0
      };
    }

    double totalDistance = filteredActivities.fold(0.0, (sum, activity) => sum + activity.distance);
    int totalDuration = filteredActivities.fold(0, (sum, activity) => sum + activity.duration);
    double totalSpeed = filteredActivities.fold(0.0, (sum, activity) => sum + activity.averageSpeed);
    double totalBPM = filteredActivities.fold(0.0, (sum, activity) => sum + (activity.averageBPM ?? 0));

    return {
      'totalActivities': filteredActivities.length,
      'totalDistance': totalDistance,
      'averageSpeed': totalSpeed / filteredActivities.length,
      'totalDuration': totalDuration,
      'averageBPM': filteredActivities.where((a) => a.averageBPM != null).isEmpty
          ? 0.0
          : totalBPM / filteredActivities.where((a) => a.averageBPM != null).length
    };
  }
}