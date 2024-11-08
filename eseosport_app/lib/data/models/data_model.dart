class DataPointModel {
  final DateTime timestamp;
  final double vitesse;
  final int? bpm;
  final double? altitude;

  DataPointModel({
    required this.timestamp,
    required this.vitesse,
    this.bpm,
    this.altitude,
  });

  // Conversion vers Map pour l'insertion dans la base de données
  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'vitesse': vitesse,
      'bpm': bpm,
      'altitude': altitude,
    };
  }

  // Création d'un modèle à partir d'une Map
  factory DataPointModel.fromMap(Map<String, dynamic> map) {
    return DataPointModel(
      timestamp: DateTime.parse(map['timestamp']),
      vitesse: map['vitesse'],
      bpm: map['bpm'],
      altitude: map['altitude'],
    );
  }
}
