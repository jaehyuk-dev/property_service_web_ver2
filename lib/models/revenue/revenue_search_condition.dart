class RevenueSearchCondition {
  final String searchType;
  final String keyword;
  final String startDate;
  final String endDate;
  final int transactionTypeCode;
  final String clientSource;

  RevenueSearchCondition({
    required this.searchType,
    required this.keyword,
    required this.startDate,
    required this.endDate,
    required this.transactionTypeCode,
    required this.clientSource,
  });

  Map<String, dynamic> toJson() {
    return {
      'searchType': searchType,
      'keyword': keyword,
      'startDate': startDate,
      'endDate': endDate,
      'transactionTypeCode': transactionTypeCode,
      'clientSource': clientSource,
    };
  }
}