import 'package:flutter/material.dart';
import 'custom_text_field.dart';

class CustomCheckboxGroup extends StatelessWidget {
  final String title;
  final List<String> options;
  final List<String> selectedValues;
  final void Function(List<String>) onChanged;
  final String? otherOption;
  final String? otherLabel;
  final TextEditingController? otherInputTextController;
  final double otherInputBoxWidth;

  const CustomCheckboxGroup({
    super.key,
    required this.title,
    required this.options,
    required this.selectedValues,
    required this.onChanged,
    this.otherOption,
    this.otherLabel,
    this.otherInputTextController,
    this.otherInputBoxWidth = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF374151),
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: options.map((option) {
                    return Row(
                      children: [
                        Checkbox(
                          value: selectedValues.contains(option),
                          onChanged: (bool? value) {
                            List<String> newSelectedValues = List.from(selectedValues);
                            if (value == true) {
                              if (!newSelectedValues.contains(option)) {
                                newSelectedValues.add(option);
                              }
                            } else {
                              newSelectedValues.remove(option);
                            }
                            onChanged(newSelectedValues);
                          },
                            overlayColor: WidgetStatePropertyAll(Colors.transparent),
                            activeColor: Color(0xFF6B7280),
                            side: BorderSide(color: Color(0xFF6B7280), width: 2)
                        ),
                        InkWell(
                          onTap: () {
                            List<String> newSelectedValues = List.from(selectedValues);
                            if (selectedValues.contains(option)) {
                              newSelectedValues.remove(option);
                            } else {
                              newSelectedValues.add(option);
                            }
                            onChanged(newSelectedValues);
                          },
                          child: Text(
                            option,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          if(otherOption != null && selectedValues.contains(otherOption))
            SizedBox(
              width: otherInputBoxWidth,
              child: CustomTextField(label: otherLabel!, controller: otherInputTextController!),
            ),
        ],
      ),
    );
  }
}