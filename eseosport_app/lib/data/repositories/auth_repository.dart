import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthRepository {
  final String apiUrl = 'http://10.0.2.2:8080/api';

  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/users/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<UserModel> getUserData(String email) async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/users?email=$email'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          return UserModel.fromMap(data[0]);
        } else {
          throw Exception('User not found');
        }
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      print('Get user data error: $e');
      throw e;
    }
  }

  Future<bool> register(UserModel user) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/users/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user.toMap()),
      );

      return response.statusCode == 201;
    } catch (e) {
      print('Registration error: $e');
      return false;
    }
  }
}