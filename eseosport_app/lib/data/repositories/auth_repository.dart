import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthRepository {
  final String apiUrl = 'http://10.0.2.2:8080/api';

  Future<UserModel> login(String email, String password) async {
    try {
      final loginResponse = await http.post(
        Uri.parse('$apiUrl/users/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (loginResponse.statusCode != 200) {
        throw Exception('Login failed');
      }

      final userResponse = await http.get(
        Uri.parse('$apiUrl/users?email=$email'),
        headers: {'Content-Type': 'application/json'},
      );

      if (userResponse.statusCode == 200) {
        final List<dynamic> userData = json.decode(userResponse.body);
        if (userData.isNotEmpty) {
          return UserModel.fromMap(userData[0]);
        }
      }
      throw Exception('Failed to get user data');
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
        body: json.encode(user.toMap()),
      );

      if (response.statusCode != 201) {
        throw Exception('Registration failed');
      }

      final userResponse = await http.get(
        Uri.parse('$apiUrl/users?email=${user.email}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (userResponse.statusCode == 200) {
        final List<dynamic> userData = json.decode(userResponse.body);
        if (userData.isNotEmpty) {
          return UserModel.fromMap(userData[0]);
        }
      }
      throw Exception('Failed to get user data after registration');
    } catch (e) {
      print('Registration error: $e');
      throw e;
    }
  }

  Future<UserModel> getUserData(String email) async {
    try {
      final userResponse = await http.get(
        Uri.parse('$apiUrl/users?email=$email'),
        headers: {'Content-Type': 'application/json'},
      );

      if (userResponse.statusCode == 200) {
        final List<dynamic> userData = json.decode(userResponse.body);
        if (userData.isNotEmpty) {
          return UserModel.fromMap(userData[0]);
        }
      }
      throw Exception('Failed to get user data');
    } catch (e) {
      print('Get user data error: $e');
      throw e;
    }
  }
}