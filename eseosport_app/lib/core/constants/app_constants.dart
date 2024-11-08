class AppConstants {
  // App info
  static const String appName = 'ESEOSPORT';
  static const String appVersion = '1.0.0';

  // API endpoints
  static const String baseUrl = 'https://api.eseosport.com';
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';

  // Storage keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration bluetoothScanDuration = Duration(seconds: 10);
}
