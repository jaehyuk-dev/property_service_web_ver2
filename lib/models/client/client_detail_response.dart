import 'package:property_service_web_ver2/models/client/showing_property_model.dart';
import 'package:property_service_web_ver2/models/common/schedule_model.dart';
import 'package:property_service_web_ver2/models/common/remark_model.dart';

class ClientDetailResponse {
  final int clientId;
  final String clientPicUser;
  final String clientStatus;
  final String clientName;
  final String clientPhoneNumber;
  final String clientGender;
  final String clientSource;
  final String clientType;
  final DateTime? clientExpectedMoveInDate;
  final List<String> clientExpectedTransactionTypeList;
  final List<ScheduleModel> scheduleList;
  final List<ShowingPropertyModel> showingPropertyList;
  final List<RemarkModel> clientRemarkList;

  ClientDetailResponse({
    required this.clientId,
    required this.clientPicUser,
    required this.clientStatus,
    required this.clientName,
    required this.clientPhoneNumber,
    required this.clientGender,
    required this.clientSource,
    required this.clientType,
    this.clientExpectedMoveInDate,
    required this.clientExpectedTransactionTypeList,
    required this.scheduleList,
    required this.showingPropertyList,
    required this.clientRemarkList,
  });

  factory ClientDetailResponse.fromJson(Map<String, dynamic> json) {
    return ClientDetailResponse(
      clientId: json['clientId'],
      clientPicUser: json['clientPicUser'],
      clientStatus: json['clientStatus'],
      clientName: json['clientName'],
      clientPhoneNumber: json['clientPhoneNumber'],
      clientGender: json['clientGender'],
      clientSource: json['clientSource'],
      clientType: json['clientType'],
      clientExpectedMoveInDate: json['clientExpectedMoveInDate'] != null
          ? DateTime.parse(json['clientExpectedMoveInDate'])
          : null,
      clientExpectedTransactionTypeList: List<String>.from(json['clientExpectedTransactionTypeList'] ?? []),
      scheduleList: (json['scheduleList'] as List?)
          ?.map((e) => ScheduleModel.fromJson(e))
          .toList() ??
          [],
      showingPropertyList: (json['showingPropertyList'] as List?)
          ?.map((e) => ShowingPropertyModel.fromJson(e))
          .toList() ??
          [],
      clientRemarkList: (json['clientRemarkList'] as List?)
          ?.map((e) => RemarkModel.fromJson(e))
          .toList() ??
          [],
    );
  }
}
