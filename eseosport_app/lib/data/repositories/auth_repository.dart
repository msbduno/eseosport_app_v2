import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthRepository {
  final String apiUrl = 'http://10.0.2.2:8080/api';

  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['success'];
      } else {
        print('Login failed: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<bool> register(UserModel user) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user.toMap()),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      return response.statusCode == 201;
    } catch (e) {
      print('Registration error: $e');
      return false;
    }
  }
}