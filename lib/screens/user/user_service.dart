// services/user_service.dart
import 'package:property_service_web_ver2/core/utils/api_utils.dart';

import '../../models/user/user_info.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  final ApiUtils _apiUtils = ApiUtils();

  Future<UserInfo?> getCurrentUserInfo() async {
    try {
      final response = await _apiUtils.get('/user/me');

      if (response.statusCode == 200) {
        final data = response.data['data']; // SuccessResponseDto의 data 필드
        return UserInfo.fromJson(data);
      }
      return null;
    } catch (e) {
      print('사용자 정보 조회 실패: $e');
      return null;
    }
  }
}