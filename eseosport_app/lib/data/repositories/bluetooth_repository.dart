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

  Stream<Map<String, dynamic>> get dataStream => _dataController.stream;


  Future<void> startScan({Duration timeout = const Duration(seconds: 10)}) async {
    try {
      print(' Démarrage du scan Bluetooth...');
      if (await FlutterBluePlus.isAvailable == false) {
        print(' Bluetooth non supporté sur cet appareil');
        return;
      }
      await FlutterBluePlus.stopScan();
      FlutterBluePlus.scanResults.listen((results) {
        for (ScanResult result in results) {
          if (result.device.name == TARGET_DEVICE_NAME) {
            print(' Appareil ESP32 trouvé : ${result.device.name}');
            FlutterBluePlus.stopScan();
            _connectToDevice(result.device);
            break;
          }
        }
      }, onError: (error) {
        print(' Erreur de scan : $error');
      });
      await FlutterBluePlus.startScan(timeout: timeout);
    } catch (e) {
      print(' Erreur lors du scan : $e');
    }
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    try {
      print(' Tentative de connexion à : ${device.name}');
      await device.connect(timeout: const Duration(seconds: 15));
      print(' Connecté à l\'appareil : ${device.name}');
      _connectedDevice = device;
      List<BluetoothService> services = await device.discoverServices();
      print(' Services découverts : ${services.length}');
      for (BluetoothService service in services) {
        if (service.uuid.toString() == SERVICE_UUID) {
          for (BluetoothCharacteristic characteristic in service.characteristics) {
            if (characteristic.uuid.toString() == CHARACTERISTIC_UUID) {
              _dataCharacteristic = characteristic;
              await characteristic.setNotifyValue(true);
              characteristic.value.listen((value) {
                _processIncomingData(value);
              });
              print(' Caractéristique de données trouvée et configurée');
              break;
            }
          }
        }
      }
    } catch (e) {
      print('Erreur de connexion : $e');
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
    print('🧹 Nettoyage des ressources Bluetooth');
    _dataController.close();
    disconnectDevice();
    super.dispose();
  }
}