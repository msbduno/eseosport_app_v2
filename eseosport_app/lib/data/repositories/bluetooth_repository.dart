import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:async';

class BluetoothRepository {
  StreamController<List<int>>? _dataStreamController;
  Stream<List<int>>? _dataStream;
  BluetoothDevice? _connectedDevice;

  BluetoothRepository() {
    _dataStreamController = StreamController<List<int>>();
    _dataStream = _dataStreamController?.stream;
  }

  void startScanning() {
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));
    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult r in results) {
        if (r.device.name == 'MyDevice') {
          _connectToDevice(r.device);
          break; // Avoid connecting multiple times to the same device
        }
      }
    });
  }

  void stopScanning() {
    FlutterBluePlus.stopScan();
  }

  Stream<List<int>>? getDataStream() {
    return _dataStream;
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      _connectedDevice = device;
      _discoverServices();
    } catch (e) {
      print('Error connecting to device: $e');
    }
  }

  Future<void> _discoverServices() async {
    if (_connectedDevice == null) return;
    try {
      List<BluetoothService> services = await _connectedDevice!.discoverServices();
      for (BluetoothService service in services) {
        if (service.uuid.toString() == 'Ox1111') {
          for (BluetoothCharacteristic characteristic in service.characteristics) {
            if (characteristic.uuid.toString() == '0x2222') {
              await characteristic.setNotifyValue(true);
              characteristic.value.listen((value) {
                _dataStreamController?.sink.add(value);
              });
            }
          }
        }
      }
    } catch (e) {
      print('Error discovering services: $e');
    }
  }

  void dispose() {
    _dataStreamController?.close();
    _connectedDevice?.disconnect();
  }
}