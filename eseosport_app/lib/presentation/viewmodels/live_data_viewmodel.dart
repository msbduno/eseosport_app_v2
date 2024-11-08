import 'dart:convert';
import 'package:flutter/material.dart';
import '../../data/models/data_model.dart';
import '../../data/repositories/bluetooth_repository.dart';

class LiveDataViewModel extends ChangeNotifier {
  final BluetoothRepository _bluetoothRepository;
  DataPointModel _currentData = DataPointModel(
    timestamp: DateTime.now(),
    vitesse: 0.0,
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
      // Initialize your Bluetooth configuration here if necessary
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
    // Convert raw data to String
    String jsonString = String.fromCharCodes(data);

    // Print to check received JSON content
    print('Received data: $jsonString');

    // Parse JSON
    Map<String, dynamic> jsonData = json.decode(jsonString);

    // Manually set the timestamp and activiteId
    jsonData['timestamp'] = _currentData.timestamp.toIso8601String();

    // Create a new DataPointModel object
    _currentData = DataPointModel.fromMap(jsonData);



    // Notify listeners of the change
    notifyListeners();
  } catch (e) {
    print('Error parsing data: $e');
  }
}
}