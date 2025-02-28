class ClientUpdateModel{
  final int clientId;
  final String clientName;
  final String clientPhoneNumber;
  final int clientGenderCode;
  final String clientSource;
  final String clientType;
  final String expectedMoveInDate;

  ClientUpdateModel({
    required this.clientId,
    required this.clientName,
    required this.clientPhoneNumber,
    required this.clientGenderCode,
    required this.clientSource,
    required this.clientType,
    required this.expectedMoveInDate,
  });

  Map<String, dynamic> toJson() {
    return {
      "clientId": clientId,
      "clientName": clientName,
      "clientPhoneNumber": clientPhoneNumber,
      "clientGenderCode": clientGenderCode,
      "clientSource": clientSource,
      "clientType": clientType,
      "expectedMoveInDate": expectedMoveInDate,
    };
  }
}