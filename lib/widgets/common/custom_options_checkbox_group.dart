import 'package:flutter/material.dart';

class CustomCheckboxGroup2 extends StatefulWidget {
  final String title;
  final List<String> options;
  final List<bool> initialSelection;
  final void Function(List<bool>) onChanged;

  const CustomCheckboxGroup2({
    super.key,
    required this.title,
    required this.options,
    required this.initialSelection,
    required this.onChanged,
  });

  @override
  State<CustomCheckboxGroup2> createState() => _CustomCheckboxGroupState();
}

class _CustomCheckboxGroupState extends State<CustomCheckboxGroup2> {
  late List<bool> _selections;

  @override
  void initState() {
    super.initState();
    _selections = List.from(widget.initialSelection);
  }

  void _updateSelections(int index, bool value) {
    setState(() {
      if (index == 0) {
        for (int i = 0; i < _selections.length; i++) {
          _selections[i] = value;
        }
      } else {
        _selections[index] = value;
        // 다른 항목 체크 해제되면 "풀옵션"도 해제
        if (!value) {
          _selections[0] = false;
        } else if (_selections.sublist(1).every((element) => element)) {
          // 모든 개별 항목이 체크되면 "풀옵션" 자동 체크
          _selections[0] = true;
        }
      }
      widget.onChanged(_selections);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF374151),
                    ),
                  ),
                  SizedBox(width: 8),
                  Tooltip(
                    message: "풀옵션을 선택하시면 전체 선택 됩니다.",
                    child: Icon(
                      Icons.info_outline, // 툴팁 아이콘
                      size: 20,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 16,
                children: List.generate(widget.options.length, (index) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: _selections[index],
                        onChanged: (value) =>
                            _updateSelections(index, value ?? false),
                          overlayColor: WidgetStatePropertyAll(Colors.transparent),
                          activeColor: Color(0xFF6B7280),
                          side: BorderSide(color: Color(0xFF6B7280), width: 2)
                      ),
                      Text(
                          widget.options[index],
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 16),
                    ],
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
