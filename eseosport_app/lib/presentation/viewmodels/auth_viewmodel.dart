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

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      bool success = await _authRepository.login(email, password);
      if (!success) {
        _errorMessage = 'Login failed. Please check your credentials.';
      }
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
      print('Login error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(UserModel user) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      bool success = await _authRepository.register(user);
      if (!success) {
        _errorMessage = 'Registration failed. Please try again.';
      }
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
      print('Registration error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}