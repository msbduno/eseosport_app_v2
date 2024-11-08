import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthRepository {
  final String apiUrl = 'http://your-spring-api-url/auth'; // Remplace par l'URL de ton API

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$apiUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      // Traiter la réponse et éventuellement stocker le token d'authentification
      return true;
    } else {
      return false; // Gérer les erreurs
    }
  }

  Future<bool> register(String name, String surname, String email, String password) async {
    final response = await http.post(
      Uri.parse('$apiUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'surname': surname,
        'email': email,
        'password': password,
      }),
    );

    return response.statusCode == 201;
  }
}



