// services/auth_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:property_service_web_ver2/core/utils/api_utils.dart';

import '../models/auth/login_request.dart';
import '../models/auth/login_response.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final ApiUtils _apiUtils = ApiUtils();
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  // 로그인
  Future<LoginResponse?> login(LoginRequest loginRequest) async {
    try {
      final response = await _apiUtils.post(
        '/auth/login',
        data: loginRequest.toJson(),
      );

      if (response.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(response.data);

        // 토큰을 안전한 저장소에 저장
        await _storage.write(key: 'access_token', value: loginResponse.accessToken);
        await _storage.write(key: 'user_email', value: loginResponse.email);
        await _storage.write(key: 'user_name', value: loginResponse.name);
        await _storage.write(key: 'user_role', value: loginResponse.role);

        // API 클라이언트에 토큰 설정
        _apiUtils.setToken('${loginResponse.tokenType} ${loginResponse.accessToken}');

        return loginResponse;
      }
      return null;
    } catch (e) {
      print('로그인 실패: $e');
      return null;
    }
  }

  // 자동 로그인 체크 (토큰 유효성 검증 포함)
  Future<bool> checkAutoLogin() async {
    try {
      final token = await _storage.read(key: 'access_token');
      final autoLoginEnabled = await _storage.read(key: 'auto_login');

      if (token != null && token.isNotEmpty && autoLoginEnabled == 'true') {
        // 토큰을 API 클라이언트에 설정
        _apiUtils.setToken('Bearer $token');

        // 토큰 유효성 검증을 위해 사용자 정보 API 호출
        try {
          final response = await _apiUtils.get('/user/me');
          if (response.statusCode == 200) {
            return true; // 토큰이 유효함
          }
        } catch (e) {
          // 토큰이 만료되었거나 유효하지 않음
          await logout(); // 저장된 정보 삭제
          return false;
        }
      }
      return false;
    } catch (e) {
      print('자동 로그인 체크 실패: $e');
      return false;
    }
  }

  // 단순 토큰 존재 여부만 체크 (자동 로그인 설정과 관계없이)
  Future<bool> hasValidToken() async {
    try {
      final token = await _storage.read(key: 'access_token');
      if (token != null && token.isNotEmpty) {
        _apiUtils.setToken('Bearer $token');
        return true;
      }
      return false;
    } catch (e) {
      print('토큰 체크 실패: $e');
      return false;
    }
  }

  // 자동 로그인 설정 저장
  Future<void> setAutoLogin(bool enabled) async {
    try {
      if (enabled) {
        await _storage.write(key: 'auto_login', value: 'true');
      } else {
        await _storage.delete(key: 'auto_login');
      }
    } catch (e) {
      print('자동 로그인 설정 저장 실패: $e');
    }
  }

  // 자동 로그인 설정 여부 확인
  Future<bool> isAutoLoginEnabled() async {
    try {
      final autoLoginEnabled = await _storage.read(key: 'auto_login');
      return autoLoginEnabled == 'true';
    } catch (e) {
      print('자동 로그인 설정 확인 실패: $e');
      return false;
    }
  }

  // 저장된 이메일 가져오기
  Future<String?> getSavedEmail() async {
    try {
      return await _storage.read(key: 'saved_email');
    } catch (e) {
      print('저장된 이메일 가져오기 실패: $e');
      return null;
    }
  }

  // 완전 로그아웃 (모든 데이터 삭제)
  Future<void> logout() async {
    try {
      await _storage.deleteAll();
      // API 클라이언트에서 토큰 제거
      _apiUtils.dio.options.headers.remove('Authorization');
    } catch (e) {
      print('로그아웃 실패: $e');
    }
  }

  // 부분 로그아웃 (이메일만 저장하고 나머지 삭제)
  Future<void> partialLogout() async {
    try {
      // 현재 이메일 저장
      final currentEmail = await _storage.read(key: 'user_email');

      // 모든 데이터 삭제
      await _storage.deleteAll();

      // 이메일만 다시 저장
      if (currentEmail != null && currentEmail.isNotEmpty) {
        await _storage.write(key: 'saved_email', value: currentEmail);
      }

      // API 클라이언트에서 토큰 제거
      _apiUtils.dio.options.headers.remove('Authorization');
    } catch (e) {
      print('부분 로그아웃 실패: $e');
    }
  }

  // 저장된 사용자 정보 가져오기
  Future<Map<String, String?>> getUserInfo() async {
    return {
      'email': await _storage.read(key: 'user_email'),
      'name': await _storage.read(key: 'user_name'),
      'role': await _storage.read(key: 'user_role'),
    };
  }
}