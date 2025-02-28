class ClientUpdateExpectedTransactionModel {
  final int clientId;
  final List<int> expectedTransactionTypeCodeList; // 고객 희망 거래 유형(61: 월세, 62: 전세, 64: 단기

  ClientUpdateExpectedTransactionModel({
    required this.clientId,
    required this.expectedTransactionTypeCodeList,
  });

  Map<String, dynamic> toJson() {
    return {
      "clientId": clientId,
      "expectedTransactionTypeCodeList": expectedTransactionTypeCodeList,
    };
  }
}
