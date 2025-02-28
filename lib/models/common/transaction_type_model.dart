class TransactionTypeModel {
  final int transactionCode;
  final int price1;
  final int? price2;

  TransactionTypeModel({
    required this.transactionCode,
    required this.price1,
    this.price2,
  });

  Map<String, dynamic> toJson() {
    return {
      "transactionCode": transactionCode,
      "price1": price1,
      "price2": price2
    };
  }
}