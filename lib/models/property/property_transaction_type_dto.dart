class PropertyTransactionTypeDto {
  final String propertyTransactionType;
  final int price1;
  final int? price2;  // 🔥 null 허용

  PropertyTransactionTypeDto({
    required this.propertyTransactionType,
    required this.price1,
    this.price2,  // 🚀 Null 가능하도록 변경
  });

  factory PropertyTransactionTypeDto.fromJson(Map<String, dynamic> json) {
    return PropertyTransactionTypeDto(
      propertyTransactionType: json['propertyTransactionType'],
      price1: json['price1'],
      price2: json['price2'] as int?, // 🔥 null 허용으로 안전하게 처리
    );
  }
}
