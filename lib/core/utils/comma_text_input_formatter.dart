import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CommaTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // 입력값이 비어 있으면 그대로 반환 (백스페이스 눌렀을 때 삭제 가능)
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // 쉼표 제거 후 숫자로 변환
    final newText = newValue.text.replaceAll(',', '');
    final number = int.tryParse(newText);

    // 숫자가 아닐 경우 기존 값 유지 (예: 사용자가 잘못된 문자를 입력한 경우)
    if (number == null) {
      return oldValue;
    }

    // 3자리마다 , 추가
    final formatter = NumberFormat("#,###");
    final formattedText = formatter.format(number);

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
