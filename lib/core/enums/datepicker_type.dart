enum DatePickerType {
  year,
  month,
  monthRange,
  date,
  dateRange,
  datetime,
}

extension DatePickerTypeExtention on DatePickerType {
  String get name {
    switch (this) {
      case DatePickerType.year:
        return "년도";
      case DatePickerType.month:
        return "년월";
      case DatePickerType.monthRange:
        return "기간";
      case DatePickerType.date:
        return "일자";
      case DatePickerType.dateRange:
        return "기간";
      case DatePickerType.datetime:
        return "일시";
    }
  }
}