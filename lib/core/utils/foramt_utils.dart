import 'package:intl/intl.dart';

class FormatUtils{

  static String formatToYYYYMMDD(DateTime dateTime) {
    return DateFormat('yyyy.MM.dd').format(dateTime);
  }

  static String formatToYYYYmmDDHHMM(DateTime dateTime) {
    return DateFormat('yyyy.MM.dd HH:mm').format(dateTime);
  }

  static String formatToYYYYmmDDHHMM_forAPI(DateTime dateTime) {
    return DateFormat('yyyyMMddHHmm').format(dateTime);
  }

  static String formatToYYYYmmDD_forAPI(DateTime dateTime) {
    return DateFormat('yyyyMMdd').format(dateTime);
  }

  static String formatToYYYYmm_forAPI(DateTime dateTime) {
    return DateFormat('yyyyMM').format(dateTime);
  }

  static String formatPhoneNumber(String input) {
    // 숫자만 남기는 정규식
    return input.replaceAll(RegExp(r'[^0-9]'), '');
  }

  static String formatToHHMM_forCalendar(DateTime dateTime) {
    return DateFormat('HH시 mm분').format(dateTime);
  }
}