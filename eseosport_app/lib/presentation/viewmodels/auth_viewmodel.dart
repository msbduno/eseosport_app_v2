import 'package:flutter/material.dart';

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
    notifyListeners();

    try {
      bool success = await _authRepository.login(email, password);
      if (!success) {
        _errorMessage = 'Échec de la connexion. Veuillez vérifier vos identifiants.';
      }
    } catch (e) {
      _errorMessage = 'Une erreur est survenue. Veuillez réessayer.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(String name, String surname, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      bool success = await _authRepository.register(name, surname, email, password);
      if (!success) {
        _errorMessage = 'Échec de l\'inscription. Veuillez réessayer.';
      }
    } catch (e) {
      _errorMessage = 'Une erreur est survenue. Veuillez réessayer.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
