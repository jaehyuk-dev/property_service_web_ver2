class BuildingRegisterModel {
  final String buildingName;

  final String buildingZoneCode;
  final String buildingAddress;
  final String buildingJibunAddress;
  final int buildingCompletedYear;
  final int buildingTypeCode;

  final String buildingFloorCount;
  final int buildingParkingAreaCount;
  final int buildingElevatorCount;
  final String buildingMainDoorDirection;
  final String buildingCommonPassword;
  final bool buildingHasIllegal;

  final String buildingRemark;

  final int buildingMainPhotoIndex;
  final List<String> photoList;


  BuildingRegisterModel({
    required this.buildingName,
    required this.buildingZoneCode,
    required this.buildingAddress,
    required this.buildingJibunAddress,
    required this.buildingCompletedYear,
    required this.buildingTypeCode,
    required this.buildingFloorCount,
    required this.buildingParkingAreaCount,
    required this.buildingElevatorCount,
    this.buildingMainDoorDirection = "",
    this.buildingCommonPassword = "",
    required this.buildingHasIllegal,
    required this.buildingRemark,
    required this.buildingMainPhotoIndex,
    required this.photoList,
  });

  Map<String, dynamic> toJson() {
    return {
      "buildingName": buildingName,
      "buildingZoneCode": buildingZoneCode,
      "buildingAddress": buildingAddress,
      "buildingJibunAddress": buildingJibunAddress,
      "buildingCompletedYear": buildingCompletedYear,
      "buildingTypeCode": buildingTypeCode,
      "buildingFloorCount": buildingFloorCount,
      "buildingParkingAreaCount": buildingParkingAreaCount,
      "buildingElevatorCount": buildingElevatorCount,
      "buildingMainDoorDirection": buildingMainDoorDirection,
      "buildingCommonPassword": buildingCommonPassword,
      "buildingHasIllegal": buildingHasIllegal,
      "buildingRemark": buildingRemark,
      "buildingMainPhotoIndex": buildingMainPhotoIndex,
      "photoList": photoList,
    };
  }
}