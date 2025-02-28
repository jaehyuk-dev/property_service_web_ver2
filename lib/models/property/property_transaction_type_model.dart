class PropertyTransactionTypeModel{
  final String transactionType;
  final String price;

  PropertyTransactionTypeModel({
    required this.transactionType,
    required this.price
  });

  factory PropertyTransactionTypeModel.fromJson(Map<String, dynamic> json) {
    return PropertyTransactionTypeModel(
      transactionType: json['transactionType'],
      price: json['price'],
    );
  }
}
