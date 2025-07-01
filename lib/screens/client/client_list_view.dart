import 'package:flutter/material.dart';
import 'package:property_service_web_ver2/core/constants/app_colors.dart';
import 'package:property_service_web_ver2/core/enums/datepicker_type.dart';
import 'package:property_service_web_ver2/core/enums/screen_type.dart';
import 'package:property_service_web_ver2/core/utils/dialog_utils.dart';
import 'package:property_service_web_ver2/core/utils/foramt_utils.dart';
import 'package:property_service_web_ver2/models/calendar/schedule_register_model.dart';
import 'package:property_service_web_ver2/models/client/client_detail_response.dart';
import 'package:property_service_web_ver2/models/client/client_summary_model.dart';
import 'package:property_service_web_ver2/models/client/client_update_model.dart';
import 'package:property_service_web_ver2/models/common/remark_model.dart';
import 'package:property_service_web_ver2/models/common/search_condition.dart';
import 'package:property_service_web_ver2/models/property/property_recap_model.dart';
import 'package:property_service_web_ver2/service/calendar_service.dart';
import 'package:property_service_web_ver2/service/property_service.dart';
import 'package:property_service_web_ver2/widgets/common/card_widget.dart';
import 'package:property_service_web_ver2/widgets/common/custom_date_picker.dart';
import 'package:property_service_web_ver2/widgets/common/custom_text_field.dart';
import 'package:provider/provider.dart';

import '../../core/utils/toast_manager.dart';
import '../../models/client/client_update_expected_transaction_model.dart';
import '../../models/client/showing_property_model.dart';
import '../../models/common/schedule_model.dart';
import '../../service/client_service.dart';
import '../../widgets/common/custom_checkbox_group.dart';
import '../../widgets/common/custom_radio_group.dart';
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
  final PropertyService _propertyService = PropertyService();

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

  // 일정 상태 업데이트
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

  // 고객 특이사항 등록
  void registerClientRemark({required int clientId}) async {
    TextEditingController clientRemark = TextEditingController();

    await DialogUtils.showCustomDialog<void>(
        context: context,
        title: "특이사항 등록",
        child: CustomTextField(label: "특이사항", controller: clientRemark, maxLines: 2),
        onConfirm: () async {
          if (clientRemark.text.isEmpty) {
            await DialogUtils.showAlertDialog(context: context, title: "경고", content: "모든 항목을 입력해 주세요");
          } else {
            Navigator.pop(context, true);
          }
        }
    );

    if(clientRemark.text.isNotEmpty){
      try {
        loadingState.setLoading(true);
        await clientService.registerClientRemark(clientId, clientRemark.text);
        ToastManager().showToast(context, "특이사항이 등록 되었습니다.");
        await _fetchClientDetail();
      } catch (e) {
        print("❌ 오류 발생: $e");
      } finally {
        loadingState.setLoading(false);
      }
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

  // 고객 보여줄 매물 추가
  void createShowingProperty({required int clientId}) async{
    String searchTypeForSP = "전체";
    List<String> searchTypeListForSP = ["전체", "주소", "담당자", "임대인"];
    final TextEditingController keywordControllerForSP = TextEditingController();

    List<PropertyRecapModel> propertyRecapList = [];
    PropertyRecapModel? selectedProperty;

    selectedProperty = await DialogUtils.showCustomDialog<PropertyRecapModel>(
      context: context,
      title: "보여줄 매물 등록",
      width: 800,
      child: StatefulBuilder(
        builder: (context, setDialogState) {
          Future<void> onSearchClientSummaryInfoList() async {
            try {
              loadingState.setLoading(true);

              // API 호출
              List<PropertyRecapModel> resultRecapList = await _propertyService.searchPropertyRecapList(
                SearchCondition(searchType: searchTypeForSP, keyword: keywordControllerForSP.text),
              );

              setDialogState(() {
                propertyRecapList = resultRecapList;
              });

            } catch (e) {
              print("🚨 검색 중 오류 발생: $e");
            } finally {
              loadingState.setLoading(false);
            }
          }

          return Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 120,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: searchTypeForSP,
                        dropdownColor: AppColors.color1,
                        borderRadius: BorderRadius.circular(8),
                        items: searchTypeListForSP
                            .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setDialogState(() {
                              searchTypeForSP = value;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: keywordControllerForSP,
                      decoration: InputDecoration(
                        hintText: "   $searchTypeForSP 검색...",
                        suffixIcon: IconButton(
                          onPressed: onSearchClientSummaryInfoList,
                          icon: Icon(Icons.search),
                        ),
                        border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFD1D5DB),
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 3.0,
                          ),
                        ),
                        labelStyle: TextStyle(
                          color: Color(0xFFD1D5DB),
                        ),
                      ),
                      onSubmitted: (_) => onSearchClientSummaryInfoList(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              SizedBox(
                height: 324,
                child: propertyRecapList.isEmpty
                    ? Center(child: Text("검색 결과가 없습니다."))
                    : ListView.separated(
                  itemCount: propertyRecapList.length,
                  itemBuilder: (context, index) {
                    final propertyRecap = propertyRecapList[index];
                    return InkWell(
                      onTap: () {
                        setDialogState(() {
                          selectedProperty = propertyRecap;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: selectedProperty == propertyRecap
                              ? Color(0xFFE5E7EB)
                              : Colors.white,
                        ),
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildTableCell(propertyRecap.propertyTransactionType),
                            SizedBox(width: 40),
                            _buildTableCell(propertyRecap.propertyPrice),
                            SizedBox(width: 40),
                            _buildTableCell(propertyRecap.propertyType),
                            SizedBox(width: 40),
                            SizedBox(width: 320, child: _buildTableCell(propertyRecap.propertyAddress)),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 12),
                ),
              ),
            ],
          );
        },
      ),
      onConfirm: () async {
        if (selectedProperty == null) {
          await DialogUtils.showAlertDialog(
              context: context,
              title: "경고",
              content: "보여줄 매물을 선택해 주세요."
          );
        } else {
          Navigator.pop(context, selectedProperty); // ✅ 선택된 매물 반환
        }
      },
    );

    if(selectedProperty != null){
      try {
        loadingState.setLoading(true);
        await clientService.createShowingProperty(clientId, selectedProperty!.propertyId, selectedProperty!.propertyTransactionTypeCode);
        ToastManager().showToast(context, "보여줄 매물이 등록 되었습니다.");
        await _fetchClientDetail();
      } catch (e) {
        print("❌ 오류 발생: $e");
      } finally {
        loadingState.setLoading(false);
      }
    }
  }

  // 고객 보여줄 매물 삭제
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

  // 고객 일정 등록
  void createSchedule({required int clientId}) async {
    DateTime? scheduleDateTime;
    int? scheduleTypeCode;
    TextEditingController scheduleRemark = TextEditingController();

    ScheduleRequestModel? request = await DialogUtils.showCustomDialog<ScheduleRequestModel>(
        context: context,
        title: "고객 일정 등록",
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 200,
              child: DropdownButtonFormField<int>(
                dropdownColor: AppColors.color1,
                borderRadius: BorderRadius.circular(8),
                value: scheduleTypeCode,
                decoration: const InputDecoration(labelText: "일정 타입"),
                items: const [
                  DropdownMenuItem(value: 41, child: Text("상담")),
                  DropdownMenuItem(value: 42, child: Text("계약")),
                  DropdownMenuItem(value: 43, child: Text("입주")),
                ],
                onChanged: (value) => setState(() => scheduleTypeCode = value),
              ),
            ),
            SizedBox(height: 32),
            CustomDatePicker(datePickerType: DatePickerType.datetime,
              label: "일시",
              selectedDateTime: scheduleDateTime,
                onChanged:  (DateTime? newDate) {
                  setState(() {
                    scheduleDateTime = newDate;
                  });
                },
            ),
            SizedBox(height: 16),
            CustomTextField(label: "특이사항", controller: scheduleRemark, maxLines: 2),
          ],
        ),
        onConfirm: () async {
          print(scheduleTypeCode);
          print(scheduleDateTime);
          print(scheduleRemark.text);
          if (scheduleTypeCode == null || scheduleDateTime == null) {
           await DialogUtils.showAlertDialog(context: context, title: "경고", content: "모든 항목을 입력해 주세요");
          } else {
            ScheduleRequestModel schedule = ScheduleRequestModel(
              scheduleClientId: clientId,
              scheduleDateTime: FormatUtils.formatToYYYYmmDDHHMM_forAPI(scheduleDateTime!),
              scheduleTypeCode: scheduleTypeCode!,
              scheduleRemark: scheduleRemark.text,
            );

            print(clientId);
            print(scheduleTypeCode);
            print(schedule.scheduleDateTime);
            print(scheduleRemark);
            Navigator.pop(context, schedule);
          }
        }
    );

    if(request != null){
      try {
        loadingState.setLoading(true);
        await _calendarService.createSchedule(request);
        ToastManager().showToast(context, "일정이 등록 되었습니다.");
        await _fetchClientDetail();
      } catch (e) {
        print("❌ 오류 발생: $e");
      } finally {
        loadingState.setLoading(false);
      }
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

  // 고객 정보 수정
  void updateClientDetail({required ClientDetailResponse detail}) async {
    TextEditingController clientName = TextEditingController(text: detail.clientName);
    TextEditingController clientPhoneNumber = TextEditingController(text: detail.clientPhoneNumber);
    int? clientGender = detail.clientGender == "남성" ? 31 : 32;

    // 유입 경로 초기값 설정 로직 수정
    String? clientSource;
    TextEditingController clientSourceOther = TextEditingController();

    if (["직방", "다방", "피터팬", "워킹"].contains(detail.clientSource)) {
      clientSource = detail.clientSource;
    } else {
      clientSource = "기타";
      clientSourceOther.text = detail.clientSource; // 기타 텍스트 필드에 실제 값 설정
    }

    // 고객 유형 초기값 설정 로직 수정
    String? clientType;
    TextEditingController clientTypeOther = TextEditingController();

    if (["학생", "직장인", "외국인"].contains(detail.clientType)) {
      clientType = detail.clientType;
    } else {
      clientType = "기타";
      clientTypeOther.text = detail.clientType; // 기타 텍스트 필드에 실제 값 설정
    }

    DateTime? expectedMoveInDate = detail.clientExpectedMoveInDate;

    ClientUpdateModel? updateModel = await DialogUtils.showCustomDialog<ClientUpdateModel>(
      context: context,
      title: "고객 정보 수정",
      width: 720,
      child: StatefulBuilder(
        builder: (context, setDialogState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  SizedBox(width: 260, child: CustomTextField(label: "고객 명", controller: clientName)),
                  SizedBox(
                    width: 80,
                    child: DropdownButtonFormField<int>(
                      dropdownColor: AppColors.color1,
                      borderRadius: BorderRadius.circular(8),
                      value: clientGender,
                      decoration: const InputDecoration(labelText: "성별"),
                      items: const [
                        DropdownMenuItem(value: 31, child: Text("남성")),
                        DropdownMenuItem(value: 32, child: Text("여성")),
                      ],
                      onChanged: (value) => setDialogState(() => clientGender = value),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  SizedBox(width: 360, child: CustomTextField(label: "고객 전화번호", controller: clientPhoneNumber)),
                ],
              ),
              CustomRadioGroup(
                title: "고객 유형",
                options: ["학생", "직장인", "외국인", "기타"],
                groupValue: clientType,
                onChanged: (value) {
                  setDialogState(() { // 🔥 다이얼로그 내부 UI 업데이트
                    clientType = value;
                  });
                },
                otherLabel: "",
                otherInput: "기타",
                otherInputTextController: clientTypeOther,
              ),
              CustomRadioGroup(
                title: "유입 경로",
                options: ["직방", "다방", "피터팬", "워킹", "기타"],
                groupValue: clientSource,
                onChanged: (value) {
                  setDialogState(() { // 🔥 다이얼로그 내부 UI 업데이트
                    clientSource = value;
                  });
                },
                otherLabel: "",
                otherInput: "기타",
                otherInputTextController: clientSourceOther,
              ),
              SizedBox(height: 16),
              CustomDatePicker(
                datePickerType: DatePickerType.date,
                label: "입주 예정일",
                selectedDateTime: expectedMoveInDate,
                onChanged: (DateTime? newDate) {
                  setDialogState(() { // 🔥 다이얼로그 내부 UI 업데이트
                    expectedMoveInDate = newDate;
                  });
                },
              ),
            ],
          );
        },
      ),
      onConfirm: () async {
        if (clientName.text.isEmpty || clientPhoneNumber.text.isEmpty || clientGender == null || expectedMoveInDate == null) {
          await DialogUtils.showAlertDialog(context: context, title: "경고", content: "모든 항목을 입력해 주세요");
        } else {
          ClientUpdateModel update = ClientUpdateModel(
            clientId: detail.clientId,
            clientName: clientName.text,
            clientPhoneNumber: clientPhoneNumber.text,
            clientGenderCode: clientGender!,
            clientSource: clientSource == "기타" && clientSourceOther.text.trim().isNotEmpty
                ? clientSourceOther.text.trim()
                : clientSource!,
            clientType: clientType == "기타" && clientTypeOther.text.trim().isNotEmpty
                ? clientTypeOther.text.trim()
                : clientType!,
            expectedMoveInDate: FormatUtils.formatToYYYYmmDD_forAPI(expectedMoveInDate!),
          );

          Navigator.pop(context, update);
        }
      },
    );

    if (updateModel != null) {
      try {
        loadingState.setLoading(true);
        await clientService.updateClientDetail(updateModel);
        ToastManager().showToast(context, "고객 정보가 수정되었습니다.");
        await _fetchClientDetail();
      } catch (e) {
        print("❌ 오류 발생: $e");
      } finally {
        loadingState.setLoading(false);
      }
    }
  }

  // 고객 희망 거래 유형 수정
  void updateClientExpectedTransaction({required ClientDetailResponse detail}) async {
    List<String> expectedTransactionTypeList = detail.clientExpectedTransactionTypeList;

    ClientUpdateExpectedTransactionModel? request = await DialogUtils.showCustomDialog<ClientUpdateExpectedTransactionModel?>(
      context: context,
      title: "거래 유형 수정",
      child: StatefulBuilder(
        builder: (context, setDialogState) {
          return CustomCheckboxGroup(
            title: "거래 유형",
            options: ["월세", "전세", "단기"],
            selectedValues: expectedTransactionTypeList,
            onChanged: (values) {
              setDialogState(() {
                expectedTransactionTypeList = values;
              });
            },
          );
        },
      ),
      onConfirm: () async {
        if (expectedTransactionTypeList.isEmpty) {
          await DialogUtils.showAlertDialog(context: context, title: "경고", content: "거래 유형을 선택해 주세요");
        } else {
          ClientUpdateExpectedTransactionModel transactionModelList = ClientUpdateExpectedTransactionModel(
            clientId: detail.clientId,
            expectedTransactionTypeCodeList: expectedTransactionTypeList.map((type) {
              switch (type) {
                case "월세":
                  return 61;
                case "전세":
                  return 62;
                case "단기":
                  return 64;
                default:
                  throw Exception("❌ 지원되지 않는 거래 유형: $type");
              }
            }).toList(),
          );

          Navigator.pop(context, transactionModelList);
        }
      },
    );

    if (request != null) {
      try {
        loadingState.setLoading(true);
        await clientService.updateClientExpectedTransaction(request);
        ToastManager().showToast(context, "고객 거래 유형이 수정되었습니다.");
        await _fetchClientDetail();
      } catch (e) {
        print("❌ 오류 발생: $e");
      } finally {
        loadingState.setLoading(false);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    loadingState = Provider.of<LoadingState>(context, listen: false);
    _searchClients();
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
                      width: 160,
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
                  onEditTap: clientDetail == null
                      ? null
                      : () async {
                    // 일정 추가 기능 추가 가능
                    updateClientDetail(detail: clientDetail!);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width:140, child: _buildBasicInfo("성함", clientDetail == null ? "" : "${clientDetail!.clientName} (${clientDetail!.clientGender.substring(0, 1)})")),
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
                            SizedBox(
                              width: 160,
                              child: _buildBasicInfo(
                                "거래 유형",
                                clientDetail == null
                                    ? ""
                                    : clientDetail!
                                        .clientExpectedTransactionTypeList
                                        .join(", "),
                                onEditTap: clientDetail == null
                                    ? null
                                    : () async {
                                  // 일정 추가 기능 추가 가능
                                  updateClientExpectedTransaction(detail: clientDetail!);
                                },
                              ),
                            ),
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
                        onPlusTap: clientDetail == null
                            ? null
                            : () async {
                              // 일정 추가 기능 추가 가능
                              createSchedule(clientId: clientDetail!.clientId);
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
                        onPlusTap: clientDetail == null
                            ? null
                            : () async {
                          // 일정 추가 기능 추가 가능
                          createShowingProperty(clientId: clientDetail!.clientId);
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
                    onPlusTap: clientDetail == null
                        ? null
                        : () async {
                      // 일정 추가 기능 추가 가능
                      registerClientRemark(clientId: clientDetail!.clientId);
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

  Widget _buildBasicInfo(String label, String content, {VoidCallback? onEditTap}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            if (onEditTap != null)
              Row(
                children: [
                  SizedBox(width: 8),
                  InkWell(
                    onTap: onEditTap,
                    child: Icon(
                      Icons.credit_card_sharp,
                      size: 18,
                      color: Color(0xFF9CA3AF),
                    ),
                  )
                ],
              ),
          ],
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
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTableCell(property.propertyTransactionType),
            SizedBox(width: 40),
            _buildTableCell(property.propertyPrice),
            SizedBox(width: 40),
            _buildTableCell(property.propertyType),
            SizedBox(width: 40),
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
      maxLines: 2,
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
                FormatUtils.formatToYYYYMMDD(remark.createdAt),
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
