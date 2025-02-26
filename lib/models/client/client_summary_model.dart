class ClientSummaryModel {
  final int clientId;
  final String clientName;
  final String clientStatus;
  final String clientPhoneNumber;
  final String picUser;
  final String clientSource;
  final DateTime? clientExpectedMoveInDate;

  ClientSummaryModel({
    required this.clientId,
    required this.clientName,
    required this.clientStatus,
    required this.clientPhoneNumber,
    required this.picUser,
    required this.clientSource,
    this.clientExpectedMoveInDate,
  });

  factory ClientSummaryModel.fromJson(Map<String, dynamic> json) {
    return ClientSummaryModel(
      clientId: json['clientId'],
      clientName: json['clientName'],
      clientStatus: json['clientStatus'],
      clientPhoneNumber: json['clientPhoneNumber'],
      picUser: json['picUser'],
      clientSource: json['clientSource'],
      clientExpectedMoveInDate: json['clientExpectedMoveInDate'] != null
          ? DateTime.parse(json['clientExpectedMoveInDate'])
          : null,
    );
  }
}
