import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';
import 'activity_viewmodel.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  final ActivityViewModel _activityViewModel;
  bool _isLoading = false;
  String? _errorMessage;
  UserModel? _user;

  AuthViewModel(this._authRepository, this._activityViewModel);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserModel? get user => _user;
  int? getCurrentUserId() => _user?.id;

  Future<void> _initializeUser() async {
    _user = await _authRepository.getCachedUser();
    notifyListeners();
  }
  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _user = await _authRepository.login(email, password);

      // Utilisez directement le ViewModel injecté
      await _activityViewModel.refreshUserActivities();

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Login failed: ${e.toString()}';
      _user = null;
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(UserModel newUser) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _user = await _authRepository.register(newUser);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Registration failed: ${e.toString()}';
      _user = null;
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authRepository.clearUserData();
    _user = null;
    _errorMessage = null;
    notifyListeners();
  }
}