import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthRepository {
  //final String apiUrl = 'http://localhost:8080/api'; // For iOS simulator
  //final String apiUrl  = 'http://10.0.2.2:8080/api'; // For Android emulator
  final String apiUrl = 'http://172.23.1.246:8080/api'; // For physical devices

  Future<UserModel> login(String email, String password) async {
    try {
      final loginResponse = await http.post(
        Uri.parse('$apiUrl/users/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );
      if (loginResponse.statusCode == 200) {
        final userData = json.decode(loginResponse.body);
        final user = UserModel.fromJson(userData);
        // Sauvegarder les informations utilisateur
        await _saveUserData(user);
        return user;
      }
      throw Exception('Login failed');
    } catch (e) {
      print('Login error: $e');
      throw e;
    }
  }

  Future<UserModel> register(UserModel user) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/users/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user.toJson()),
      );

      if (response.statusCode == 201) {
        final userData = json.decode(response.body);
        final createdUser = UserModel.fromJson(userData);
        // Sauvegarder les informations utilisateur
        await _saveUserData(createdUser);
        return createdUser;
      }
      throw Exception('Registration failed');
    } catch (e) {
      print('Registration error: $e');
      throw e;
    }
  }


  static const String _userKey = 'cached_user';

  Future<void> _saveUserData(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = user.toJson();
    await prefs.setString(_userKey, jsonEncode(userData));
  }

  Future<UserModel?> getCachedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_userKey);
    if (userData != null) {
      final Map<String, dynamic> userMap = jsonDecode(userData);
      return UserModel.fromJson(userMap);
    }
    return null;
  }
  Future<int?> getCachedUserId() async {
  try {
    final user = await getCachedUser();
    return user?.id;
  } catch (e) {
    print('Error retrieving cached user ID: $e');
    return null;
  }
}


  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
  }
}
