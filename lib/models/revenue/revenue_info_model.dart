import 'revenue_model.dart';

class RevenueInfoModel {
  final int revenueCount;
  final String totalCommissionFee;
  final List<RevenueModel> revenueDtoList;

  RevenueInfoModel({
    required this.revenueCount,
    required this.totalCommissionFee,
    required this.revenueDtoList,
  });

  factory RevenueInfoModel.fromJson(Map<String, dynamic> json) {
    var revenueList = json['revenueDtoList'] as List? ?? [];
    
    return RevenueInfoModel(
      revenueCount: json['revenueCount'] ?? 0,
      totalCommissionFee: json['totalCommissionFee'] ?? '0',
      revenueDtoList: revenueList
          .map((revenueJson) => RevenueModel.fromJson(revenueJson))
          .toList(),
    );
  }
}