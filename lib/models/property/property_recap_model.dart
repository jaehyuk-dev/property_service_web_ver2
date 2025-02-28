class PropertyRecapModel{
  final int propertyId;
  final String propertyStatus;
  final String propertyType;
  final String propertyAddress;
  final String propertyTransactionType;
  final int propertyTransactionTypeCode;
  final String propertyPrice;

  PropertyRecapModel({
    required this.propertyId,
    required this.propertyStatus,
    required this.propertyType,
    required this.propertyAddress,
    required this.propertyTransactionType,
    required this.propertyTransactionTypeCode,
    required this.propertyPrice,
  });

  factory PropertyRecapModel.fromJson(Map<String, dynamic> json) {
    return PropertyRecapModel(
      propertyId: json['propertyId'],
      propertyStatus: json['propertyStatus'],
      propertyType: json['propertyType'],
      propertyAddress: json['propertyAddress'],
      propertyTransactionType: json['propertyTransactionType'],
      propertyTransactionTypeCode: json['propertyTransactionTypeCode'],
      propertyPrice: json['propertyPrice'],
    );
  }
}