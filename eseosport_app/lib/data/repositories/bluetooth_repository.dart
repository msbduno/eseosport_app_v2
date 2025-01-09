import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothRepository extends ChangeNotifier {
  static const String TARGET_DEVICE_NAME = 'BLE-Random';
  static const String SERVICE_UUID = '1111';
  static const String CHARACTERISTIC_UUID = '2222';

  BluetoothDevice? _connectedDevice;
  BluetoothCharacteristic? _dataCharacteristic;
  final _dataController = StreamController<Map<String, dynamic>>.broadcast();
  bool _isScanning = false;
  bool _isConnected = false;

  Stream<Map<String, dynamic>> get dataStream => _dataController.stream;
  bool get hasDataCharacteristic => _dataCharacteristic != null;
  bool get isScanning => _isScanning;
  bool get isConnected => _isConnected;

  Future<bool> startScan({Duration timeout = const Duration(seconds: 10)}) async {
    try {
      _isScanning = true;
      notifyListeners();
      print('Démarrage du scan Bluetooth...');

      if (await FlutterBluePlus.isAvailable == false) {
        print('Bluetooth non supporté sur cet appareil');
        _isScanning = false;
        notifyListeners();
        return false;
      }

      await FlutterBluePlus.stopScan();

      final completer = Completer<bool>();

      FlutterBluePlus.scanResults.listen((results) async {
        for (ScanResult result in results) {
          if (result.device.name == TARGET_DEVICE_NAME) {
            print('Appareil ESP32 trouvé : ${result.device.name}');
            FlutterBluePlus.stopScan();

            bool connected = await _connectToDevice(result.device);
            _isScanning = false;
            notifyListeners();

            completer.complete(connected);
            return;
          }
        }
      }, onError: (error) {
        print('Erreur de scan : $error');
        _isScanning = false;
        notifyListeners();
        completer.complete(false);
      });

      await FlutterBluePlus.startScan(timeout: timeout);

      return await completer.future;
    } catch (e) {
      print('Erreur lors du scan : $e');
      _isScanning = false;
      notifyListeners();
      return false;
    }
  }

  void stopScan() {
    if (_isScanning) {
      FlutterBluePlus.stopScan();
      _isScanning = false;
      _isConnected = false;
      notifyListeners();
    }
  }

  Future<bool> _connectToDevice(BluetoothDevice device) async {
    try {
      print('Tentative de connexion à : ${device.name}');
      await device.connect(timeout: const Duration(seconds: 15));
      print('Connecté à l\'appareil : ${device.name}');

      _connectedDevice = device;
      List<BluetoothService> services = await device.discoverServices();
      print('Services découverts : ${services.length}');

      for (BluetoothService service in services) {
        if (service.uuid.toString() == SERVICE_UUID) {
          for (BluetoothCharacteristic characteristic in service.characteristics) {
            if (characteristic.uuid.toString() == CHARACTERISTIC_UUID) {
              _dataCharacteristic = characteristic;
              await characteristic.setNotifyValue(true);
              characteristic.value.listen((value) {
                _processIncomingData(value);
              });

              _isConnected = true;
              notifyListeners();

              print('Caractéristique de données trouvée et configurée');
              return true;
            }
          }
        }
      }

      return false;
    } catch (e) {
      print('Erreur de connexion : $e');
      _isConnected = false;
      notifyListeners();
      return false;
    }
  }

  void _processIncomingData(List<int> data) {
    try {
      if (data.isEmpty) {
        print(' Paquet de données vide reçu');
        return;
      }
      String jsonString = String.fromCharCodes(data);
      Map<String, dynamic> jsonData = json.decode(jsonString);
      //print(' Données reçues : $jsonData');
      _dataController.add(jsonData);
    } catch (e) {
      print('Erreur de traitement des données : $e');
      print('Données brutes : $data');
    }
  }

  Future<void> disconnectDevice() async {
    if (_connectedDevice != null) {
      print('Déconnexion de l\'appareil');
      await _connectedDevice?.disconnect();
      _connectedDevice = null;
      _dataCharacteristic = null;
    }
  }

  @override
  void dispose() {
    print(' Nettoyage des ressources Bluetooth');
    _dataController.close();
    disconnectDevice();
    super.dispose();
  }
}