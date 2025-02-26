import 'package:flutter/material.dart';
import 'package:property_service_web_ver2/core/constants/app_colors.dart';
import 'package:property_service_web_ver2/core/enums/screen_type.dart';
import 'package:property_service_web_ver2/core/utils/foramt_utils.dart';
import 'package:property_service_web_ver2/models/client/client_summary_model.dart';
import 'package:property_service_web_ver2/models/common/search_condition.dart';
import 'package:property_service_web_ver2/widgets/common/custom_text_field.dart';
import 'package:provider/provider.dart';

import '../../service/client_service.dart';
import '../../widgets/common/rotating_house_indicator.dart';
import '../../widgets/common/sub_layout.dart';

class ClientList extends StatefulWidget {
  const ClientList({super.key});

  @override
  State<ClientList> createState() => _ClientListState();
}

class _ClientListState extends State<ClientList> {
  late LoadingState loadingState;
  final ClientService clientService = ClientService();

  String searchType = "전체";
  List<String> searchTypeList = ["전체", "담당자", "고객", "고객 전화번호"];
  final TextEditingController _keywordController = TextEditingController();

  int? selectedClientId;
  List<ClientSummaryModel> clientSummaryList = [];

  // 고객 검색 API 호출
  Future<void> _searchClients() async {
    try {
      loadingState.setLoading(true);

      // API 호출
      List<ClientSummaryModel> result = await clientService.searchClients(SearchCondition(searchType: searchType, keyword: _keywordController.text));

      setState(() {
        clientSummaryList = result;
      });

    } catch (e) {
      print("🚨 검색 중 오류 발생: $e");
    } finally {
      loadingState.setLoading(false);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    loadingState = Provider.of<LoadingState>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SubLayout(
      screenType: ScreenType.ClientList,
      child: Row(
        children: [
          Container(
            width: 480,
            height: 720,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(32),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 156,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: searchType,
                          dropdownColor: AppColors.color1,
                          borderRadius: BorderRadius.circular(8),
                          items: searchTypeList
                              .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                searchType = value;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _keywordController,
                        decoration: InputDecoration(
                          hintText: "   $searchType 검색...",
                          suffixIcon: IconButton(onPressed: _searchClients, icon: Icon(Icons.search)),
                          border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFD1D5DB), // 초록색 강조
                              width: 2.0, // 포커스 없을 때 테두리 두께 2.0
                            ),
                          ),
                          // 포커스 테두리 (focused)
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 3.0, // 포커스 상태 경계선 두께 3.0
                            ),
                          ),
                          labelStyle: TextStyle(
                            color: Color(0xFFD1D5DB), // 초록색 강조
                          ),
                        ),
                          onSubmitted: (_) => _searchClients(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Expanded(
                  child: clientSummaryList.isEmpty
                      ? Center(child: Text("검색 결과가 없습니다."))
                      : ListView.separated(
                    itemCount: clientSummaryList.length,
                    itemBuilder: (context, index) {
                      final client = clientSummaryList[index];
                      return _buildClientSummaryInfo(client);
                    },
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientSummaryInfo(ClientSummaryModel client) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedClientId = client.clientId;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey.shade400,
            width: 1.5,
          ),
          color: client.clientId == selectedClientId ? Color(0xFFE5E7EB) : Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      client.clientName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      client.clientSource,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    )
                  ],
                ),
                _buildClientStatus(client.clientStatus),
              ],
            ),
            SizedBox(height: 8),
            Text(
              client.clientPhoneNumber,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  client.clientExpectedMoveInDate != null
                      ? "입주 예정일: ${FormatUtils.formatToYYYYMMDD(client.clientExpectedMoveInDate!)}"
                      : "",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
                Text(
                  "담당자: ${client.picUser}",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClientStatus(String clientStatus) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: getClientStatusBackGroundColor(clientStatus),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        clientStatus,
        style: TextStyle(
            fontSize: 14,
            color: getClientStatusTextColor(clientStatus),
        ),
      ),
    );
  }

  Color getClientStatusBackGroundColor(String clientStatus) {
    switch (clientStatus) {
      case "상담 중":
        return Color(0xFFDCFCE7);
      case "계약 예정":
        return Color(0xFFFEE2E2);
      case "입주 예정":
        return Color(0xFFF3E8FF);
      case "계약 완료":
        return Color(0xFFDBEAFE);
      default:
        return Colors.grey; // ✅ 기본값 추가
    }
  }

  Color getClientStatusTextColor(String clientStatus) {
    switch (clientStatus) {
      case "상담 중":
        return Color(0xFF15803D);
      case "계약 예정":
        return Color(0xFFDC2626);
      case "입주 예정":
        return Color(0xFF9333EA);
      case "계약 완료":
        return Color(0xFF2563EB);
      default:
        return Colors.grey; // ✅ 기본값 추가
    }
  }

}
