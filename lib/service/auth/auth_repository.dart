import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:property_service_web_ver2/core/utils/api_utils.dart';

class AuthRepository {
  static final Dio _dio = ApiUtils().dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // 🔐 로그인 요청
  Future<bool> signIn(String email, String password) async {
    try {
      // final response = await _dio.post(
      //   '/auth/login',
      //   options: Options(headers: {'Content-Type': 'application/json'}),
      //   data: jsonEncode({'email': email, 'password': password}),
      // );
      //
      // if (response.statusCode == 200) {
      //   final token = response.headers['authorization']?.first;
      //   if (token != null) {
      //     await _storage.write(key: 'jwt', value: token); // 토큰 저장
      //     return true;
      //   }
      // }
      return true;
    } catch (e) {
      print('❌ 로그인 요청 중 오류 발생: $e');
      return false;
    }
  }

  // 🔑 자동 로그인 체크
  Future<bool> checkAutoLogin() async {
    String? token = await _storage.read(key: 'jwt');
    return token != null;
  }

  // 🚪 로그아웃
  Future<void> signOut() async {
    await _storage.delete(key: 'jwt');
  }
}