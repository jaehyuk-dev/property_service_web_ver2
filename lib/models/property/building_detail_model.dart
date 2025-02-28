import 'package:property_service_web_ver2/models/common/image_model.dart';
import 'package:property_service_web_ver2/models/common/remark_model.dart';

class BuildingDetailModel{
  final int buildingId;
  final String buildingName;
  final String buildingZoneCode;
  final String buildingAddress;
  final String buildingJibunAddress;
  final int buildingCompletedYear;
  final String buildingTypeName;
  final String buildingFloorCount;
  final int buildingParkingAreaCount;
  final int buildingElevatorCount;
  final String buildingMainDoorDirection;
  final String buildingCommonPassword;
  final bool buildingHasIllegal;

  final List<RemarkModel> buildingRemarkList;

  final List<ImageModel> buildingImageList;


  BuildingDetailModel({
   required this.buildingId,
   required this.buildingName,
   required this.buildingZoneCode,
   required this.buildingAddress,
   required this.buildingJibunAddress,
   required this.buildingCompletedYear,
   required this.buildingTypeName,
   required this.buildingFloorCount,
   required this.buildingParkingAreaCount,
   required this.buildingElevatorCount,
   required this.buildingMainDoorDirection,
   required this.buildingCommonPassword,
   required this.buildingHasIllegal,

   required this. buildingRemarkList,

   required this. buildingImageList,
  });

  factory BuildingDetailModel.fromJson(Map<String, dynamic> json) {
    return BuildingDetailModel(
      buildingId: json['buildingId'],
      buildingName: json['buildingName'],
      buildingZoneCode: json['buildingZoneCode'],
      buildingAddress: json['buildingAddress'],
      buildingJibunAddress: json['buildingJibunAddress'],
      buildingCompletedYear: json['buildingCompletedYear'],
      buildingTypeName: json['buildingTypeName'],
      buildingFloorCount: json['buildingFloorCount'],
      buildingParkingAreaCount: json['buildingParkingAreaCount'],
      buildingElevatorCount: json['buildingElevatorCount'],
      buildingMainDoorDirection: json['buildingMainDoorDirection'],
      buildingCommonPassword: json['buildingCommonPassword'],
      buildingHasIllegal: json['buildingHasIllegal'],
      buildingRemarkList: (json['buildingRemarkList'] as List?)
          ?.map((e) => RemarkModel.fromJson(e))
          .toList() ??
          [],
      buildingImageList: (json['buildingImageList'] as List?)
        ?.map((e) => ImageModel.fromJson(e))
        .toList() ??
        [],
    );
  }

}