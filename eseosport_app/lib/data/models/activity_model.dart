import 'package:eseosport_app/data/models/user_model.dart';

class Activity {
  final int idActivity;
  final DateTime date;
  final int duration;
  final double distance;
  final double elevation;
  final double averageSpeed;
  final int averageBPM;
  final String? comment;
  late final UserModel? user;
  final String activityType;


Activity({
  required this.idActivity,
  required this.date,
  required this.duration,
  required double distance,
  required this.elevation,
  required this.averageSpeed,
  required this.averageBPM,
  this.comment,
  required this.user,
  this.activityType = 'Bike',
}) : distance = double.parse(distance.toStringAsFixed(3));
  String get formattedDuration {
    final hours = duration ~/ 3600;
    final minutes = (duration % 3600) ~/ 60;
    final seconds = duration % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}h ${minutes.toString().padLeft(2, '0')}m ${seconds.toString().padLeft(2, '0')}s';
    } else if (minutes > 0) {
      return '${minutes.toString().padLeft(2, '0')}m ${seconds.toString().padLeft(2, '0')}s';
    } else {
      return '${seconds.toString().padLeft(2, '0')}s';
    }
  }


  Activity copyWith({
    int? idActivity,
    DateTime? date,
    int? duration,
    double? distance,
    double? elevation,
    double? averageSpeed,
    int? averageBPM,
    String? comment,
    UserModel? user,
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
      user: user ?? this.user,
      activityType: activityType ?? this.activityType,
    );
  }

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
      'user': user?.toJson(),
      'activityType': activityType,
    };
  }

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
      activityType: json['activityType'] as String? ?? 'Bike',
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}