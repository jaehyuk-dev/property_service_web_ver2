import 'package:flutter/foundation.dart';

class AppConfig {
  static bool get isDevelopment => kDebugMode;
  static bool get isProduction => !kDebugMode;

  // // API Base URL
  // static String get apiBaseUrl {
  //   return isDevelopment
  //       ? 'http://localhost:8080/api'
  //       : 'https://api.xn--h50bw7n3vhqjd47vujaqg.site/api';
  // }
  //
  // // 이미지/파일 Base URL
  // static String get fileBaseUrl {
  //   return isDevelopment
  //       ? 'http://localhost:8080'  // ✅ /static 제거 - 백엔드에서 직접 /building/, /property/ 경로 제공
  //       : 'https://api.xn--h50bw7n3vhqjd47vujaqg.site';
  // }

  // API Base URL
  static String get apiBaseUrl {
    return isDevelopment
        ? 'http://localhost:8080/api'
        : 'https://api.reatypartners.store/api';
  }

  // 이미지/파일 Base URL
  static String get fileBaseUrl {
    return isDevelopment
        ? 'http://localhost:8080/'
        : 'https://api.reatypartners.store/';
  }
}