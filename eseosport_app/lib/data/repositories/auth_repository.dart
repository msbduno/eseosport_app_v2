import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
final String apiUrl = 'http://localhost:8080/api'; // For iOS simulator
//final String apiUrl  = 'http://10.0.2.2:8080/api'; // For Android emulator
//final String apiUrl = 'http://192.168.1.168:8080/api';  // Updated to include port 8080

class AuthRepository {
  final String apiUrl = 'https://3a68-77-158-156-138.ngrok-free.app/api';
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
        await _saveUserData(user);
        return user;
      } else {
        print('Login failed with status code: ${loginResponse.statusCode}');
        throw Exception('Login failed with status code: ${loginResponse.statusCode}');
      }
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

  Future<int?> getCachedUserId() async {
    try {
      final user = await getCachedUser();
      return user?.id;
    } catch (e) {
      print('Error retrieving cached user ID: $e');
      return null;
    }
  }

  Future<void> _saveUserData(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = user.toJson();
    await prefs.setString(_userKey, jsonEncode(userData));
  }

  Future<UserModel?> getCachedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_userKey);

    if (userData != null) {
      try {
        final Map<String, dynamic> userMap = jsonDecode(userData);
        return UserModel.fromJson(userMap);
      } catch (e) {
        print('Error parsing cached user data: $e');
        return null;
      }
    }
    return null;
  }

  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
  Future<UserModel> updateUser(UserModel user) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/users/${user.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user.toJson()),
      );

      if (response.statusCode == 200) {
        final updatedUserData = json.decode(response.body);
        final updatedUser = UserModel.fromJson(updatedUserData);
        await _saveUserData(updatedUser);
        return updatedUser;
      }
      throw Exception('Failed to update user: ${response.statusCode}');
    } catch (e) {
      print('Update user error: $e');
      throw e;
    }
  }

}