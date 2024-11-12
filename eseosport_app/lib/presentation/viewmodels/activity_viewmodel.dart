import 'package:flutter/material.dart';
import '../../data/models/activity_model.dart';
import '../../data/repositories/activity_repository.dart';
class ActivityViewModel extends ChangeNotifier {
  final ActivityRepository _activityRepository;
  List<Activity> _activities = [];
  bool _isLoading = false;
  String? _errorMessage;
  final int currentUserId;

  ActivityViewModel(this._activityRepository, this.currentUserId) {
    fetchUserActivities();
  }

  List<Activity> get activities => _activities;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchUserActivities() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _activities = await _activityRepository.getActivitiesByUserId(currentUserId);
    } catch (e) {
      _errorMessage = 'Erreur lors du chargement des activités.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveActivity(Activity activity) async {
    try {
      activity = activity.copyWith(userId: currentUserId); // Assurer que l'ID utilisateur est défini
      await _activityRepository.saveActivity(activity);
      await fetchUserActivities(); // Recharger les activités après la sauvegarde
    } catch (e) {
      _errorMessage = 'Erreur lors de la sauvegarde de l\'activité.';
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
      _errorMessage = 'Erreur lors de la suppression de l\'activité.';
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
