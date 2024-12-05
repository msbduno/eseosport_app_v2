import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothServiceManager {
  BluetoothDevice? _connectedDevice;

  Future<void> connectToDevice(BluetoothDevice device) async {
    _connectedDevice = device;
    await _connectedDevice?.connect();
  }

  Future<void> disconnectDevice() async {
    await _connectedDevice?.disconnect();
  }

  Stream<List<int>> listenToDeviceData(Guid characteristicUUID) async* {
    if (_connectedDevice != null) {
      List<BluetoothService> services = await _connectedDevice!.discoverServices();

      for (var service in services) {
        for (BluetoothCharacteristic characteristic in service.characteristics) {
          if (characteristic.uuid == characteristicUUID) {
            await characteristic.setNotifyValue(true);
            yield* characteristic.value;
          }
        }
      }
    }
  }

  void stopScanIfActive() {
    if (FlutterBluePlus.isScanningNow) {
      FlutterBluePlus.stopScan();
    } else {
      print('Scan is already stopped');
    }
  }
}