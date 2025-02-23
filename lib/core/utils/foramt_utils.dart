import 'package:intl/intl.dart';

class FormatUtils{

  static String formatToYYYYMMDD(DateTime dateTime) {
    return DateFormat('yyyy.MM.dd').format(dateTime);
  }

  static String formatToYYYYmmDDHHMM(DateTime dateTime) {
    return DateFormat('yyyy.MM.dd HH:mm').format(dateTime);
  }

  static String formatPhoneNumber(String input) {
    // 숫자만 남기는 정규식
    return input.replaceAll(RegExp(r'[^0-9]'), '');
  }

}