class Activity {
  final int idActivity;
  final DateTime date;
  final int duration;
  final double distance;
  final double elevation;
  final double averageSpeed;
  final int averageBPM;
  final String? comment;
  final int userId;
  final String activityType; // Nouveau champ

  Activity({
    required this.idActivity,
    required this.date,
    required this.duration,
    required this.distance,
    required this.elevation,
    required this.averageSpeed,
    required this.averageBPM,
    this.comment,
    required this.userId,
    this.activityType = 'Bike', // Valeur par défaut
  });

  // Mettez à jour la méthode copyWith
  Activity copyWith({
    int? idActivity,
    DateTime? date,
    int? duration,
    double? distance,
    double? elevation,
    double? averageSpeed,
    int? averageBPM,
    String? comment,
    int? userId,
    String? activityType,
  }) {
    return Activity(
      idActivity: idActivity ?? this.idActivity,
      date: date ?? this.date,
      duration: duration ?? this.duration,
      distance: distance ?? this.distance,
      elevation: elevation ?? this.elevation,
      averageSpeed: averageSpeed ?? this.averageSpeed,
      averageBPM: averageBPM ?? this.averageBPM,
      comment: comment ?? this.comment,
      userId: userId ?? this.userId,
      activityType: activityType ?? this.activityType,
    );
  }

  // Mettez à jour toJson
  Map<String, dynamic> toJson() {
    return {
      'idActivity': idActivity,
      'date': date.toIso8601String(),
      'duration': duration,
      'distance': distance,
      'elevation': elevation,
      'averageSpeed': averageSpeed,
      'averageBPM': averageBPM,
      'comment': comment,
      'userId': userId,
      'activityType': activityType,
    };
  }

  // Mettez à jour fromJson
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      idActivity: json['idActivity'] as int,
      date: DateTime.parse(json['date']),
      duration: json['duration'] as int,
      distance: json['distance'] as double,
      elevation: json['elevation'] as double,
      averageSpeed: json['averageSpeed'] as double,
      averageBPM: json['averageBPM'] as int,
      comment: json['comment'],
      userId: json['userId'] as int,
      activityType: json['activityType'] as String? ?? 'Bike',
    );
  }
}