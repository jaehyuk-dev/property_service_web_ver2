import 'package:property_service_web_ver2/models/property/property_transaction_type_model.dart';

class PropertySummaryModel{
  final int propertyId;
  final String propertyStatus;
  final String propertyType;
  final String propertyAddress;
  final double propertyExclusiveArea;

  final List<PropertyTransactionTypeModel> propertyTransactionList;

  final String propertyMainPhotoUrl;

  PropertySummaryModel({
   required this.propertyId,
   required this.propertyStatus,
   required this.propertyType,
   required this.propertyAddress,
   required this.propertyExclusiveArea,

   required this.propertyTransactionList,

   required this.propertyMainPhotoUrl,

  });

  factory PropertySummaryModel.fromJson(Map<String, dynamic> json) {
    return PropertySummaryModel(
      propertyId: json['propertyId'],
      propertyStatus: json['propertyStatus'],
      propertyType: json['propertyType'],
      propertyAddress: json['propertyAddress'],
      propertyExclusiveArea: (json['propertyExclusiveArea'] as num?)?.toDouble() ?? 0.0, // ✅ double 변환 안전하게 처리
      propertyTransactionList: (json['propertyTransactionList'] as List?) // ✅ 올바른 키 사용
          ?.map((e) => PropertyTransactionTypeModel.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      propertyMainPhotoUrl: json['propertyMainPhotoUrl'] ?? '',
    );
  }

}