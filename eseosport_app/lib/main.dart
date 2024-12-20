import 'dart:io';
import 'package:eseosport_app/presentation/viewmodels/activity_viewmodel.dart';
import 'package:eseosport_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:eseosport_app/presentation/views/activity/activities_page.dart';
import 'package:eseosport_app/presentation/views/activity/no_activity_page.dart';
import 'package:eseosport_app/presentation/views/auth/login_page.dart';
import 'package:eseosport_app/presentation/views/auth/signIn_page.dart';
import 'package:eseosport_app/presentation/views/profile/profile_details_page.dart';
import 'package:eseosport_app/presentation/views/profile/profile_page.dart';
import 'package:eseosport_app/presentation/views/record/record_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'data/models/activity_model.dart';
import 'data/repositories/activity_repository.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/bluetooth_repository.dart';
import 'presentation/viewmodels/live_data_viewmodel.dart';
import 'presentation/views/splash_screen.dart';
import 'presentation/views/home_page.dart';
import 'presentation/views/record/save_activity_page.dart';


class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Activity? _currentActivity;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(AuthRepository()),
        ),
        Provider<AuthRepository>(
          create: (_) => AuthRepository(),
        ),
        Provider<ActivityRepository>(
          create: (_) => ActivityRepository(),
        ),
        ChangeNotifierProvider<ActivityViewModel>(
          create: (context) => ActivityViewModel(
            context.read<ActivityRepository>(),
            context.read<AuthRepository>(),
          ),

        ),

        ChangeNotifierProvider(
          create: (_) => LiveDataViewModel(BluetoothRepository()),
        ),
      ],
      child: MaterialApp(
        title: 'ESEOSPORT',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/home': (context) => HomePage(),
          '/record': (context) => const RecordPage(),
          '/activity': (context) => NoActivityPage(),
      '/saveActivity': (context) {
      final activity = ModalRoute.of(context)!.settings.arguments as Activity;
      return SaveActivityPage(activity: activity);
      },
          '/activities': (context) => const ActivitiesPage(),
          '/login': (context) => LoginPage(),
          '/signin': (context) => SignInPage(),
          '/profile': (context) => ProfilePage(),
          '/profile2': (context) => const Profile2Page(),
        },
      ),
    );
  }
}



Future<void> main() async {
  // Set the log level to none to disable logging
  FlutterBluePlus.setLogLevel(LogLevel.none);
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}