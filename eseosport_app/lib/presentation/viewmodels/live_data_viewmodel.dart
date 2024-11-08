import 'dart:convert';
import 'package:flutter/material.dart';
import '../../data/models/data_point_model.dart';
import '../../data/repositories/bluetooth_repository.dart';


class LiveDataViewModel extends ChangeNotifier {
  final BluetoothRepository _bluetoothRepository;
  DataPointModel _currentData = DataPointModel(
    timestamp: DateTime.now(),
    vitesse: 0.0,
    activiteId: 0, // Vous devrez gérer cet ID selon votre logique
  );
  bool isInitialized = false;

  LiveDataViewModel(this._bluetoothRepository);

  // Getters
  double get currentSpeed => _currentData.vitesse;
  double? get currentAltitude => _currentData.altitude;
  int? get currentBPM => _currentData.bpm;
  DateTime get timestamp => _currentData.timestamp;

  Future<void> initialize() async {
    if (!isInitialized) {
      // Initialisez ici votre configuration Bluetooth si nécessaire
      isInitialized = true;
      notifyListeners();
    }
  }

  void startReceivingData() {
    _bluetoothRepository.startScanning();
    _bluetoothRepository.getDataStream()?.listen((data) {
      _updateDataFromBluetooth(data);
    });
  }

  void stopReceivingData() {
    _bluetoothRepository.stopScanning();
  }

  void _updateDataFromBluetooth(List<int> data) {
    try {
      // Convertir les données brutes en String
      String jsonString = String.fromCharCodes(data);

      // Ajoutez ce print pour vérifier le contenu du JSON reçu
      print('Données reçues : $jsonString'); // <--- Ligne à ajouter ici

      // Parser le JSON
      Map<String, dynamic> jsonData = json.decode(jsonString);

      // Mettre à jour le timestamp
      jsonData['timestamp'] = DateTime.now().toIso8601String();

      // Créer un nouvel objet DataPointModel
      _currentData = DataPointModel.fromMap(jsonData);

      // Notifier les écouteurs du changement
      notifyListeners();
    } catch (e) {
      print('Erreur lors du parsing des données: $e');
    }
  }

}
