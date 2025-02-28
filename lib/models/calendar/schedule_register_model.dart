class ScheduleRequestModel {
  final int scheduleClientId;
  final String scheduleDateTime;
  final int scheduleTypeCode;   // 일정 타입 (상담: 41, 계약: 42, 입주: 43
  final String scheduleRemark;

  ScheduleRequestModel({
    required this.scheduleClientId,
    required this.scheduleDateTime,
    required this.scheduleTypeCode,
    required this.scheduleRemark,
  });

  Map<String, dynamic> toJson() {
    return {
      "scheduleClientId": scheduleClientId,
      "scheduleDateTime": scheduleDateTime,
      "scheduleTypeCode": scheduleTypeCode,
      "scheduleRemark": scheduleRemark,
    };
  }
}