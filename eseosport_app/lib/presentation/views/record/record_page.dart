import 'package:flutter/material.dart';
import 'dart:async';
import 'package:eseosport_app/data/models/user_model.dart';
import 'package:eseosport_app/data/repositories/auth_repository.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import '../../../data/models/activity_model.dart';
import '../../../data/repositories/bluetooth_repository.dart';
import '../../widgets/circle_button.dart';
import '../../widgets/data_column.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import '../../../core/theme/app_theme.dart';
import '../../viewmodels/live_data_viewmodel.dart';

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
      );
      // Sauvegarder l'activité
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No activity to save')),
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

  void _testBluetoothConnection() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Bluetooth Connection',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  IconButton(
                      icon: const Icon(Icons.close),
                      color: Colors.red,
                      onPressed: () {
                        Navigator.of(context).pop();
                        FlutterBluePlus.stopScan();
                      }
                  ),
                ],
              ),
              content: Consumer<BluetoothRepository>(
                builder: (context, bluetoothRepo, child) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (bluetoothRepo.isScanning)
                        const Column(
                          children: [
                            CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor)
                            ),
                            SizedBox(height: 10),
                            Text('Scanning for Bluetooth device...'),
                          ],
                        )
                      else
                        Column(
                          children: [
                            Icon(
                              bluetoothRepo.isConnected
                                  ? Icons.bluetooth_connected
                                  : Icons.bluetooth_disabled,
                              color: bluetoothRepo.isConnected
                                  ? AppTheme.primaryColor
                                  : Colors.grey,
                              size: 50,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              bluetoothRepo.isConnected
                                  ? 'Bluetooth device connected successfully!'
                                  : 'No Bluetooth device found. Please check your device.',
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                    ],
                  );
                },
              ),
              actions: [
                Consumer<BluetoothRepository>(
                  builder: (context, bluetoothRepo, child) {
                    return bluetoothRepo.isScanning
                        ? TextButton(
                      onPressed: () {
                        FlutterBluePlus.stopScan();
                        bluetoothRepo.stopScan();
                      },
                      child: const Text(
                        'Stop Scan',
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                        : TextButton(
                      onPressed: () async {
                        await bluetoothRepo.startScan();
                      },
                      child: const Text(
                        'Scan Again',
                        style: TextStyle(color: AppTheme.primaryColor),
                      ),
                    );
                  },
                )
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

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<UserModel?>(
          future: _userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.data == null) {
              return const Center(child: Text('No user data available'));
            } else {
              final user = snapshot.data!;
              _currentActivity?.user ??= user;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.settings_bluetooth, color: AppTheme.primaryColor),
                        onPressed: _testBluetoothConnection,
                      ),
                    ],
                  ),
                  const Text(
                    'TIME',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0), // Reduced padding
                            child: buildDataColumn(
                              'SPEED',
                              '${liveDataVM.currentSpeed.toStringAsFixed(1)}',
                              'KM/H',
                              fontSize: 24.0,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0), // Reduced padding
                            child: buildDataColumn(
                              'DISTANCE',
                              '${_cumulativeDistance.toStringAsFixed(1)}',
                              'KILOMETERS',
                              fontSize: 24.0,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2), // Further reduced space between sections
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center, // Center the Row
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0), // Reduced padding
                            child: buildDataColumn(
                              'ELEVATION',
                              '${liveDataVM.currentAltitude?.toStringAsFixed(0) ?? "0"}',
                              'METERS',
                              fontSize: 24.0,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0), // Reduced padding
                            child: buildDataColumn(
                              'BPM',
                              '${liveDataVM.currentBPM ?? "_ _"}',
                              '',
                              fontSize: 24.0,
                            ),
                          ),
                          const SizedBox(width: 30),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleButton(
                        onPressed: _cancelActivity,
                        icon: Icons.close,
                        color: Colors.grey,
                      ),
                      CircleButton(
                        onPressed: _toggleRecording,
                        icon: _isRecording ? Icons.stop : Icons.play_arrow,
                        color: AppTheme.primaryColor,
                        size: 70,
                      ),
                      CircleButton(
                        onPressed: _saveActivityDetails,
                        icon: Icons.arrow_forward_ios_outlined,
                        color: AppTheme.primaryColor,
                      ),
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/activity');
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/profile');
          }
        },
      ),
    );
  }
}