import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            tabs: const [
              Tab(text: 'Theo tuần'),
              Tab(text: 'Theo tháng'),
            ],
          ),
        ),

        const SizedBox(height: 16),

        TableCalendar(
          locale: 'vi_VN',
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

            // Thông báo cho màn hình cha là có sự thay đổi
            // và gửi kèm theo ngày đang được chọn
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

          // Custom lại các thứ trong tuần
          calendarBuilders: CalendarBuilders(
            headerTitleBuilder: (context, day) {
              return Row(
                mainAxisAlignment: .spaceBetween,
                crossAxisAlignment: .center,
                children: [
                  Text(
                    'Tháng ${day.month}, ${day.year}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
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
                DateTime.monday => 'T2',
                DateTime.tuesday => 'T3',
                DateTime.wednesday => 'T4',
                DateTime.thursday => 'T5',
                DateTime.friday => 'T6',
                DateTime.saturday => 'T7',
                DateTime.sunday => 'CN',
                _ => '',
              };
              return Center(
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Color(0xFF768079),
                    fontWeight: FontWeight.w500,
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
                // Giới hạn tối đa hiển thị 4 chấm để không bị tràn ô lịch
                final displayCount = workoutCount > 4 ? 4 : workoutCount;

                return Positioned(
                  bottom: 5,
                  child: Row(
                    mainAxisSize: .min, // Để Row thu nhỏ vừa bằng các dấu chấm
                    children: List.generate(
                      displayCount,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 1.5,
                        ), // Khoảng cách giữa các chấm
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
              fontWeight: FontWeight.w400,
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
                const Text(
                  'Có lịch tập',
                  style: TextStyle(color: Color(0xFF768079), fontSize: 13),
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
                const Text(
                  'Ngày nghỉ',
                  style: TextStyle(color: Color(0xFF768079), fontSize: 13),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
