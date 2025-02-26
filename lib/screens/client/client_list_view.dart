import 'package:flutter/material.dart';
import 'package:property_service_web_ver2/core/constants/app_colors.dart';
import 'package:property_service_web_ver2/core/enums/screen_type.dart';
import 'package:property_service_web_ver2/core/utils/foramt_utils.dart';
import 'package:property_service_web_ver2/models/client/client_detail_response.dart';
import 'package:property_service_web_ver2/models/client/client_summary_model.dart';
import 'package:property_service_web_ver2/models/common/remark_model.dart';
import 'package:property_service_web_ver2/models/common/search_condition.dart';
import 'package:property_service_web_ver2/service/calendar_service.dart';
import 'package:property_service_web_ver2/widgets/common/card_widget.dart';
import 'package:provider/provider.dart';

import '../../core/utils/toast_manager.dart';
import '../../models/client/showing_property_model.dart';
import '../../models/common/schedule_model.dart';
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
  final CalendarService _calendarService = CalendarService();

  String searchType = "전체";
  List<String> searchTypeList = ["전체", "담당자", "고객", "고객 전화번호"];
  final TextEditingController _keywordController = TextEditingController();

  int? selectedClientId;
  List<ClientSummaryModel> clientSummaryList = [];
  ClientDetailResponse? clientDetail;

  // 고객 검색 API 호출
  Future<void> _searchClients() async {
    try {
      loadingState.setLoading(true);

      // API 호출
      List<ClientSummaryModel> result = await clientService.searchClientSummaryInfoList(SearchCondition(searchType: searchType, keyword: _keywordController.text));

      setState(() {
        clientSummaryList = result;
      });

    } catch (e) {
      print("🚨 검색 중 오류 발생: $e");
    } finally {
      loadingState.setLoading(false);
    }
  }

  // 고객 상세 정보 가져오기
  Future<void> _fetchClientDetail() async {
    try {
      loadingState.setLoading(true);
      final ClientDetailResponse? detail = await clientService.searchClientDetail(selectedClientId!);

      if (mounted) {
        setState(() {
          clientDetail = detail;
        });
      }
    } catch (e) {
      print("🚨 검색 중 오류 발생: $e");
    } finally {
      loadingState.setLoading(false);
    }
  }

  // 일저 상태 업데이트
  void changeScheduleStatus({required int scheduleId, required bool complete}) async {
    try {
      loadingState.setLoading(true);
      await _calendarService.updateScheduleCompleted(scheduleId: scheduleId, complete: complete);
      ToastManager().showToast(context, "일정 상태가 업데이트 되었습니다.");
      await _fetchClientDetail();
    } catch (e) {
      print("❌ 오류 발생: $e");
    } finally {
      loadingState.setLoading(false);
    }
  }

  // 고객 특이사항 삭제
  void deleteClientRemark({required int clientRemarkId}) async {
    try {
      loadingState.setLoading(true);
      await clientService.deleteClientRemark(clientRemarkId);
      ToastManager().showToast(context, "특이사항이 제거되었습니다.");
      await _fetchClientDetail();
    } catch (e) {
      print("❌ 오류 발생: $e");
    } finally {
      loadingState.setLoading(false);
    }
  }

  // 고객 특이사항 삭제
  void removeShowingProperty({required int showingPropertyId}) async {
    try {
      loadingState.setLoading(true);
      await clientService.removeShowingProperty(showingPropertyId);
      ToastManager().showToast(context, "보여줄 매물이 제거되었습니다.");
      await _fetchClientDetail();
    } catch (e) {
      print("❌ 오류 발생: $e");
    } finally {
      loadingState.setLoading(false);
    }
  }

  // 일정 삭제
  void removeSchedule({required int scheduleId}) async {
    try {
      loadingState.setLoading(true);
      await _calendarService.removeSchedule(scheduleId);
      ToastManager().showToast(context, "일정이 제거되었습니다.");
      await _fetchClientDetail();
    } catch (e) {
      print("❌ 오류 발생: $e");
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 480,
            height: 724,
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
          SizedBox(width: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardWidget(
                title: "고객 정보",
                  width: 1080,
                  onEditTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width:140, child: _buildBasicInfo("성함", clientDetail == null ? "" : clientDetail!.clientName)),
                            SizedBox(width:200, child: _buildBasicInfo("전화번호", clientDetail == null ? "" : clientDetail!.clientPhoneNumber)),
                            SizedBox(width:160, child: _buildBasicInfo("담당자", clientDetail == null ? "" : clientDetail!.clientPicUser)),
                            SizedBox(width:100,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "상태",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  _buildClientStatus(clientDetail == null ? "" : clientDetail!.clientStatus)
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width:140, child: _buildBasicInfo("유입 경로", clientDetail == null ? "" : clientDetail!.clientSource)),
                            SizedBox(width:200, child: _buildBasicInfo("고객 유형", clientDetail == null ? "" : clientDetail!.clientType)),
                            SizedBox(width:160, child: _buildBasicInfo("거래 유형", clientDetail == null ? "" : clientDetail!.clientExpectedTransactionTypeList.join(", "),)),
                            SizedBox(width:100, child: _buildBasicInfo("입주 예정일", clientDetail == null ? "" : FormatUtils.formatToYYYYMMDD(clientDetail!.clientExpectedMoveInDate!))),
                          ],
                        )
                      ],
                    ),
                  ),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CardWidget(
                        title: "일정",
                        onPlusTap: () {
                          // 일정 추가 기능 추가 가능
                        },
                        child: SizedBox(
                          height: 88,
                          child: clientDetail == null || clientDetail!.scheduleList.isEmpty
                              ? Center(child: Text("등록된 일정이 없습니다."))
                              : ListView.separated(
                            itemCount: clientDetail!.scheduleList.length,
                            itemBuilder: (context, index) {
                              final schedule = clientDetail!.scheduleList[index];
                              return _buildScheduleItem(schedule);
                            },
                            separatorBuilder: (context, index) => SizedBox(height: 8),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      CardWidget(
                        title: "보여줄 매물",
                        onPlusTap: () {
                          // 일정 추가 기능 추가 가능
                        },
                        child: SizedBox(
                          height: 88,
                          child: clientDetail == null || clientDetail!.showingPropertyList.isEmpty
                              ? Center(child: Text("보여줄 매물이 없습니다."))
                              : ListView.separated(
                            itemCount: clientDetail!.showingPropertyList.length,
                            itemBuilder: (context, index) {
                              final showingProperty = clientDetail!.showingPropertyList[index];
                              return _buildShowingPropertyItem(showingProperty);
                            },
                            separatorBuilder: (context, index) => SizedBox(height: 8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 24),
                  CardWidget(
                    title: "특이사항",
                    width: 340,
                    onPlusTap: () {
                      // 일정 추가 기능 추가 가능
                    },
                    child: SizedBox(
                      height: 324,
                      child: clientDetail == null || clientDetail!.clientRemarkList.isEmpty
                          ? Center(child: Text("등록된 특이사항이 없습니다."))
                          : ListView.separated(
                        itemCount: clientDetail!.clientRemarkList.length,
                        itemBuilder: (context, index){
                          final remark = clientDetail!.clientRemarkList[index];
                          return _buildRemarkItem(remark);
                        },
                        separatorBuilder: (context, index) => SizedBox(height: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildClientSummaryInfo(ClientSummaryModel client) {
    return InkWell(
      onTap: () {
        if (selectedClientId != client.clientId) {
          setState(() {
            selectedClientId = client.clientId;
          });
          _fetchClientDetail();
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          // border: Border.all(
          //   color: Colors.grey.shade400,
          //   width: 1.5,
          // ),
          color: client.clientId == selectedClientId ? Color(0xFFE5E7EB) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(12),
              blurRadius: 4,
              spreadRadius: 1,
              offset: Offset(2, 2),
            ),
          ],
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

  Widget _buildBasicInfo(String label, String content){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            SizedBox(width: 4),
            Text(
              content,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF374151),
              ),
            ),
          ],
        )
      ],
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
        return Colors.white; // ✅ 기본값 추가
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
        return Colors.white; // ✅ 기본값 추가
    }
  }


  Widget _buildScheduleItem(ScheduleModel schedule) {
    ValueNotifier<bool> _isHovered = ValueNotifier(false);
    return MouseRegion(
      onEnter: (_) => _isHovered.value = true,
      onExit: (_) => _isHovered.value = false,
      child: Container(
        // padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Row(
                  children: [
                    Checkbox(
                        value: schedule.isCompleted,
                        onChanged: (value) => changeScheduleStatus(scheduleId: schedule.scheduleId, complete: value!),
                        overlayColor: WidgetStatePropertyAll(Colors.transparent),
                        activeColor: Color(0xFF6B7280),
                        side: BorderSide(color: Color(0xFF6B7280), width: 2)
                    ),
                    Text(
                      FormatUtils.formatToYYYYmmDDHHMM(schedule.scheduleDate),
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF4B5563),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 24),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: getScheduleBackGroundColor(schedule.scheduleType),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    schedule.scheduleType,
                    style: TextStyle(
                        fontSize: 16,
                        color: getScheduleTextColor(schedule.scheduleType)
                    ),
                  ),
                ),
                SizedBox(width: 24),
                Row(
                  children: [
                    Text(
                      schedule.scheduleRemark,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                ValueListenableBuilder<bool>(
                  valueListenable: _isHovered,
                  builder: (context, isHovered, child) {
                    return AnimatedOpacity(
                      opacity: isHovered ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 100),
                      child: IconButton(
                        icon: Icon(Icons.delete, color: Colors.grey),
                        iconSize: 16,
                        onPressed: () => removeSchedule(scheduleId: schedule.scheduleId),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color getScheduleBackGroundColor(String scheduleType) {
    switch (scheduleType) {
      case "상담":
        return Color(0xFFDCFCE7);
      case "계약":
        return Color(0xFFFEE2E2);
      case "입주":
        return Color(0xFFDBEAFE);
      default:
        return Colors.grey; // ✅ 기본값 추가
    }
  }

  Color getScheduleTextColor(String scheduleType) {
    switch (scheduleType) {
      case "상담":
        return Color(0xFF16A34A);
      case "계약":
        return Color(0xFFDC2626);
      case "입주":
        return Color(0xFF2563EB);
      default:
        return Colors.grey; // ✅ 기본값 추가
    }
  }


  Widget _buildShowingPropertyItem(ShowingPropertyModel property) {
    ValueNotifier<bool> _isHovered = ValueNotifier(false);
    return MouseRegion(
      onEnter: (_) => _isHovered.value = true,
      onExit: (_) => _isHovered.value = false,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTableCell(property.propertyTransactionType),
            _buildTableCell(property.propertyPrice),
            _buildTableCell(property.propertyType),
            _buildTableCell(property.propertyAddress),
            Spacer(),
            ValueListenableBuilder<bool>(
              valueListenable: _isHovered,
              builder: (context, isHovered, child) {
                return AnimatedOpacity(
                  opacity: isHovered ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 100),
                  child: IconButton(
                    icon: Icon(Icons.delete, color: Colors.grey),
                    iconSize: 16,
                    onPressed: () => removeShowingProperty(showingPropertyId: property.showingPropertyId),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.grey[800],
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        color: Colors.black,
      ),
    );
  }


  Widget _buildRemarkItem(RemarkModel remark) {
    ValueNotifier<bool> _isHovered = ValueNotifier(false);
    return MouseRegion(
      onEnter: (_) => _isHovered.value = true,
      onExit: (_) => _isHovered.value = false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                remark.remark,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Spacer(),
              ValueListenableBuilder<bool>(
                valueListenable: _isHovered,
                builder: (context, isHovered, child) {
                  return AnimatedOpacity(
                    opacity: isHovered ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 100),
                    child: IconButton(
                      icon: Icon(Icons.delete, color: Colors.grey),
                      iconSize: 16,
                      onPressed: () => deleteClientRemark(clientRemarkId: remark.remarkId),
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "작성자: ${remark.createdBy}",
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              ),
              Text(
                FormatUtils.formatToYYYYmmDDHHMM(remark.createdAt),
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
