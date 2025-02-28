import 'dart:io';

import 'package:dio/dio.dart';
import 'package:property_service_web_ver2/models/common/file_upload_model.dart';
import 'package:property_service_web_ver2/models/property/building_detail_model.dart';
import 'package:property_service_web_ver2/models/property/building_register_model.dart';
import 'package:property_service_web_ver2/models/property/building_summary_model.dart';
import 'package:property_service_web_ver2/models/property/property_recap_model.dart';
import 'package:property_service_web_ver2/models/property/property_register_model.dart';

import '../core/utils/api_utils.dart';
import '../models/common/image_file_model.dart';
import '../models/common/search_condition.dart';

class PropertyService{
  final ApiUtils _api = ApiUtils();

  // 매물 간략 목록 검색 API 호출
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

  // 건물 이미지 업로드 API (Flutter Web 최적화)
  Future<FileUploadModel> uploadBuildingImages(List<ImageFileModel> images) async {
    try {
      FormData formData = FormData.fromMap({
        "buildingImageList": images.map((image) {
          return MultipartFile.fromBytes(
            image.imageBytes, // 📌 Web에서는 Uint8List를 직접 업로드
            filename: image.imageName,
          );
        }).toList(),
      });

      final response = await _api.post("/file/images/building", data: formData);

      if (response.statusCode == 200) {
        return FileUploadModel.fromJson(response.data['data']);
      } else {
        throw Exception("❌ 이미지 업로드 실패 (Status Code: ${response.statusCode})");
      }
    } catch (e) {
      print("🚨 이미지 업로드 중 오류 발생: $e");
      rethrow;
    }
  }

  // 건물 등록 API 호출
  Future<void> registerBuilding(BuildingRegisterModel request) async {
    try {
      final response = await _api.post(
        "/property/building",
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        print("✅ 건물 등록 성공!");
      } else {
        throw Exception("❌ 고객 등록 실패 (Status Code: ${response.statusCode})");
      }
    } catch (e) {
      print("🚨 API 호출 중 오류 발생: $e");
    }
  }

  // 건물 요약 목록 검색 API 호출
  Future<List<BuildingSummaryModel>> searchBuildingSummaryList(String searchWord) async {
    try {
      final response = await _api.get("/property/building/list", params: {"searchWord": searchWord});

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['data'];
        return data.map((json) => BuildingSummaryModel.fromJson(json)).toList();
      } else {
        throw Exception("❌ 고객 검색 실패 (Status Code: ${response.statusCode})");
      }
    } catch (e) {
      print("🚨 API 호출 중 오류 발생: $e");
      return [];
    }
  }

  // 고객 상세 정보 조회 API
  Future<BuildingDetailModel?> searchBuildingDetail(int buildingId) async {
    try {
      final response = await _api.get("/property/building/$buildingId");

      if (response.statusCode == 200) {
        return BuildingDetailModel.fromJson(response.data['data']);
      } else {
        throw Exception("❌ 고객 상세 정보 조회 실패 (Status Code: ${response.statusCode})");
      }
    } catch (e) {
      print("🚨 API 호출 중 오류 발생: $e");
      return null;
    }
  }

  // 특이사항 추가
  Future<void> registerBuildingRemark(int buildingId, String buildingRemark) async {
    try {
      final response = await _api.post("/property/building/remark", data: {"buildingId": buildingId, "buildingRemark": buildingRemark});
      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception("❌ 특이사항 등록 실패 (Status Code: ${response.statusCode})");
      }
    } catch (e) {
      print("🚨 API 호출 중 오류 발생: $e");
      return;
    }
  }

  // 고객 특이사항 삭제 api
  Future<void> deleteBuildingRemark(int buildingId) async {
    try {
      final response = await _api.delete("/property/building/remark/$buildingId");

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

  // 매물 등록 API 호출
  Future<void> registerProperty(PropertyRegisterModel request) async {
    try {
      final response = await _api.post(
        "/property/",
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        print("✅ 매물 등록 성공!");
      } else {
        throw Exception("❌ 고객 등록 실패 (Status Code: ${response.statusCode})");
      }
    } catch (e) {
      print("🚨 API 호출 중 오류 발생: $e");
    }
  }

  // 건물 이미지 업로드 API (Flutter Web 최적화)
  Future<FileUploadModel> uploadPropertyImages(List<ImageFileModel> images) async {
    try {
      FormData formData = FormData.fromMap({
        "propertyImageList": images.map((image) {
          return MultipartFile.fromBytes(
            image.imageBytes, // 📌 Web에서는 Uint8List를 직접 업로드
            filename: image.imageName,
          );
        }).toList(),
      });

      final response = await _api.post("/file/images/property", data: formData);

      if (response.statusCode == 200) {
        return FileUploadModel.fromJson(response.data['data']);
      } else {
        throw Exception("❌ 이미지 업로드 실패 (Status Code: ${response.statusCode})");
      }
    } catch (e) {
      print("🚨 이미지 업로드 중 오류 발생: $e");
      rethrow;
    }
  }

}