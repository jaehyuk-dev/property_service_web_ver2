import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/utils/comma_text_input_formatter.dart';
import '../../models/common/maintenance_form.dart';
import 'custom_text_field.dart';

class MaintenanceCostForm extends StatefulWidget {
  final MaintenanceFormModel maintenanceFormModel;
  const MaintenanceCostForm({super.key, required this.maintenanceFormModel});

  @override
  State<MaintenanceCostForm> createState() => _MaintenanceCostFormState();
}

class _MaintenanceCostFormState extends State<MaintenanceCostForm> {
  final TextEditingController maintenanceFeeController = TextEditingController();
  final TextEditingController otherController = TextEditingController();

  bool isOthers = false;

  @override
  void initState() {
    maintenanceFeeController.addListener(_updateMaintenanceFee);
    otherController.addListener(_updateOthers);
    super.initState();
  }

  @override
  void dispose() {
    maintenanceFeeController.removeListener(_updateMaintenanceFee);
    otherController.removeListener(_updateOthers);
    super.dispose();
  }

  void _updateMaintenanceFee() {
    setState(() {
      widget.maintenanceFormModel.maintenanceFee =
          int.tryParse(maintenanceFeeController.text) ?? 0;
    });
  }

  void _updateOthers() {
    setState(() {
      widget.maintenanceFormModel.others = otherController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "관리비",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF374151),
                ),
              ),
            ),
            SizedBox(
              width: 300,
              child: CustomTextField(
                  label: "",
                  controller: maintenanceFeeController,
                  suffixText: "원",
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, CommaTextInputFormatter()]
              ),
            ),
          ],
        ),
        SizedBox(width: 24),
        Column(
          children: [
            SizedBox(height: 28),
            Row(
              children: [
                _checkboxWithLabel(
                  "수도",
                  widget.maintenanceFormModel.isWaterSelected,
                      (newValue) {
                    setState(() {
                      widget.maintenanceFormModel.isWaterSelected = newValue!;
                    });
                  },
                ),
                _checkboxWithLabel(
                  "전기",
                  widget.maintenanceFormModel.isElectricitySelected,
                      (newValue) {
                    setState(() {
                      widget.maintenanceFormModel.isElectricitySelected =
                      newValue!;
                    });
                  },
                ),
                _checkboxWithLabel(
                  "인터넷",
                  widget.maintenanceFormModel.isInternetSelected,
                      (newValue) {
                    setState(() {
                      widget.maintenanceFormModel.isInternetSelected =
                      newValue!;
                    });
                  },
                ),
                _checkboxWithLabel(
                  "난방",
                  widget.maintenanceFormModel.isHeatingSelected,
                      (newValue) {
                    setState(() {
                      widget.maintenanceFormModel.isHeatingSelected = newValue!;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _checkboxWithLabel(
      String label,
      bool value,
      ValueChanged<bool?>? onChanged,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // 수직 중앙 정렬
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            hoverColor: Colors.transparent,
            visualDensity: VisualDensity.compact, // 여백 조정
              overlayColor: WidgetStatePropertyAll(Colors.transparent),
              activeColor: Color(0xFF6B7280),
              side: BorderSide(color: Color(0xFF6B7280), width: 2)
          ),
          SizedBox(height: 24), // Checkbox와 Text 사이의 크기를 조정
          Text(
            label,
            style: TextStyle(fontSize: 14), // 텍스트 크기 조정
          ),
        ],
      ),
    );
  }

}
