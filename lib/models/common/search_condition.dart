class SearchCondition {
  final String searchType;
  final String keyword;

  SearchCondition({
    required this.searchType,
    required this.keyword,
  });

  Map<String, dynamic> toJson() {
    return {
      "searchType": searchType,
      "keyword": keyword,
    };
  }
}