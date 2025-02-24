import 'package:flutter/material.dart';
import 'package:property_service_web_ver2/core/enums/datepicker_type.dart';
import 'package:property_service_web_ver2/core/enums/screen_type.dart';
import 'package:property_service_web_ver2/widgets/common/card_widget.dart';
import 'package:property_service_web_ver2/widgets/common/custom_checkbox_group.dart';
import 'package:property_service_web_ver2/widgets/common/custom_date_picker.dart';
import 'package:property_service_web_ver2/widgets/common/custom_radio_group.dart';
import 'package:property_service_web_ver2/widgets/common/custom_text_field.dart';
import 'package:property_service_web_ver2/widgets/common/sub_layout.dart';
import 'package:provider/provider.dart';

import '../../widgets/common/rotating_house_indicator.dart';

class ClientRegister extends StatefulWidget {
  const ClientRegister({super.key});

  @override
  State<ClientRegister> createState() => _ClientRegisterState();
}

class _ClientRegisterState extends State<ClientRegister> {

  @override
  Widget build(BuildContext context) {
    return SubLayout(screenType: ScreenType.ClientRegister, child: ClientRegisterView());
  }
}

class ClientRegisterView extends StatefulWidget {
  const ClientRegisterView({super.key});

  @override
  State<ClientRegisterView> createState() => _ClientRegisterViewState();
}

class _ClientRegisterViewState extends State<ClientRegisterView> {
  late LoadingState loadingState;

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

  @override
  void initState() {
    // TODO: implement initState
    loadingState = Provider.of<LoadingState>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    options: ["월세", "전세", "매매"],
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
                  CustomDatePicker(datePickerType: DatePickerType.date, label: "", selectedDateTime: _selectedExpectedMoveInDate)
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
    );
  }
}

