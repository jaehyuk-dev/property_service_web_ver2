import 'package:property_service_web_ver2/models/common/remark_model.dart';
import 'package:property_service_web_ver2/models/property/property_transaction_type_dto.dart';

import '../common/image_model.dart';

class PropertyDetailModel {
  final int propertyId;
  final int buildingId;

  final String picUser;
  final String propertyStatus;

  final String ownerName;
  final String ownerPhoneNumber;
  final String ownerRelation;

  final String roomNumber;
  final String propertyType;
  final String propertyFloor;
  final String roomBathCount;
  final String mainRoomDirection;

  final double exclusiveArea;
  final double supplyArea;

  final String approvalDate;
  final String moveInDate;
  final String moveOutDate;
  final String availableMoveInDate;

  final String heatingType;

  final int maintenancePrice;
  final List<String> maintenaceItemList;

  final List<String> optionItemList;

  final List<PropertyTransactionTypeDto> propertyTransactionList;

  final List<RemarkModel> propertyRemarkList;

  final List<ImageModel> propertyImageList;


  PropertyDetailModel({
    required this.propertyId,
    required this.buildingId,

    required this.picUser,
    required this.propertyStatus,

    required this.ownerName,
    required this.ownerPhoneNumber,
    required this.ownerRelation,

    required this.roomNumber,
    required this.propertyType,
    required this.propertyFloor,
    required this.roomBathCount,
    required this.mainRoomDirection,

    required this.exclusiveArea,
    required this.supplyArea,

    this.approvalDate = "",
    this.moveInDate = "",
    this.moveOutDate = "",
    this.availableMoveInDate = "",

    required this.heatingType,

    required this.maintenancePrice,
    required this.maintenaceItemList,

    required this.optionItemList,

    required this.propertyTransactionList,
    required this.propertyRemarkList,

    required this.propertyImageList,
  });

  factory PropertyDetailModel.fromJson(Map<String, dynamic> json) {
    return PropertyDetailModel(
      propertyId: json['propertyId'],
      buildingId: json['buildingId'],
      picUser: json['picUser'],
      propertyStatus: json['propertyStatus'],
      ownerName: json['ownerName'],
      ownerPhoneNumber: json['ownerPhoneNumber'],
      ownerRelation: json['ownerRelation'],
      roomNumber: json['roomNumber'],
      propertyType: json['propertyType'],
      propertyFloor: json['propertyFloor'],
      roomBathCount: json['roomBathCount'],
      mainRoomDirection: json['mainRoomDirection'],
      exclusiveArea: json['exclusiveArea'],
      supplyArea: json['supplyArea'],
      approvalDate: json['approvalDate'] ?? "",
      moveInDate: json['moveInDate'] ?? "",
      moveOutDate: json['moveOutDate'] ?? "",
      availableMoveInDate: json['availableMoveInDate'] ?? "",
      heatingType: json['heatingType'],

      maintenancePrice: json['maintenancePrice'],
      maintenaceItemList: (json['maintenaceItemList'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ?? [],

      optionItemList: (json['optionItemList'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ?? [],

      propertyTransactionList: (json['propertyTransactionList'] as List?)
          ?.map((e) => PropertyTransactionTypeDto.fromJson(e))
          .toList() ??
          [],

      propertyRemarkList: (json['propertyRemarkList'] as List?)
          ?.map((e) => RemarkModel.fromJson(e))
          .toList() ??
          [],
      propertyImageList: (json['propertyImageList'] as List?)
          ?.map((e) => ImageModel.fromJson(e))
          .toList() ??
          [],
    );
  }
}