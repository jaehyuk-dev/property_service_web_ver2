import 'package:property_service_web_ver2/models/property/property_recap_model.dart';

import '../core/utils/api_utils.dart';
import '../models/common/search_condition.dart';

class PropertyService{
  final ApiUtils _api = ApiUtils();

  // 고객 목록 검색 API 호출
  Future<List<PropertyRecapModel>> searchPropertyRecapList(SearchCondition condition) async {
    try {
      final response = await _api.get("/property/recap-list", params: condition.toJson());

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['data'];
        return data.map((json) => PropertyRecapModel.fromJson(json)).toList();
      } else {
        throw Exception("❌ 고객 검색 실패 (Status Code: ${response.statusCode})");
      }
    } catch (e) {
      print("🚨 API 호출 중 오류 발생: $e");
      return [];
    }
  }
}