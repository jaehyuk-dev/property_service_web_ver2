import 'package:property_service_web_ver2/models/common/search_condition.dart';

import '../core/utils/api_utils.dart';
import '../models/client/client_detail_response.dart';
import '../models/client/client_request_model.dart';
import '../models/client/client_summary_model.dart';

class ClientService {
  final ApiUtils _api = ApiUtils();

  // 고객 등록 API 호출
  Future<void> registerClient(ClientRequestModel client) async {
    try {
      final response = await _api.post(
        "/client/",
        data: client.toJson(),
      );

      if (response.statusCode == 200) {
        print("✅ 고객 등록 성공!");
      } else {
        throw Exception("❌ 고객 등록 실패 (Status Code: ${response.statusCode})");
      }
    } catch (e) {
      print("🚨 API 호출 중 오류 발생: $e");
    }
  }

  // 고객 목록 검색 API 호출
  Future<List<ClientSummaryModel>> searchClientSummaryInfoList(SearchCondition condition) async {
    try {
      final response = await _api.get("/client/list", params: condition.toJson());

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['data'];
        return data.map((json) => ClientSummaryModel.fromJson(json)).toList();
      } else {
        throw Exception("❌ 고객 검색 실패 (Status Code: ${response.statusCode})");
      }
    } catch (e) {
      print("🚨 API 호출 중 오류 발생: $e");
      return [];
    }
  }

  // 고객 상세 정보 조회 API
  Future<ClientDetailResponse?> searchClientDetail(int clientId) async {
    try {
      final response = await _api.get("/client/$clientId");

      if (response.statusCode == 200) {
        return ClientDetailResponse.fromJson(response.data['data']);
      } else {
        throw Exception("❌ 고객 상세 정보 조회 실패 (Status Code: ${response.statusCode})");
      }
    } catch (e) {
      print("🚨 API 호출 중 오류 발생: $e");
      return null;
    }
  }

  // 고객 특이사항 삭제 api
  Future<void> deleteClientRemark(int clientRemarkId) async {
    try {
      final response = await _api.delete("/client/remark/$clientRemarkId");

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception("❌ 고객 특이사항 삭제 실패 (Status Code: ${response.statusCode})");
      }
    } catch (e) {
      print("🚨 API 호출 중 오류 발생: $e");
      return;
    }
  }

  // 고객 보여줄 매물 삭제 api
  Future<void> removeShowingProperty(int showingPropertyId) async {
    try {
      final response = await _api.delete("/client/showing-property/$showingPropertyId");

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception("❌ 고객 보여줄 매물 삭제 실패 (Status Code: ${response.statusCode})");
      }
    } catch (e) {
      print("🚨 API 호출 중 오류 발생: $e");
      return;
    }
  }
}
