class DataPointModel {
  final int? id;
  final DateTime timestamp;
  final double vitesse;
  final int? bpm;
  final double? altitude;
  final int activiteId;

  DataPointModel({
    this.id,
    required this.timestamp,
    required this.vitesse,
    this.bpm,
    this.altitude,
    required this.activiteId,
  });

  // Conversion vers Map pour l'insertion dans la base de données
  Map<String, dynamic> toMap() {
    return {
      'id_data_point': id,
      'timestamp': timestamp.toIso8601String(),
      'vitesse': vitesse,
      'bpm': bpm,
      'altitude': altitude,
      'activite_id': activiteId,
    };
  }

  // Création d'un modèle à partir d'une Map
  factory DataPointModel.fromMap(Map<String, dynamic> map) {
    return DataPointModel(
      id: map['id_data_point'],
      timestamp: DateTime.parse(map['timestamp']),
      vitesse: map['vitesse'],
      bpm: map['bpm'],
      altitude: map['altitude'],
      activiteId: map['activite_id'],
    );
  }
}
