// core/config/app_config.dart
import 'package:flutter/foundation.dart';

class AppConfig {
  static bool get isDevelopment => kDebugMode;
  static bool get isProduction => !kDebugMode;

  // API Base URL
  static String get apiBaseUrl {
    return isDevelopment
        ? 'http://localhost:8080/api'
        : 'https://api.xn--h50bw7n3vhqjd47vujaqg.site/api';
  }

  // 이미지/파일 Base URL
  static String get fileBaseUrl {
    return isDevelopment
        ? 'http://localhost:8080/static'
        : 'https://api.xn--h50bw7n3vhqjd47vujaqg.site';
  }
}