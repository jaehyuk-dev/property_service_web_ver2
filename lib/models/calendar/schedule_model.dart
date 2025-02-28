import 'dart:convert';

class Schedule {
  final int scheduleId;
  final String picUserName;
  final String clientName;
  final DateTime scheduleDate;
  final String scheduleType;
  final String scheduleRemark;
  final bool isCompleted;

  Schedule({
    required this.scheduleId,
    required this.picUserName,
    required this.clientName,
    required this.scheduleDate,
    required this.scheduleType,
    required this.scheduleRemark,
    required this.isCompleted,
  });

  // JSON → Dart 객체 변환
  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      scheduleId: json['scheduleId'],
      picUserName: json['picUserName'],
      clientName: json['clientName'],
      scheduleDate: DateTime.parse(json['scheduleDate']), // 날짜 변환
      scheduleType: json['scheduleType'],
      scheduleRemark: json['scheduleRemark'],
      isCompleted: json['completed'],
    );
  }

  // Dart 객체 → JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'scheduleId': scheduleId,
      'picUserName': picUserName,
      'clientName': clientName,
      'scheduleDate': scheduleDate.toIso8601String(),
      'scheduleType': scheduleType,
      'scheduleRemark': scheduleRemark,
      'completed': isCompleted,
    };
  }

  // JSON 리스트 → Dart 객체 리스트 변환
  static List<Schedule> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Schedule.fromJson(json)).toList();
  }
}
