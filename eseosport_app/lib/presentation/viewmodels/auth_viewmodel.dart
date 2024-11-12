import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  bool _isLoading = false;
  String? _errorMessage;
  UserModel? _user;

  AuthViewModel(this._authRepository);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserModel? get user => _user;



  Future<bool> login(String email, String password) async {
  try {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final user = await _authRepository.login(email, password);

    if (user != null) {
      _user = user;
      notifyListeners();
      return true;
    } else {
      _errorMessage = 'Login failed: User not found';
      _user = null;
      notifyListeners();
      return false;
    }
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

  void logout() {
    _user = null;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> updateUser() async {
    if (_user != null) {
      try {
        _isLoading = true;
        notifyListeners();

        final updatedUser = await _authRepository.getUserData(_user!.email);
        _user = updatedUser;
        notifyListeners();
      } catch (e) {
        _errorMessage = 'Failed to update user data: ${e.toString()}';
        notifyListeners();
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }
}