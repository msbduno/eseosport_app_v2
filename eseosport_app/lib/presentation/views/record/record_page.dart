import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:eseosport_app/data/models/user_model.dart';
import 'package:eseosport_app/data/repositories/auth_repository.dart';
import 'package:provider/provider.dart';
import '../../../data/models/activity_model.dart';
import '../../../data/repositories/bluetooth_repository.dart';
import '../../../core/theme/app_theme.dart';
import '../../viewmodels/live_data_viewmodel.dart';
import '../../widgets/circle_button.dart';
import '../../widgets/data_column.dart';
import '../../widgets/custom_bottom_nav_bar.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({super.key});

  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  bool _isScanning = false;
  final BluetoothRepository bluetoothRepository = BluetoothRepository();
  bool _isRecording = false;
  late Stopwatch _stopwatch;
  late Timer _timer;
  String _elapsedTime = '00:00:00';
  final Future<UserModel?> _userFuture = AuthRepository().getCachedUser();
  Activity? _currentActivity;
  double _cumulativeDistance = 0.0;
  late LiveDataViewModel _liveDataVM;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    _liveDataVM = Provider.of<LiveDataViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _liveDataVM.initialize();
    });
  }

  @override
  void dispose() {
    if (_isRecording) {
      _timer.cancel();
      _stopwatch.stop();
    }
    _liveDataVM.stopReceivingData();
    super.dispose();
  }

  int _generateActivityId() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  void _toggleRecording() {
    if (_isRecording) {
      _saveAndStopRecording();
    } else {
      startRecording();
    }
  }

  void startRecording() {
    final activityName = 'Activity ';
    setState(() {
      _isRecording = true;
      _currentActivity ??= Activity(
        idActivity: _generateActivityId(),
        date: DateTime.now(),
        duration: 0,
        distance: 0.0,
        elevation: 0.0,
        averageSpeed: 0.0,
        averageBPM: 0,
        name: activityName, // Assurez-vous que le nom est défini ici
        user: UserModel(nom: "nom", prenom: "prenom", email: "email", password: "password"),
      );
    });


    _stopwatch.start();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      double distanceIncrement = (_liveDataVM.currentSpeed / 3600) * 0.1;
      _cumulativeDistance += distanceIncrement;

      setState(() {
        _elapsedTime = _formatDuration(_stopwatch.elapsed);

        if (_currentActivity != null) {
          _currentActivity = Activity(
            idActivity: _currentActivity!.idActivity,
            date: _currentActivity!.date,
            duration: _stopwatch.elapsed.inSeconds,
            distance: _cumulativeDistance,
            elevation: _liveDataVM.currentAltitude ?? 0.0,
            averageSpeed: _liveDataVM.currentSpeed,
            averageBPM: _liveDataVM.currentBPM ?? 0,
            user: _currentActivity!.user,
            name: _currentActivity!.name,
          );
        }
      });
    });
    _liveDataVM.startReceivingData();
  }

  void _saveAndStopRecording() async {
    if (_currentActivity != null) {
      final finalActivity = Activity(
        idActivity: _currentActivity!.idActivity,
        date: _currentActivity!.date,
        duration: _stopwatch.elapsed.inSeconds,
        distance: _cumulativeDistance,
        elevation: _liveDataVM.currentAltitude ?? 0.0,
        averageSpeed: _liveDataVM.currentSpeed,
        averageBPM: _liveDataVM.currentBPM ?? 0,
        user: _currentActivity!.user!,
        name: _currentActivity!.name,

      );
      //await ActivityRepository.saveActivity(finalActivity);
    }

    setState(() {
      _isRecording = false;
    });

    _stopwatch.stop();
    _timer.cancel();
    _liveDataVM.stopReceivingData();
  }

  void _cancelActivity() {
    setState(() {
      _isRecording = false;
      _currentActivity = null;
      _elapsedTime = '00:00:00';
      _cumulativeDistance = 0.0;

      // Reset LiveDataViewModel to ensure all displayed values return to zero
      _liveDataVM = Provider.of<LiveDataViewModel>(context, listen: false);
      _liveDataVM.resetData(); // You'll need to add this method to the LiveDataViewModel
    });

    _stopwatch.stop();
    _stopwatch.reset();
    if (_isRecording) {
      _timer.cancel();
    }
    _liveDataVM.stopReceivingData();
  }

  void _saveActivityDetails() {
    if (_currentActivity != null) {
      Navigator.pushNamed(context, '/saveActivity', arguments: _currentActivity);
    } else {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('Error'),
          content: const Text('No activity to save'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  void performBluetoothScan() {
    setState(() {
      _isScanning = true;
    });

    // Scan for Bluetooth device with the methode of bluetooth repository
    bluetoothRepository.startScan().then((value) {
      setState(() {
        _isScanning = false;
      });
    });
  }


  void _showBluetoothDialog() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<BluetoothRepository>(
          builder: (context, bluetoothRepo, child) {
            return CupertinoAlertDialog(
              title: const Text('Bluetooth Connection'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (bluetoothRepo.isScanning)
                    Padding(
  padding: const EdgeInsets.symmetric(vertical: 20.0), // Adjust the value as needed
  child: const CupertinoActivityIndicator(),
)
                  else ...[
                    const SizedBox(height: 10),
                  Icon(
                      bluetoothRepo.isConnected
                          ? CupertinoIcons.bluetooth
                          : CupertinoIcons.nosign,
                      color: bluetoothRepo.isConnected
                          ? AppTheme.primaryColor
                          : CupertinoColors.systemGrey,
                      size: 50,
                    ),
                  ],
                  const SizedBox(height: 10),
                  Text(bluetoothRepo.isConnected
                      ? 'Connected successfully!'
                      : 'No device found'),
                ],
              ),
              actions: [
                CupertinoDialogAction(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                CupertinoDialogAction(
                  onPressed: () async {
                    bluetoothRepo.isScanning
                        ? bluetoothRepo.stopScan()
                        : await bluetoothRepo.startScan();
                  },
                  child: Text(bluetoothRepo.isScanning ? 'Stop Scan' : 'Scan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final liveDataVM = Provider.of<LiveDataViewModel>(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Record'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.bluetooth),
          onPressed: _showBluetoothDialog,
        ),
      ),
      child: SafeArea(
        child: FutureBuilder<UserModel?>(
          future: _userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CupertinoActivityIndicator());
            }

            if (snapshot.hasError || snapshot.data == null) {
              return Center(
                child: Text(snapshot.hasError
                    ? 'Error: ${snapshot.error}'
                    : 'No user data available'),
              );
            }

            final user = snapshot.data!;
            _currentActivity?.user ??= user;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Text(
                  'TIME',
                  style: TextStyle(
                    color: CupertinoColors.systemGrey,
                    fontSize: 16,
                  ),
                ),
                Text(
                  _elapsedTime,
                  style: const TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 60),
                    buildDataColumn(
                      'SPEED',
                      '${liveDataVM.currentSpeed.toStringAsFixed(1)}',
                      'KM/H',
                      fontSize: 24.0,
                    ),
                    const SizedBox(width: 50),
                    buildDataColumn(
                      'DISTANCE',
                      '${_cumulativeDistance.toStringAsFixed(1)}',
                      'KILOMETERS',
                      fontSize: 24.0,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 40),
                    buildDataColumn(
                      'ELEVATION',
                      '${liveDataVM.currentAltitude?.toStringAsFixed(0) ?? "0"}',
                      'METERS',
                      fontSize: 24.0,
                    ),
                    const SizedBox(width: 45),
                    buildDataColumn(
                      'BPM',
                      '${liveDataVM.currentBPM ?? "_ _"}',
                      '',
                      fontSize: 24.0,
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CupertinoCircleButton(
                      onPressed: _cancelActivity,
                      icon: CupertinoIcons.clear_circled,
                      color: CupertinoColors.systemGrey,
                    ),
                    CupertinoCircleButton(
                      onPressed: _toggleRecording,
                      icon: _isRecording
                          ? CupertinoIcons.stop_circle
                          : CupertinoIcons.play_circle,
                      color: AppTheme.primaryColor,
                      size: 70,
                    ),
                    CupertinoCircleButton(
                      onPressed: _saveActivityDetails,
                      icon: CupertinoIcons.arrow_right_circle,
                      color: AppTheme.primaryColor,
                    ),
                  ],
                ),
                const Spacer(),
                 // Add the custom bottom navigation bar
                CustomCupertinoNavBar(
                currentIndex: 1,
            onTap: (index) {
            switch (index) {
            case 0:
            Navigator.pushReplacementNamed(context, '/home');
            break;
            case 2:
            Navigator.pushReplacementNamed(context, '/activity');
            break;
            case 3:
            Navigator.pushReplacementNamed(context, '/profile');
            break;
            }
            },
            ),
              ],
            );
          },
        ),
      ),
    );
  }
}