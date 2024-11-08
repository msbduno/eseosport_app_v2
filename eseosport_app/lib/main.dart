import 'package:eseosport_app/presentation/viewmodels/activity_viewmodel.dart';
import 'package:eseosport_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:eseosport_app/presentation/views/activity/activities_page.dart';
import 'package:eseosport_app/presentation/views/activity/no_activity_page.dart';
import 'package:eseosport_app/presentation/views/auth/login_page.dart';
import 'package:eseosport_app/presentation/views/auth/signIn_page.dart';
import 'package:eseosport_app/presentation/views/profile/profile_page.dart';
import 'package:eseosport_app/presentation/views/record/record_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/repositories/activity_repository.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/bluetooth_repository.dart';
import 'presentation/viewmodels/live_data_viewmodel.dart';
import 'presentation/views/splash_screen.dart';
import 'presentation/views/home_page.dart';
import 'presentation/views/record/save_activity_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LiveDataViewModel(BluetoothRepository()),
        ),
        ChangeNotifierProvider(
          create: (context) => ActivityViewModel(ActivityRepository()),
        ),
        ChangeNotifierProvider(
          create: (context) => MockActivityViewModel(),
        ),
        ChangeNotifierProvider(
            create: (context) => AuthViewModel(AuthRepository())),
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
          '/saveActivity': (context) => const SaveActivityPage(),
          '/activities': (context) => const ActivitiesPage(),
          '/login': (context) => LoginPage(),
          '/signin': (context) => SignInPage(),
          '/profile': (context) => ProfilePage(),
        },
      ),
    );
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}