class RevenueModel {
  final int revenueId;
  final String picManagerName;
  final String clientName;
  final String transactionType;
  final String transactionPrice;
  final String propertyAddress;
  final String propertyOwnerName;
  final String commissionFee;
  final String moveInDate;
  final String moveOutDate;

  RevenueModel({
    required this.revenueId,
    required this.picManagerName,
    required this.clientName,
    required this.transactionType,
    required this.transactionPrice,
    required this.propertyAddress,
    required this.propertyOwnerName,
    required this.commissionFee,
    required this.moveInDate,
    required this.moveOutDate,
  });

  factory RevenueModel.fromJson(Map<String, dynamic> json) {
    return RevenueModel(
      revenueId: json['revenueId'] ?? 0,
      picManagerName: json['picManagerName'] ?? '',
      clientName: json['clientName'] ?? '',
      transactionType: json['transactionType'] ?? '',
      transactionPrice: json['transactionPrice'] ?? '',
      propertyAddress: json['propertyAddress'] ?? '',
      propertyOwnerName: json['propertyOwnerName'] ?? '',
      commissionFee: json['commissionFee'] ?? '',
      moveInDate: json['moveInDate'] ?? '',
      moveOutDate: json['moveOutDate'] ?? '',
    );
  }
}