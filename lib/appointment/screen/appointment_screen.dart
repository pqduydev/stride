import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:stride/model/appointment_model.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:stride/widgets/appbar_custom.dart';
import 'package:stride/widgets/custom_appointment_calendar.dart';
import 'package:stride/widgets/item_app_bar_title.dart';
import 'package:stride/widgets/item_dropdown.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final List<String> listDropDown = const [
    'Tập luyện bền bỉ',
    'Thân trên & Core',
    'Thân dưới',
  ];

  String _selectedDropdownItem = 'Tập luyện bền bỉ';

  DateTime _selectedDate = DateTime.now();

  // Danh sách lịch tập
  final List<ScheduleModel> _allSchedules = [
    ScheduleModel(
      id: '1',
      title: 'Thân trên & core',
      time: '18:00 – 19:00',
      reminderTime: 'Nhắc lúc 17:45',
      date: DateTime(2026, 9, 18),
    ),
    ScheduleModel(
      id: '2',
      title: 'Thân dưới & Cardio',
      time: '20:00 – 21:00',
      reminderTime: 'Nhắc lúc 19:45',
      date: DateTime(2026, 9, 18),
    ),
    ScheduleModel(
      id: '3',
      title: 'Chạy bộ bền bỉ',
      time: '06:00 – 07:00',
      reminderTime: 'Nhắc lúc 05:45',
      date: DateTime(2026, 9, 20),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Lấy danh sách các ngày có lịch tập
    final workoutDays = _allSchedules.map((e) => e.date).toList();

    // Lọc ra các lịch tập thuộc ngày đang được chọn
    final schedulesOfSelectedDay = _allSchedules
        .where((item) => isSameDay(item.date, _selectedDate))
        .toList();

    // Check hiển thị item "Hôm nay"
    final isToday = isSameDay(_selectedDate, DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppbarCustom(title: ItemAppBarTitle(data: 'Lịch hẹn')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ItemDropdown(
              onItemChanged: (item) {
                setState(() => _selectedDropdownItem = item);
              },
              selectedItem: _selectedDropdownItem,
              listDropdown: listDropDown,
              icon: 'assets/icons/ic_dumbbell.svg',
            ),

            const SizedBox(height: 16),

            CustomScheduleCalendar(
              selectedDay: _selectedDate,
              workoutDays: workoutDays,
              onDaySelected: (date) {
                setState(() {
                  _selectedDate = date;
                });
              },
            ),

            const SizedBox(height: 20),
            const Divider(height: 1, color: Color(0xFFE8ECE8)),
            const SizedBox(height: 25),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatVietnameseHeaderDate(_selectedDate),
                  style: const TextStyle(
                    color: Color(0xFF1C2520),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                if (isToday)
                  Container(
                    width: 79,
                    height: 25,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF4E5),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: const Text(
                      'Hôm nay',
                      style: TextStyle(
                        color: Color(0xFF526C30),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 20),

            // Danh sách các thẻ bài tập
            if (schedulesOfSelectedDay.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Center(
                  child: Text(
                    'Không có lịch tập vào ngày này',
                    style: TextStyle(color: Color(0xFF768079), fontSize: 14),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap:
                    true, // Cho phép ListView nằm trong SingleChildScrollView
                physics: const NeverScrollableScrollPhysics(), // Ngăn tự cuộn
                itemCount: schedulesOfSelectedDay.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = schedulesOfSelectedDay[index];
                  return _buildScheduleCard(item);
                },
              ),
          ],
        ),
      ),
    );
  }

  // Hàm phụ trợ định dạng ngày thành chữ
  String _formatVietnameseHeaderDate(DateTime date) {
    // 0 -> 6
    final weekdayNames = [
      'Chủ Nhật',
      'Thứ Hai',
      'Thứ Ba',
      'Thứ Tư',
      'Thứ Năm',
      'Thứ Sáu',
      'Thứ Bảy',
    ];
    // date.weekday: 1 -> 7
    final weekday = weekdayNames[date.weekday % 7];
    final dayMonth = DateFormat('dd/MM').format(date);
    return '$weekday, $dayMonth';
  }

  // Hàm tạo thẻ tập lịch
  Widget _buildScheduleCard(ScheduleModel item) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE8ECE8), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    'assets/icons/ic_dumbbell.svg',
                    width: 23,
                    height: 23,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          color: Color(0xFF1C2520),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.time,
                        style: const TextStyle(
                          color: Color(0xFF768079),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/ic_bell.svg',
                    width: 16,
                    height: 16,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    item.reminderTime,
                    style: const TextStyle(
                      color: Color(0xFF768079),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SvgPicture.asset(
            'assets/icons/Ic_chevron_right.svg',
            width: 20,
            height: 20,
          ),
        ],
      ),
    );
  }
}
