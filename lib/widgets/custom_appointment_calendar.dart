import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomScheduleCalendar extends StatefulWidget {
  final DateTime selectedDay; // Ngày đang được chọn
  final List<DateTime> workoutDays; // Danh sách các ngày có lịch tập
  final Function(DateTime) onDaySelected; // Callback cập nhật ngày được chọn

  const CustomScheduleCalendar({
    super.key,
    required this.selectedDay,
    required this.workoutDays,
    required this.onDaySelected,
  });

  @override
  State<CustomScheduleCalendar> createState() => _CustomScheduleCalendarState();
}

class _CustomScheduleCalendarState extends State<CustomScheduleCalendar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.selectedDay;
    _selectedDay = widget.selectedDay;

    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _calendarFormat = _tabController.index == 0
              ? CalendarFormat.week
              : CalendarFormat.month;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // TabBar
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFEFEFE9),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(4),
          child: TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            indicator: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            labelColor: const Color(0xFF1C2520),
            unselectedLabelColor: const Color(0xFF768079),
            labelStyle: const TextStyle(fontWeight: .w600, fontSize: 14),
            unselectedLabelStyle: const TextStyle(
              fontWeight: .w500,
              fontSize: 14,
            ),
            tabs: [
              Tab(text: 'calendar.tab_week'.tr()),
              Tab(text: 'calendar.tab_month'.tr()),
            ],
          ),
        ),

        const SizedBox(height: 16),

        TableCalendar(
          locale: context.locale.toString(),
          firstDay: DateTime.utc(2026, 1, 1),
          lastDay: DateTime.utc(2050, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          startingDayOfWeek: StartingDayOfWeek.monday,

          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
              _tabController.animateTo(format == CalendarFormat.week ? 0 : 1);
            });
          },

          // Đánh dấu ngày đã chọn, chỉ chọn được 1 ngày tại cùng thời điểm
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),

          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });

            widget.onDaySelected(selectedDay);
          },

          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            leftChevronVisible: false,
            rightChevronVisible: false,
            headerPadding: EdgeInsets.zero,
            headerMargin: EdgeInsets.only(bottom: 10, top: 5),
          ),

          daysOfWeekHeight: 35,
          rowHeight: 45,

          // Custom lại các thứ trong tuần và tiêu đề lịch
          calendarBuilders: CalendarBuilders(
            headerTitleBuilder: (context, day) {
              final formattedMonthYear = DateFormat(
                'MMMM yyyy',
                context.locale.languageCode,
              ).format(day);

              return Row(
                mainAxisAlignment: .spaceBetween,
                crossAxisAlignment: .center,
                children: [
                  Text(
                    formattedMonthYear,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: .w700,
                      color: Color(0xFF1C2520),
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/icons/ic_calendar_days.svg',
                    width: 20,
                    height: 20,
                  ),
                ],
              );
            },

            dowBuilder: (context, day) {
              final text = switch (day.weekday) {
                DateTime.monday => 'calendar.dow.mon'.tr(),
                DateTime.tuesday => 'calendar.dow.tue'.tr(),
                DateTime.wednesday => 'calendar.dow.wed'.tr(),
                DateTime.thursday => 'calendar.dow.thu'.tr(),
                DateTime.friday => 'calendar.dow.fri'.tr(),
                DateTime.saturday => 'calendar.dow.sat'.tr(),
                DateTime.sunday => 'calendar.dow.sun'.tr(),
                _ => '',
              };
              return Center(
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Color(0xFF768079),
                    fontWeight: .w500,
                    fontSize: 12,
                  ),
                ),
              );
            },

            // Thêm dấu chấm dưới những ngày có lịch tập
            markerBuilder: (context, day, events) {
              final workoutCount = widget.workoutDays
                  .where((d) => isSameDay(d, day))
                  .length;

              if (workoutCount > 0) {
                final displayCount = workoutCount > 4 ? 4 : workoutCount;

                return Positioned(
                  bottom: 5,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      displayCount,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 1.5),
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                          color: Color(0xFF526C30),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                );
              }

              return null;
            },
          ),

          calendarStyle: const CalendarStyle(
            selectedDecoration: BoxDecoration(
              color: Color(0xFF1C2520),
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(color: Colors.transparent),
            todayTextStyle: TextStyle(
              color: Color(0xFF1C2520),
              fontSize: 14,
              fontWeight: .w400,
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Chú thích
        Row(
          children: [
            Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFF526C30),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'calendar.has_workout'.tr(),
                  style: const TextStyle(
                    color: Color(0xFF768079),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 30),
            Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD2C9),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'calendar.rest_day'.tr(),
                  style: const TextStyle(
                    color: Color(0xFF768079),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
