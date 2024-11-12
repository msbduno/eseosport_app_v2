import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/activity_model.dart';

class ActivityRepository {
  final String apiUrl = 'http://10.0.2.2:8080/api/activities';

  Future<void> saveActivity(Activity activity) async {
    final response = await http.post(
      Uri.parse('$apiUrl?userId=${activity.userId}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(activity.toJson()),
    );

    if (response.statusCode != 200) {
      print('Failed to save activity: ${response.statusCode} ${response.body}');
      print('Request payload: ${json.encode(activity.toJson())}');
      throw Exception('Failed to save activity');
    }
  }

  Future<List<Activity>> getActivities() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Activity.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load activities');
    }
  }

  Future<List<Activity>> getActivitiesByUserId(int userId) async {
    final response = await http.get(Uri.parse('$apiUrl/user/$userId'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Activity.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load activities');
    }
  }

  Future<Activity> getActivityById(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/$id'));

    if (response.statusCode == 200) {
      return Activity.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load activity');
    }
  }

  Future<void> updateActivity(int id, Activity activity) async {
    final response = await http.put(
      Uri.parse('$apiUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(activity.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update activity');
    }
  }

  Future<void> deleteActivity(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete activity');
    }
  }
}