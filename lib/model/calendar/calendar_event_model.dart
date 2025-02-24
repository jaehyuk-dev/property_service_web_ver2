import 'dart:convert';

class CalendarEvent {
  final DateTime date;
  final List<String> types;

  CalendarEvent({required this.date, required this.types});

  // JSON 데이터를 Dart 객체로 변환하는 팩토리 메서드
  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    return CalendarEvent(
      date: DateTime.parse(json['date']),
      types: List<String>.from(json['types']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String().split('T')[0], // "YYYY-MM-DD" 형식으로 변환
      'types': types,
    };
  }
}

// API에서 가져온 리스트를 모델 리스트로 변환하는 함수
List<CalendarEvent> parseCalendarEvents(String responseBody) {
  final parsed = json.decode(responseBody)['events'] as List;
  return parsed.map((json) => CalendarEvent.fromJson(json)).toList();
}
