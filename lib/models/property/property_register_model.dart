import 'package:property_service_web_ver2/models/common/transaction_type_model.dart';

class PropertyRegisterModel{
  final int buildingId;

  final String ownerName;
  final String ownerPhoneNumber;
  final String ownerRelation;

  final String roomNumber;
  final String propertyType;
  final int propertyStatusCode;

  final String propertyFloor;
  final String roomBathCount;
  final String mainRoomDirection;

  final double exclusiveArea;
  final double supplyArea;

  final String approvalDate;

  final String moveInDate;
  final String moveOutDate;

  final String availableMoveInDate;

  final List<TransactionTypeModel> transactionTypeList;

  final int maintenancePrice;
  final List<int> maintenanceItemCodeList;

  final List<int> optionItemCodeList;

  final int heatingTypeCode;

  final String remark;

  final int propertyMainPhotoIndex;
  final List<String> photoList;


  PropertyRegisterModel({
    required this.buildingId,

    required this.ownerName,
    required this.ownerPhoneNumber,
    required this.ownerRelation,

    required this.roomNumber,
    required this.propertyType,
    required this.propertyStatusCode,

    required this.propertyFloor,
    required this.roomBathCount,
    required this.mainRoomDirection,

    required this.exclusiveArea,
    required this.supplyArea,

    required this.approvalDate,

    required this.moveInDate,
    required this.moveOutDate,

    required this.availableMoveInDate,

    required this.transactionTypeList,

    required this.maintenancePrice,
    required this.maintenanceItemCodeList,

    required this.optionItemCodeList,

    required this.heatingTypeCode,

    required this.remark,

    required this.propertyMainPhotoIndex,
    required this.photoList,

  });

  /// JSON 변환 함수
  Map<String, dynamic> toJson() {
    return {
      "buildingId": buildingId,
      "ownerName": ownerName,
      "ownerPhoneNumber": ownerPhoneNumber,
      "ownerRelation": ownerRelation,
      "roomNumber": roomNumber,
      "propertyType": propertyType,
      "propertyStatusCode": propertyStatusCode,
      "propertyFloor": propertyFloor,
      "roomBathCount": roomBathCount,
      "mainRoomDirection": mainRoomDirection,
      "exclusiveArea": exclusiveArea,
      "supplyArea": supplyArea,
      "approvalDate": approvalDate,
      "moveInDate": moveInDate,
      "moveOutDate": moveOutDate,
      "availableMoveInDate": availableMoveInDate,
      "transactionTypeList": transactionTypeList.map((e) => e.toJson()).toList(),
      "maintenancePrice": maintenancePrice,
      "maintenanceItemCodeList": maintenanceItemCodeList,
      "optionItemCodeList": optionItemCodeList,
      "heatingTypeCode": heatingTypeCode,
      "remark": remark,
      "propertyMainPhotoIndex": propertyMainPhotoIndex,
      "photoList": photoList,
    };
  }


}