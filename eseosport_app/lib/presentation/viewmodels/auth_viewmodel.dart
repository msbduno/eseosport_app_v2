import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  bool _isLoading = false;
  String? _errorMessage;

  AuthViewModel(this._authRepository);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  UserModel? _user;

  UserModel? get user => _user;

  void setUser(UserModel? user) {
    _user = user;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    try {
      bool success = await _authRepository.login(email, password);
      if (success) {
        _user = await _authRepository.getUserData(email);
        _user = user;
        _errorMessage = null;
      } else {
        _errorMessage = 'Failed to login. Please check your credentials.';
      }
      notifyListeners(); // Assurez-vous que notifyListeners() est appelé ici
      return success;
    } catch (e) {
      _errorMessage = 'An error occurred during login.';
      notifyListeners(); // Assurez-vous que notifyListeners() est appelé ici
      return false;
    }
  }

  Future<void> register(UserModel user) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      bool success = await _authRepository.register(user);
      if (success) {
        _user = user; // Set the user data after successful registration
        _errorMessage = null;
      } else {
        _errorMessage = 'Registration failed. Please try again.';
      }
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
      print('Registration error: $e');
    } finally {
      _isLoading = false;
      notifyListeners(); // Assurez-vous que notifyListeners() est appelé ici
    }
  }
}