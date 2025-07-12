// core/config/app_config.dart
import 'package:flutter/foundation.dart';

class AppConfig {
  static bool get isDevelopment => kDebugMode;
  static bool get isProduction => !kDebugMode;

  // API Base URL
  static String get apiBaseUrl {
    return isDevelopment
        ? 'https://api.reatypartners.store/api'
        : 'http://localhost:8080/api';

  }

  // 이미지/파일 Base URL
  static String get fileBaseUrl {
    return isDevelopment
        ? 'https://api.reatypartners.store/'
        : 'http://localhost:8080/';
  }
}