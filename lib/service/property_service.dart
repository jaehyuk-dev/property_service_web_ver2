import 'dart:io';

import 'package:dio/dio.dart';
import 'package:property_service_web_ver2/models/common/file_upload_model.dart';
import 'package:property_service_web_ver2/models/property/building_register_model.dart';
import 'package:property_service_web_ver2/models/property/property_recap_model.dart';

import '../core/utils/api_utils.dart';
import '../models/common/image_file_model.dart';
import '../models/common/search_condition.dart';

class PropertyService{
  final ApiUtils _api = ApiUtils();

  // 건물 간략 목록 검색 API 호출
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

  // 🏗️ 건물 이미지 업로드 API (Flutter Web 최적화)
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
}