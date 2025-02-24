import 'package:flutter/material.dart';
import 'custom_text_field.dart';

class CustomRadioGroup extends StatelessWidget {
  final String title;
  final List<String> options;
  final String? groupValue;
  final void Function(String?) onChanged;
  final String? otherInput;
  final String? otherLabel;
  final TextEditingController? otherInputTextController;
  final double otherInputBoxWidth;

  const CustomRadioGroup({
    super.key,
    required this.title,
    required this.options,
    required this.groupValue,
    required this.onChanged,
    this.otherInput,
    this.otherLabel,
    this.otherInputTextController,
    this.otherInputBoxWidth = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          SizedBox(
            height: otherInputTextController == null ? null : 64,
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
                        Radio<String>(
                          value: option,
                          groupValue: groupValue,
                          onChanged: onChanged,
                          overlayColor: WidgetStatePropertyAll(Colors.transparent),
                          activeColor: Color(0xFF6B7280),
                        ),
                        InkWell(
                          onTap: () {
                            onChanged(option);
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
          if(otherInput != null && otherInput == groupValue)
            SizedBox(
                width: otherInputBoxWidth,
                child: CustomTextField(label: otherLabel!, controller: otherInputTextController!),
            ),
        ],
      ),
    );
  }
}
