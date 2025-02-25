import 'package:dio/dio.dart';
import 'package:property_service_web_ver2/model/calendar/schedule_model.dart';

import '../core/utils/api_utils.dart';
import '../model/calendar/calendar_event_model.dart';


class CalendarService {
  final ApiUtils _api = ApiUtils();

  // 월별 일정 데이터 가져오기
  Future<List<CalendarEvent>> fetchEvents(String yearMonth) async {
    try {
      final response = await _api.get("/schedule/event", params: {"yearMonth": yearMonth});

      if (response.statusCode == 200) {
        final responseData = response.data; // 전체 응답
        if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
          List<dynamic> data = responseData['data']; // data 키에서 리스트만 가져옴
          return CalendarEvent.fromJsonList(data);
        } else {
          throw Exception("Invalid response format");
        }
      } else {
        throw Exception("Failed to load schedules");
      }
    } catch (e) {
      throw Exception("Error fetching calendar events: $e");
    }
  }

  // 선택 일 일정 가져오기
  Future<List<Schedule>> searchSelectedDateSchedule(String date) async {
    try {
      final response = await _api.get("/schedule/", params: {"selectedDate": date});

      if (response.statusCode == 200) {
        final responseData = response.data; // 전체 응답
        if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
          List<dynamic> data = responseData['data']; // data 키에서 리스트만 가져옴
          return Schedule.fromJsonList(data);
        } else {
          throw Exception("Invalid response format");
        }
      } else {
        throw Exception("Failed to load schedules");
      }
    } catch (e) {
      throw Exception("Error fetching calendar events: $e");
    }
  }

  // 일정 상태 변경 API 호출
  Future<void> updateScheduleCompleted({required int scheduleId, required bool complete}) async {
    try {
      final response = await _api.put(
        "/schedule/",
        data: {
          "scheduleId": scheduleId,
          "complete": complete,
        },
      );

      if (response.statusCode == 200) {
        print("✅ 일정 상태 변경 성공!");
      } else {
        throw Exception("❌ 일정 상태 변경 실패 (Status Code: ${response.statusCode})");
      }
    } catch (e) {
      print("🚨 API 호출 중 오류 발생: $e");
    }
  }
}
