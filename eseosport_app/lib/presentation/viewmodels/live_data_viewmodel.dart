import 'package:flutter/material.dart';

import '../../data/models/data_model.dart';
import '../../data/repositories/bluetooth_repository.dart';

class LiveDataViewModel extends ChangeNotifier {
  final BluetoothRepository _bluetoothRepository;
  DataPointModel _currentData = DataPointModel(
    timestamp: DateTime.now(),
    vitesse: 0.0,
  );
  bool _isReceivingData = false;

  LiveDataViewModel(this._bluetoothRepository);

  // Getters
  double get currentSpeed => _currentData.vitesse;
  double? get currentAltitude => _currentData.altitude;
  int? get currentBPM => _currentData.bpm;
  DateTime get timestamp => _currentData.timestamp;
  bool get isReceivingData => _isReceivingData;

  Future<void> initialize() async {
    // Optional initialization logic
  }

  void startReceivingData() {
    if (!_isReceivingData) {
      _bluetoothRepository.startScan();
      _bluetoothRepository.dataStream.listen((data) {
        _updateDataFromBluetooth(data);
      });
      _isReceivingData = true;
    }
  }

  void stopReceivingData() {
    if (_isReceivingData) {
      _bluetoothRepository.disconnectDevice();
      _isReceivingData = false;
    }
  }

  void _updateDataFromBluetooth(Map<String, dynamic> data) {
    try {
      _currentData = DataPointModel(
        timestamp: DateTime.now(),
        vitesse: (data['vitesse'] as num?)?.toDouble() ?? 0.0,
        altitude: (data['altitude'] as num?)?.toDouble(),
        bpm: data['bpm'] as int?,
      );

      notifyListeners();
    } catch (e) {
      print('Error parsing Bluetooth data: $e');
    }
  }

  @override
  void dispose() {
    stopReceivingData();
    super.dispose();
  }

  Future<bool> checkBluetoothConnection() async {
    try {
      // Perform a quick scan and check for connection
      await _bluetoothRepository.startScan(timeout: const Duration(seconds: 5));

      // Wait a short time to allow connection
      await Future.delayed(const Duration(seconds: 2));

      // Check if data is being received
      return _isReceivingData;
    } catch (e) {
      print('Bluetooth connection check failed: $e');
      return false;
    }
  }
}