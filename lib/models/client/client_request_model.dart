class ClientRequestModel {
  final String clientName;
  final String clientPhoneNumber;
  final int clientGenderCode;
  final String clientSource;
  final String clientType;
  final String expectedMoveInDate;
  final List<int> expectedTransactionTypeCodeList;
  final String clientRemark;

  ClientRequestModel({
    required this.clientName,
    required this.clientPhoneNumber,
    required this.clientGenderCode,
    required this.clientSource,
    required this.clientType,
    required this.expectedMoveInDate,
    required this.expectedTransactionTypeCodeList,
    required this.clientRemark,
  });

  Map<String, dynamic> toJson() {
    return {
      "clientName": clientName,
      "clientPhoneNumber": clientPhoneNumber,
      "clientGenderCode": clientGenderCode,
      "clientSource": clientSource,
      "clientType": clientType,
      "expectedMoveInDate": expectedMoveInDate,
      "expectedTransactionTypeCodeList": expectedTransactionTypeCodeList,
      "clientRemark": clientRemark,
    };
  }
}
