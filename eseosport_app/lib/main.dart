import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'data/models/activity_model.dart';
import 'data/repositories/activity_repository.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/bluetooth_repository.dart';
import 'presentation/viewmodels/activity_viewmodel.dart';
import 'presentation/viewmodels/auth_viewmodel.dart';
import 'presentation/viewmodels/live_data_viewmodel.dart';
import 'presentation/views/splash_screen.dart';
import 'presentation/views/home_page.dart';
import 'presentation/views/record/save_activity_page.dart';
import 'presentation/views/activity/activities_page.dart';
import 'presentation/views/auth/login_page.dart';
import 'presentation/views/auth/signIn_page.dart';
import 'presentation/views/profile/profile_details_page.dart';
import 'presentation/views/profile/profile_page.dart';
import 'presentation/views/record/record_page.dart';


class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
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
        ChangeNotifierProvider<AuthViewModel>(
          create: (context) => AuthViewModel(
            context.read<AuthRepository>(),
            context.read<ActivityViewModel>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => BluetoothRepository(),
        ),
        ChangeNotifierProvider(
          create: (context) => LiveDataViewModel(
            context.read<BluetoothRepository>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => LiveDataViewModel(BluetoothRepository()),
        ),
      ],
      child: CupertinoApp(
        title: 'ESEOSPORT',
        theme: AppTheme.cupertinoTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/home': (context) => HomePage(),
          '/record': (context) => const RecordPage(),
          '/saveActivity': (context) {
            final activity = ModalRoute.of(context)!.settings.arguments as Activity;
            return SaveActivityPage(activity: activity);
          },
          '/activity': (context) => const ActivitiesPage(),
          '/login': (context) => LoginPage(),
          '/signin': (context) => SignInPage(),
          '/profile': (context) => ProfilePage(),
          '/profile2': (context) => Profile2Page(),
        },
      ),
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}