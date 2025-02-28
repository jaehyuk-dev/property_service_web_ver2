class BuildingSummaryModel {
  final int buildingId;
  final String buildingName;
  final String buildingAddress;
  final String buildingType;

  final String buildingMainPhotoUrl;

  BuildingSummaryModel({
    required this.buildingId,
    required this.buildingName,
    required this.buildingAddress,
    required this.buildingType,
    required this.buildingMainPhotoUrl,
  });

  factory BuildingSummaryModel.fromJson(Map<String, dynamic> json) {
    return BuildingSummaryModel(
      buildingId: json['buildingId'],
      buildingName: json['buildingName'],
      buildingAddress: json['buildingAddress'],
      buildingType: json['buildingType'],
      buildingMainPhotoUrl: json['buildingMainPhotoUrl'],
    );
  }
}