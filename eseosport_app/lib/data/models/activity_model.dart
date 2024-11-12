// models/activity_model.dart

class Activity {
  final int idActivity;
  final DateTime date;
  final int duration;
  final double distance;
  final double elevation;
  final double averageSpeed;
  final int averageBPM;
  final int userId;
  late final String? comment;


  Activity({
    required this.idActivity,
    required this.date,
    required this.duration,
    required this.distance,
    required this.elevation,
    required this.averageSpeed,
    required this.averageBPM,
    required this.userId,
    this.comment,
  });


  void updateComment(String newComment) {
    if (comment == null) {
      comment = newComment;
    } else {
      throw Exception('Field \'comment\' has already been initialized.');
    }
  }

  // Méthode pour convertir l'objet Activity en JSON
  Map<String, dynamic> toJson() {
    return {
      'id_activity': idActivity,
      'date': date.toIso8601String(),
      'duration': duration,
      'distance': distance,
      'elevation': elevation,
      'averageSpeed': averageSpeed,
      'averageBPM': averageBPM,
      'userId': userId,
      'comment': comment,
    };
  }

  // Méthode pour créer un objet Activity à partir de JSON
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      idActivity: json['id_activity'],
      date: DateTime.parse(json['date']),
      duration: json['duration'],
      distance: json['distance'],
      elevation: json['elevation'],
      averageSpeed: json['averageSpeed'],
      averageBPM: json['averageBPM'],
      userId: json['userId'],
      comment: json['comment'],
    );
  }


  Activity copyWith({
    int? idActivity,
    DateTime? date,
    int? duration,
    double? distance,
    double? elevation,
    double? averageSpeed,
    int? averageBPM,
    int? userId,
    String? comment,
    String? type,
  }) {
    return Activity(
      idActivity: idActivity ?? this.idActivity,
      date: date ?? this.date,
      duration: duration ?? this.duration,
      distance: distance ?? this.distance,
      elevation: elevation ?? this.elevation,
      averageSpeed: averageSpeed ?? this.averageSpeed,
      averageBPM: averageBPM ?? this.averageBPM,
      userId: userId ?? this.userId,
      comment: comment ?? this.comment,
    );
  }
}

