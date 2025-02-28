import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final int? maxLines;
  final bool readOnly;
  final bool obscureText;
  final double? height;
  final double? width;
  final List<TextInputFormatter>? inputFormatters; // ✅ 추가
  final String suffixText;


  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType,
    this.maxLines,
    this.readOnly = false, // 기본값 설정
    this.obscureText = false, // 기본값 설정
    this.height,
    this.width,
    this.inputFormatters, // ✅ 추가
    this.suffixText = "",
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        height: height,
        width: width,
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          obscureText: obscureText,
          maxLines: maxLines ?? 1,
          inputFormatters: inputFormatters, // ✅ 적용
          style: TextStyle(
            fontSize: 16,
          ),
          decoration: InputDecoration(
            alignLabelWithHint: true,
            labelText: label,
            suffixText: suffixText.isNotEmpty ? " $suffixText" : null, // ✅ 단위 UI에 표시
            // 기본 테두리 (unfocused)
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFFD1D5DB), // 초록색 강조
                width: 2.0, // 포커스 없을 때 테두리 두께 2.0
              ),
            ),
            // 포커스 테두리 (focused)
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 3.0, // 포커스 상태 경계선 두께 3.0
              ),
            ),
            labelStyle: TextStyle(
              color: Color(0xFFD1D5DB), // 초록색 강조
            ),
          ),
        ),
      ),
    );
  }
}