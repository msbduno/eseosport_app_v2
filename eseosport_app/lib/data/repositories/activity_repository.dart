import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/activity_model.dart';

class ActivityRepository {
  final String apiUrl = 'https://f2a7-77-158-156-138.ngrok-free.app/api';

  Future<void> saveActivity(Activity activity) async {
    final url = Uri.parse('$apiUrl/activities');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(activity.toJson()),
    );

    if (response.statusCode == 201) {
      // Activity saved successfully
    } else {
      _handleError(response);
    }
  }

  Future<List<Activity>> getActivitiesByUserId(int userId) async {
    final url = Uri.parse('$apiUrl/activities/user/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Activity.fromJson(json)).toList();
    } else {
      _handleError(response);
      return [];
    }
  }

  Future<void> deleteActivity(int id) async {
    final url = Uri.parse('$apiUrl/activities/$id');
    final response = await http.delete(url);

    if (response.statusCode != 204) {
      _handleError(response);
    }
  }

  void _handleError(http.Response response) {
    String errorMessage;
    switch (response.statusCode) {
      case 400:
        errorMessage = 'Bad request. Please check the data you are sending.';
        break;
      case 401:
        errorMessage = 'Unauthorized. Please check your credentials.';
        break;
      case 403:
        errorMessage = 'Forbidden. You do not have permission to perform this action.';
        break;
      case 404:
        errorMessage = 'Not found. The requested resource could not be found.';
        break;
      case 500:
        errorMessage = 'Internal server error. Please try again later.';
        break;
      default:
        errorMessage = 'An unexpected error occurred. Please try again.';
    }
    throw Exception(errorMessage);
  }

}