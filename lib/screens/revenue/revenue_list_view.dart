import 'package:flutter/material.dart';
import 'package:property_service_web_ver2/core/enums/screen_type.dart';
import 'package:property_service_web_ver2/models/revenue/revenue_info_model.dart';
import 'package:property_service_web_ver2/models/revenue/revenue_model.dart';
import 'package:property_service_web_ver2/models/revenue/revenue_search_condition.dart';
import 'package:property_service_web_ver2/widgets/common/sub_layout.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/dialog_utils.dart';
import '../../core/utils/foramt_utils.dart';
import '../../core/utils/toast_manager.dart';
import '../../service/property_service.dart';
import '../../widgets/common/card_widget.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/rotating_house_indicator.dart';

class RevenueList extends StatefulWidget {
  const RevenueList({super.key});

  @override
  State<RevenueList> createState() => _RevenueListState();
}

class _RevenueListState extends State<RevenueList> {
  late LoadingState loadingState;
  final PropertyService _propertyService = PropertyService();

  // 검색 조건
  String searchType = "전체";
  List<String> searchTypeList = ["전체", "고객명", "담당자명", "매물주소"];
  final TextEditingController _keywordController = TextEditingController();

  // 날짜 필터
  DateTime? startDate;
  DateTime? endDate;

  // 거래 유형 필터
  String transactionType = "전체";
  List<String> transactionTypeList = ["전체", "월세", "전세", "단기"];
  Map<String, int> transactionTypeCodeMap = {
    "전체": 60,
    "월세": 61,
    "전세": 62,
    "단기": 63,
  };

  // 고객 유입 경로 필터
  String clientSource = "전체";
  List<String> clientSourceList = ["전체", "지인소개", "온라인", "방문", "기타"];

  // 매출 데이터
  RevenueInfoModel? revenueInfo;
  List<RevenueModel> revenueList = [];

  @override
  void initState() {
    super.initState();
    loadingState = Provider.of<LoadingState>(context, listen: false);
    
    // 기본값으로 이번 달 조회
    DateTime now = DateTime.now();
    startDate = DateTime(now.year, now.month, 1);
    endDate = DateTime(now.year, now.month + 1, 0);
    
    _searchRevenues();
  }

  // 매출 목록 검색 API 호출
  Future<void> _searchRevenues() async {
    if (startDate == null || endDate == null) {
      ToastManager().showToast(context, "검색 기간을 선택해 주세요");
      return;
    }

    try {
      loadingState.setLoading(true);

      RevenueSearchCondition condition = RevenueSearchCondition(
        searchType: searchType,
        keyword: _keywordController.text,
        startDate: FormatUtils.formatToYYYYmmDD_forAPI(startDate!),
        endDate: FormatUtils.formatToYYYYmmDD_forAPI(endDate!),
        transactionTypeCode: transactionTypeCodeMap[transactionType] ?? 60,
        clientSource: clientSource,
      );

      RevenueInfoModel? response = await _propertyService.searchRevenueList(condition);
      
      if (response != null) {
        setState(() {
          revenueInfo = response;
          revenueList = response.revenueDtoList;
        });
      }
    } catch (e) {
      print("매출 목록 조회 실패: $e");
      ToastManager().showToast(context, "매출 목록 조회에 실패했습니다");
    } finally {
      loadingState.setLoading(false);
    }
  }

  // 매출 삭제
  Future<void> _deleteRevenue(int revenueId) async {
    bool? confirmed = await DialogUtils.showConfirmDialog(
      context: context,
      title: "매출 삭제",
      content: "정말로 이 매출 기록을 삭제하시겠습니까?",
    );

    if (confirmed == true) {
      try {
        loadingState.setLoading(true);
        bool success = await _propertyService.deleteRevenue(revenueId);
        
        if (success) {
          ToastManager().showToast(context, "매출이 삭제되었습니다");
          _searchRevenues(); // 목록 새로고침
        } else {
          ToastManager().showToast(context, "매출 삭제에 실패했습니다");
        }
      } catch (e) {
        print("매출 삭제 실패: $e");
        ToastManager().showToast(context, "매출 삭제에 실패했습니다");
      } finally {
        loadingState.setLoading(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SubLayout(
      screenType: ScreenType.RevenueList,
      child: Consumer<LoadingState>(
        builder: (context, loadingState, child) {
          if (loadingState.isLoading) {
            return Center(child: RotatingHouseIndicator());
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                // 검색 필터 카드
                _buildSearchCard(),
                const SizedBox(height: 20),
                
                // 매출 요약 카드
                _buildSummaryCard(),
                const SizedBox(height: 20),
                
                // 매출 목록 카드
                _buildRevenueListCard(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchCard() {
    return CardWidget(
      title: "검색 조건",
      width: 1200,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                // 검색 타입 드롭다운
                SizedBox(
                  width: 150,
                  child: DropdownButtonFormField<String>(
                    value: searchType,
                    decoration: const InputDecoration(
                      labelText: "검색 타입",
                      border: OutlineInputBorder(),
                    ),
                    items: searchTypeList.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          searchType = newValue;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 20),
                
                // 검색 키워드
                Expanded(
                  flex: 2,
                  child: CustomTextField(
                    controller: _keywordController,
                    label: "검색 키워드",
                  ),
                ),
                const SizedBox(width: 20),
                
                // 거래 유형
                SizedBox(
                  width: 120,
                  child: DropdownButtonFormField<String>(
                    value: transactionType,
                    decoration: const InputDecoration(
                      labelText: "거래 유형",
                      border: OutlineInputBorder(),
                    ),
                    items: transactionTypeList.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          transactionType = newValue;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 20),
                
                // 고객 유입 경로
                SizedBox(
                  width: 120,
                  child: DropdownButtonFormField<String>(
                    value: clientSource,
                    decoration: const InputDecoration(
                      labelText: "유입 경로",
                      border: OutlineInputBorder(),
                    ),
                    items: clientSourceList.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          clientSource = newValue;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            Row(
              children: [
                // 시작일
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: startDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) {
                        setState(() {
                          startDate = picked;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today),
                          const SizedBox(width: 8),
                          Text(
                            startDate != null 
                                ? FormatUtils.formatToYYYYMMDD(startDate!)
                                : "시작일 선택",
                            style: TextStyle(
                              color: startDate != null ? Colors.black : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                
                // 종료일
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: endDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) {
                        setState(() {
                          endDate = picked;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today),
                          const SizedBox(width: 8),
                          Text(
                            endDate != null 
                                ? FormatUtils.formatToYYYYMMDD(endDate!)
                                : "종료일 선택",
                            style: TextStyle(
                              color: endDate != null ? Colors.black : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                
                // 검색 버튼
                ElevatedButton.icon(
                  onPressed: _searchRevenues,
                  icon: const Icon(Icons.search),
                  label: const Text("검색"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.color1,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return CardWidget(
      title: "매출 요약",
      width: 1200,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.color1.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    const Text(
                      "총 매출 건수",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${revenueInfo?.revenueCount ?? 0}건",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.color1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    const Text(
                      "총 수수료",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      revenueInfo?.totalCommissionFee ?? "0원",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueListCard() {
    return CardWidget(
      title: "매출 목록",
      width: 1200,
      child: Column(
        children: [
          // 테이블 헤더
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: const Row(
              children: [
                Expanded(flex: 1, child: Text("담당자", style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 1, child: Text("고객명", style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 1, child: Text("거래유형", style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text("거래금액", style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text("매물주소", style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 1, child: Text("임대인", style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text("수수료", style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 1, child: Text("입실일", style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(flex: 1, child: Text("작업", style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          
          // 테이블 데이터
          if (revenueList.isEmpty)
            Container(
              padding: const EdgeInsets.all(40),
              child: const Center(
                child: Text(
                  "매출 데이터가 없습니다",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: revenueList.length,
              itemBuilder: (context, index) {
                final revenue = revenueList[index];
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                  ),
                  child: Row(
                    children: [
                      Expanded(flex: 1, child: Text(revenue.picManagerName)),
                      Expanded(flex: 1, child: Text(revenue.clientName)),
                      Expanded(flex: 1, child: Text(revenue.transactionType)),
                      Expanded(flex: 2, child: Text(revenue.transactionPrice)),
                      Expanded(flex: 2, child: Text(revenue.propertyAddress)),
                      Expanded(flex: 1, child: Text(revenue.propertyOwnerName)),
                      Expanded(flex: 2, child: Text(revenue.commissionFee)),
                      Expanded(flex: 1, child: Text(revenue.moveInDate.isEmpty ? "-" : revenue.moveInDate)),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          onPressed: () => _deleteRevenue(revenue.revenueId),
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                          tooltip: "삭제",
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}