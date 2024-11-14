class Activity {
  final int? idActivity;  // Nullable car il sera null lors de la création
  final DateTime date;
  final int duration;
  final double distance;
  final double elevation;
  final double averageSpeed;
  final int averageBPM;
  final int userId;
  String? comment;

  Activity({
    this.idActivity,
    required this.date,
    required this.duration,
    required this.distance,
    required this.elevation,
    required this.averageSpeed,
    required this.averageBPM,
    required this.userId,
    this.comment,
  });

  // Méthode pour convertir l'objet Activity en JSON
  Map<String, dynamic> toJson() {
    return {
      'idActivity': idActivity,  // Changé de 'id_activity' à 'idActivity' pour correspondre au backend
      'date': date.toIso8601String(),
      'duration': duration,
      'distance': distance,
      'elevation': elevation,
      'averageSpeed': averageSpeed,
      'averageBPM': averageBPM,
      'user': {  // Ajout de l'objet user pour correspondre à la structure du backend
        'id': userId
      },
      'comment': comment,
    };
  }

  // Méthode pour créer un objet Activity à partir de JSON
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      idActivity: json['idActivity'],  // Changé de 'id_activity' à 'idActivity'
      date: DateTime.parse(json['date']),
      duration: json['duration'],
      distance: json['distance'].toDouble(),
      elevation: json['elevation'].toDouble(),
      averageSpeed: json['averageSpeed'].toDouble(),
      averageBPM: json['averageBPM'],
      userId: json['user']['id'],  // Extraction de l'ID utilisateur de l'objet user
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