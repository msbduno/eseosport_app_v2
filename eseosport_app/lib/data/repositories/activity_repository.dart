import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/activity_model.dart';

class ActivityRepository {
  final String apiUrl = 'http://10.0.2.2:8080/api/activities';


  Future<void> saveActivity(Activity activity) async {
    try {
      // Assurez-vous que l'userId est converti en String
       final response = await http.post(Uri.parse('$apiUrl?userId=${activity.userId}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
         body: json.encode(activity.toJson()),
    );

      if (response.statusCode != 200 && response.statusCode != 201) {
        print('Échec de la sauvegarde: ${response.statusCode} ${response.body}');
        throw Exception('Échec de la sauvegarde de l\'activité');
       }
  } catch (e) {
  print('Erreur lors de la sauvegarde: $e');
  throw Exception('Erreur de connexion au serveur');
  }
}




  Future<List<Activity>> getActivitiesByUserId(int userId) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/user/$userId'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Activity.fromJson(json)).toList();
      } else {
        throw Exception('Échec du chargement des activités');
      }
    } catch (e) {
      print('Erreur lors du chargement des activités: $e');
      throw Exception('Erreur de connexion au serveur');
    }
  }

  Future<void> deleteActivity(int id) async {
    try {
      final response = await http.delete(Uri.parse('$apiUrl/$id'));

      if (response.statusCode != 200) {
        print('Échec de la suppression: ${response.statusCode} ${response.body}');
        throw Exception('Échec de la suppression de l\'activité');
      }
    } catch (e) {
      print('Erreur lors de la suppression: $e');
      throw Exception('Erreur de connexion au serveur');
    }
  }
}
