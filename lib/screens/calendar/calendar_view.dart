import 'package:flutter/material.dart';
import 'package:property_service_web_ver2/core/enums/screen_type.dart';
import 'package:property_service_web_ver2/core/utils/toast_manager.dart';
import 'package:property_service_web_ver2/model/calendar/schedule_model.dart';
import 'package:property_service_web_ver2/widgets/common/card_widget.dart';
import 'package:property_service_web_ver2/widgets/common/sub_layout.dart';
import 'package:provider/provider.dart';

import 'package:table_calendar/table_calendar.dart';
import 'dart:math';
import 'package:intl/intl.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/foramt_utils.dart';
import '../../model/calendar/calendar_event_model.dart';
import '../../service/calendar/calendar_service.dart';
import '../../widgets/common/rotating_house_indicator.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
    return SubLayout(screenType: ScreenType.Calendar, child: CalendarView());
  }
}

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late LoadingState loadingState;
  Map<DateTime, List<String>> _events = {};
  List<Schedule> _selectedDateScheduleList = [];
  final CalendarService _calendarService = CalendarService();

  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    loadingState = Provider.of<LoadingState>(context, listen: false);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadingState = Provider.of<LoadingState>(context, listen: false);
      _fetchEvents();
      _searchSelectedDateSchedule();
    });
  }

  Future<void> _fetchEvents() async {
    try {   // todo 한달 내 일정 조회 api 개발 및 연결
      loadingState.setLoading(true);

      List<CalendarEvent> events = await _calendarService.fetchEvents(FormatUtils.formatToYYYYmm_forAPI(_focusedDay));
      Map<DateTime, List<String>> eventMap = {
        for (var e in events) normalizeDate(e.date): e.types
      };

      setState(() {
        _events = eventMap;
      });

    } catch (e) {
      print("Failed to fetch events: $e");
    } finally {
      loadingState.setLoading(false);
    }
  }

  Future<void> _searchSelectedDateSchedule() async {
    try {
      loadingState.setLoading(true);

      List<Schedule> schedules = await _calendarService.searchSelectedDateSchedule(FormatUtils.formatToYYYYmmDD_forAPI(_selectedDay));
      setState(() {
        _selectedDateScheduleList = schedules;
      });

    } catch (e) {
      print("❌ Error: $e");
    } finally {
      loadingState.setLoading(false);
    }
  }

  void changeScheduleStatus({required int scheduleId, required bool complete}) async {
    try {
      loadingState.setLoading(true);
      await _calendarService.updateScheduleCompleted(scheduleId: scheduleId, complete: complete);
      ToastManager().showToast(context, "일정 상태가 업데이트 되었습니다.");
      await _searchSelectedDateSchedule();
    } catch (e) {
      print("❌ 오류 발생: $e");
    } finally {
      loadingState.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 720,
              height: 648,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(32),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TableCalendar(
                locale: "ko_KR",
                firstDay: DateTime.utc(1900, 1, 1),
                lastDay: DateTime.utc(2100, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: CalendarFormat.month,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  _searchSelectedDateSchedule(); // ✅ 선택된 날짜 변경 시 일정 검색
                },
                onPageChanged: (focusedDay) {
                  setState(() {
                    _focusedDay = focusedDay; // ✅ 새로운 달로 이동했을 때 focusedDay 업데이트
                  });
                  _fetchEvents(); // ✅ 현재 보고 있는 달이 변경되면 일정 다시 조회
                },
                availableGestures: AvailableGestures.none,

                // eventLoader: _getEventsForDay,
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                  headerMargin: EdgeInsets.symmetric(vertical: 8),
                  titleTextStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                  leftChevronIcon: Icon(
                      Icons.chevron_left,
                    size: 36,
                  ),
                  rightChevronIcon: Icon(
                      Icons.chevron_right,
                    size: 36,
                  )
                ),

                daysOfWeekHeight: 60,
                rowHeight: 80,

                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                  weekendStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                calendarStyle: CalendarStyle(
                  defaultTextStyle: TextStyle(
                    fontSize: 14,  // 날짜 숫자 크기 키우기
                  ),
                  weekendTextStyle: TextStyle(
                    fontSize: 14,  // 주말 날짜 크기 키우기
                  ),
                  outsideTextStyle: TextStyle(
                    fontSize: 14,  // 달력 밖(이전/다음 달) 날짜 크기
                    color: Colors.grey, // 흐린 색상으로 표시
                  ),

                  selectedDecoration: BoxDecoration(
                    color: Color(0xFFE5E7EB),
                    // borderRadius: BorderRadius.circular(10),
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle: TextStyle(
                    color: Colors.black,
                  ),
                ),


                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    List<String>? eventTypes = _events[date] ?? [];
                    if (eventTypes.isNotEmpty) {
                      Map<String, Color> typeColors = {
                        "상담": Color(0xFF22C55E),
                        "계약": Color(0xFFEF4444),
                        "입주": Color(0xFF3B82F6),
                      };
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(height: 32), // 날짜와 막대 사이 간격 조정
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: eventTypes.map((type) {
                              return Container(
                                width: 18, // 막대 길이
                                height: 4, // 막대 두께
                                margin: EdgeInsets.symmetric(horizontal: 2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: typeColors[type] ?? Colors.grey,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      );
                    }
                    return null;
                  },
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              width: 720,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(32),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildLegendItem(Color(0xFF22C55E), "상담"),
                    SizedBox(width: 16),
                    _buildLegendItem(Color(0xFFEF4444), "계약"),
                    SizedBox(width: 16),
                    _buildLegendItem(Color(0xFF3B82F6), "입주"),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(width: 32),
        CardWidget(
          width: 720,
          title:  "${_selectedDay.year.toString()}년 ${_selectedDay.month}월 ${_selectedDay.day}일 일정",
            child: SizedBox(
              height: 604,
              child: ListView.builder(
                itemCount: _selectedDateScheduleList.length,
                itemBuilder: (context, index) {
                  return _buildScheduleItem(_selectedDateScheduleList[index]);
                },
              ),
            )
        ),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildScheduleItem(Schedule schedule) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                      value: schedule.isCompleted,
                      onChanged: (value) => changeScheduleStatus(scheduleId: schedule.scheduleId, complete: value!),
                      overlayColor: WidgetStatePropertyAll(Colors.transparent),
                      activeColor: Color(0xFF6B7280),
                      side: BorderSide(color: Color(0xFF6B7280), width: 2)
                  ),
                  Text(
                    FormatUtils.formatToHHMM_forCalendar(schedule.scheduleDate),
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF4B5563),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: getScheduleBackGroundColor(schedule.scheduleType),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                      schedule.scheduleType,
                    style: TextStyle(
                      fontSize: 16,
                      color: getScheduleTextColor(schedule.scheduleType)
                    ),
                  ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Checkbox(
                  value: false,
                  onChanged: (value){},
                  overlayColor: WidgetStatePropertyAll(Colors.transparent),
                  side: BorderSide(color: Colors.white, width: 2),
              ),
              Text(
                "${schedule.picUserName} / ${schedule.clientName}",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF4B5563),
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Checkbox(
                  value: false,
                  onChanged: (value){},
                  overlayColor: WidgetStatePropertyAll(Colors.transparent),
                  side: BorderSide(color: Colors.white, width: 2)
              ),
              Text(
                schedule.scheduleRemark,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Color getScheduleBackGroundColor(String scheduleType) {
    switch (scheduleType) {
      case "상담":
        return Color(0xFFDCFCE7);
      case "계약":
        return Color(0xFFFEE2E2);
      case "입주":
        return Color(0xFFDBEAFE);
      default:
        return Colors.grey; // ✅ 기본값 추가
    }
  }

  Color getScheduleTextColor(String scheduleType) {
    switch (scheduleType) {
      case "상담":
        return Color(0xFF16A34A);
      case "계약":
        return Color(0xFFDC2626);
      case "입주":
        return Color(0xFF2563EB);
      default:
        return Colors.grey; // ✅ 기본값 추가
    }
  }

}

