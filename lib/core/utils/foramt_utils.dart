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

  static String formatCurrency(int amount) {
    if (amount == 0) return "0원";

    int billion = amount ~/ 100000000; // 억 단위
    int million = (amount % 100000000) ~/ 10000; // 만 단위
    int thousand = amount % 10000; // 1만 미만 단위

    String result = "";

    if (billion > 0) {
      result += "${billion}억 ";
    }
    if (million > 0) {
      result += "${NumberFormat("#,###").format(million)}만 "; // 만 단위에 쉼표 추가
    }
    if (thousand > 0) {
      result += "${NumberFormat("#,###").format(thousand)}"; // 천 이하 단위에도 쉼표 추가
    }

    return result.trim() + "원";
  }

  // 3자리마다 , 추가
  String formatNumberWithCommas(String input) {
    if (input.isEmpty) return "";
    final number = int.tryParse(input.replaceAll(',', ''));
    if (number == null) return "";
    final formatter = NumberFormat("#,###");
    return formatter.format(number);
  }

}