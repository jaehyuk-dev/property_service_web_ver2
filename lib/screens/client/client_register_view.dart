import 'package:flutter/material.dart';
import 'package:property_service_web_ver2/core/enums/datepicker_type.dart';
import 'package:property_service_web_ver2/core/enums/screen_type.dart';
import 'package:property_service_web_ver2/core/utils/toast_manager.dart';
import 'package:property_service_web_ver2/models/client/client_request_model.dart';
import 'package:property_service_web_ver2/widgets/common/card_widget.dart';
import 'package:property_service_web_ver2/widgets/common/custom_checkbox_group.dart';
import 'package:property_service_web_ver2/widgets/common/custom_date_picker.dart';
import 'package:property_service_web_ver2/widgets/common/custom_radio_group.dart';
import 'package:property_service_web_ver2/widgets/common/custom_text_field.dart';
import 'package:property_service_web_ver2/widgets/common/sub_layout.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../service/client_service.dart';
import '../../widgets/common/rotating_house_indicator.dart';

class ClientRegister extends StatefulWidget {
  const ClientRegister({super.key,});

  @override
  State<ClientRegister> createState() => _ClientRegisterState();
}

class _ClientRegisterState extends State<ClientRegister> {
  late LoadingState loadingState;
  final ClientService clientService = ClientService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();
  DateTime? _selectedExpectedMoveInDate;
  String? _selectedGender;
  String? _selectedClientType;
  final TextEditingController _typeOtherController = TextEditingController();
  String? _selectedClientSource;
  final TextEditingController _sourceOtherController = TextEditingController();
  List<String> _selectedTransactionTypes = [];

  Future<void> _registerClient() async {
    try {
      loadingState.setLoading(true);

      // 성별 코드 변환
      int clientGenderCode = _selectedGender == "남성" ? 31 : 32;

      // 거래 유형 변환
      List<int> expectedTransactionTypeCodeList = _selectedTransactionTypes.map((type) {
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
      }).toList();

      // clientSource 설정 (null이면 otherController 값, 그것도 없으면 "기타")
      String clientSource = _selectedClientSource ??
          (_sourceOtherController.text.isNotEmpty ? _sourceOtherController.text : "기타");

      // clientType 설정 (null이면 otherController 값, 그것도 없으면 "기타")
      String clientType = _selectedClientType ??
          (_typeOtherController.text.isNotEmpty ? _typeOtherController.text : "기타");

      // 고객 요청 모델 생성
      ClientRequestModel clientRequestModel = ClientRequestModel(
        clientName: _nameController.text,
        clientPhoneNumber: _phoneController.text,
        clientGenderCode: clientGenderCode,
        clientSource: clientSource,
        clientType: clientType,
        expectedMoveInDate:  _selectedExpectedMoveInDate != null
            ? DateFormat('yyyyMMdd').format(_selectedExpectedMoveInDate!)
            : "날짜 미정",
        expectedTransactionTypeCodeList: expectedTransactionTypeCodeList,
        clientRemark: _remarkController.text,
      );

      await clientService.registerClient(clientRequestModel);

      _clearClientInfo();

      ToastManager().showToast(context, "고객이 등록 되었습니다.");

    } catch (e) {
      print("Failed to fetch events: $e");
    } finally {
      loadingState.setLoading(false);
    }
  }

  void _clearClientInfo() {
    setState(() {
      _nameController.text = "";
      _phoneController.text = "";
      _remarkController.text = "";
      _typeOtherController.text = "";
      _sourceOtherController.text = "";
      _selectedClientSource = null;
      _selectedGender = null;
      _selectedClientType = null;
      _selectedExpectedMoveInDate = null;
      _selectedTransactionTypes.clear();
    });
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
      screenType: ScreenType.ClientRegister,
      buttonText: "등록",
      onTap: _registerClient,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardWidget(
                title: "기본 정보",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        "고객명",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF374151),
                        ),
                      ),
                    ),
                    CustomTextField(label: "",controller: _nameController),
                    SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        "전화번호",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF374151),
                        ),
                      ),
                    ),
                    CustomTextField(label: "", controller: _phoneController),
                    // SizedBox(height: 12),
                  ],
                ),
              ),
              SizedBox(width: 32),
              CardWidget(
                title: "고객 분류",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomRadioGroup(
                      title: "성별",
                      options: ["남성", "여성"],
                      groupValue: _selectedGender,
                      onChanged: (value){
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                    ),
                    SizedBox(height: 4),
                    CustomRadioGroup(
                      title: "고객 유형",
                      options: ["학생", "직장인", "외국인", "기타"],
                      groupValue: _selectedClientType,
                      onChanged: (value){
                        setState(() {
                          _selectedClientType = value;
                        });
                      },
                      otherLabel: "",
                      otherInput: "기타",
                      otherInputTextController: _typeOtherController,
                    ),
                    SizedBox(height: 4),
                    CustomRadioGroup(
                      title: "유입 경로",
                      options: ["직방", "다방", "피터팬", "워킹", "기타"],
                      groupValue: _selectedClientSource,
                      onChanged: (value){
                        setState(() {
                          _selectedClientSource = value;
                        });
                      },
                      otherLabel: "",
                      otherInput: "기타",
                      otherInputTextController: _sourceOtherController,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardWidget(
                title: "거래 정보",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomCheckboxGroup(
                      title: "거래 유형",
                      options: ["월세", "전세", "단기"],
                      selectedValues: _selectedTransactionTypes,
                      onChanged: (values) {
                        setState(() {
                          _selectedTransactionTypes = values;
                        });
                      },
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: Text(
                        "입주 가능일",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF374151),
                        ),
                      ),
                    ),
                    CustomDatePicker(
                        datePickerType: DatePickerType.date,
                        label: "",
                        selectedDateTime: _selectedExpectedMoveInDate,
                      onChanged:  (DateTime? newDate) {
                        setState(() {
                          _selectedExpectedMoveInDate = newDate;
                        });
                      },
                    )
                  ],
                ),
              ),
              SizedBox(width: 32),
              CardWidget(
                title: "특이사항",
                child: Column(
                  children: [
                    SizedBox(height: 4),
                    CustomTextField(label: "", controller: _remarkController, maxLines: 5),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
