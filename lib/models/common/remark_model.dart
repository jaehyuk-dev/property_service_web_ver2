class RemarkModel {
  final int remarkId;
  final String remark;
  final String createdBy;
  final DateTime createdAt;

  RemarkModel({
    required this.remarkId,
    required this.remark,
    required this.createdBy,
    required this.createdAt,
  });

  factory RemarkModel.fromJson(Map<String, dynamic> json) {
    return RemarkModel(
      remarkId: json['remarkId'],
      remark: json['remark'],
      createdBy: json['createdBy'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
