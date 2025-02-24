import 'package:flutter/material.dart';

import '../../core/enums/datepicker_type.dart';
import '../../core/utils/datepicker_utils.dart';


class CustomDatePicker extends StatefulWidget {
  final DatePickerType datePickerType;
  final String label;
  DateTime? selectedDateTime;
  final ValueChanged<DateTime?>? onChanged; // 콜백 추가

  DateTimeRange? range;

  CustomDatePicker({
    super.key,
    required this.datePickerType,
    required this.label,
    required this.selectedDateTime,
    this.onChanged,  // 콜백 매개변수 추가
    this.range,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  TextEditingController selectedDateText = TextEditingController();

  @override
  void initState() {
    super.initState();
    _updateDateText();
  }

  @override
  void didUpdateWidget(covariant CustomDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDateTime != widget.selectedDateTime) {
      _updateDateText(); // 새로운 값으로 업데이트
    }
  }

  /// 날짜 형식 업데이트
  void _updateDateText() {
    setState(() { // UI 변경 반영
      if (widget.selectedDateTime != null) {
        selectedDateText.text = _formatDate(widget.selectedDateTime!);
      } else {
        selectedDateText.text = "";
      }
    });
  }

  /// 날짜 선택 핸들러
  Future<void> _handleDateSelection() async {
    DateTime? selected;
    switch (widget.datePickerType) {
      case DatePickerType.year:
        selected = await DatePickerUtils.selectDate(context, widget.selectedDateTime);
        break;
      case DatePickerType.month:
        selected = await DatePickerUtils.selectYearMonth(context, widget.selectedDateTime);
        break;
      case DatePickerType.date:
        selected = await DatePickerUtils.selectDate(context, widget.selectedDateTime);
        break;
      case DatePickerType.datetime:
        selected = await DatePickerUtils.selectDateTime(context, widget.selectedDateTime);
        break;
      default:
        break;
    }

    if (selected != null) {
      widget.onChanged?.call(selected);
      setState(() {
        selectedDateText.text = _formatDate(selected!);
      });
    }
  }

  // 날짜 형식 포맷팅을 위한 헬퍼 메서드
  String _formatDate(DateTime date) {
    switch (widget.datePickerType) {
      case DatePickerType.year:
        return "${date.year}";
      case DatePickerType.month:
        return "${date.year}-${date.month.toString().padLeft(2, '0')}";
      case DatePickerType.date:
        return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      case DatePickerType.datetime:
        return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextField(
        controller: selectedDateText,
        readOnly: true,
        onTap: _handleDateSelection,
        decoration: InputDecoration(
          alignLabelWithHint: true,
          labelText: widget.label,
          border: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
              width: 3.0, // 포커스 상태 경계선 두께 3.0
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFFD1D5DB), // 초록색 강조
              width: 2.0, // 포커스 없을 때 테두리 두께 2.0
            ),
          ),
          labelStyle: TextStyle(
            color: Color(0xFFD1D5DB), // 초록색 강조
          ),
          suffixIcon: Icon(
            Icons.calendar_month,
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }
}

