class ShowingPropertyModel{
  final int showingPropertyId;
  final int propertyId;
  final String propertyStatus;
  final String propertyType;
  final String propertyAddress;
  final String propertyTransactionType;
  final int propertyTransactionTypeCode;
  final String propertyPrice;

  ShowingPropertyModel({
    required this.showingPropertyId,
    required this.propertyId,
    required this.propertyStatus,
    required this.propertyType,
    required this.propertyAddress,
    required this.propertyTransactionType,
    required this.propertyTransactionTypeCode,
    required this.propertyPrice,
  });

  factory ShowingPropertyModel.fromJson(Map<String, dynamic> json) {
    return ShowingPropertyModel(
      showingPropertyId: json['showingPropertyId'],
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
