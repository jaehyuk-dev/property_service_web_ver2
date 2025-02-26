class ScheduleModel {
  final int scheduleId;
  final String picUserName;
  final String clientName;
  final DateTime scheduleDate;
  final String scheduleType;
  final String scheduleRemark;
  final bool isCompleted;

  ScheduleModel({
    required this.scheduleId,
    required this.picUserName,
    required this.clientName,
    required this.scheduleDate,
    required this.scheduleType,
    required this.scheduleRemark,
    required this.isCompleted,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      scheduleId: json['scheduleId'],
      picUserName: json['picUserName'],
      clientName: json['clientName'],
      scheduleDate: DateTime.parse(json['scheduleDate']),
      scheduleType: json['scheduleType'],
      scheduleRemark: json['scheduleRemark'],
      isCompleted: json['completed'],
    );
  }
}
