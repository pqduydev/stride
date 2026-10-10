import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  late String _selectedDropdownItem;
  DateTime _selectedDate = DateTime.now();

  // Danh sách lịch tập mẫu
  final List<ScheduleModel> _allSchedules = [
    ScheduleModel(
      id: '1',
      title: 'Thân trên & core',
      time: '18:00 – 19:00',
      reminderTime: '17:45',
      date: DateTime(2026, 9, 18),
    ),
    ScheduleModel(
      id: '2',
      title: 'Thân dưới & Cardio',
      time: '20:00 – 21:00',
      reminderTime: '19:45',
      date: DateTime(2026, 9, 19),
    ),
    ScheduleModel(
      id: '3',
      title: 'Thân trên & core',
      time: '18:00 – 19:00',
      reminderTime: '17:45',
      date: DateTime(2026, 9, 19),
    ),
    ScheduleModel(
      id: '4',
      title: 'Thân dưới & Cardio',
      time: '20:00 – 21:00',
      reminderTime: '19:45',
      date: DateTime(2026, 9, 19),
    ),
    ScheduleModel(
      id: '5',
      title: 'Thân trên & core',
      time: '18:00 – 19:00',
      reminderTime: '17:45',
      date: DateTime(2026, 9, 19),
    ),
    ScheduleModel(
      id: '6',
      title: 'Thân trên & core',
      time: '18:00 – 19:00',
      reminderTime: '17:45',
      date: DateTime(2026, 9, 19),
    ),
    ScheduleModel(
      id: '7',
      title: 'Chạy bộ bền bỉ',
      time: '06:00 – 07:00',
      reminderTime: '05:45',
      date: DateTime(2026, 9, 20),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedDropdownItem = 'appointment.dropdown_1'.tr();
  }

  @override
  Widget build(BuildContext context) {
    // Khởi tạo danh sách dropdown động theo ngôn ngữ hiện tại
    final listDropDown = [
      'appointment.dropdown_1'.tr(),
      'appointment.dropdown_2'.tr(),
      'appointment.dropdown_3'.tr(),
    ];

    if (!listDropDown.contains(_selectedDropdownItem)) {
      _selectedDropdownItem = listDropDown.first;
    }

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
        child: AppbarCustom(
          title: ItemAppBarTitle(
            data: 'appointment.appbar_title'.tr(),
            padding: 5,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: .start,
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
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
            sliver: SliverPersistentHeader(
              pinned: true,
              delegate: _BuildAppointmentCard(
                minHeight: 50,
                maxHeight: 50,
                child: Container(
                  color: const Color(0xFFF7F8FA),
                  child: Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text(
                        _formatLocalizedHeaderDate(_selectedDate),
                        style: const TextStyle(
                          color: Color(0xFF1C2520),
                          fontSize: 18,
                          fontWeight: .w700,
                        ),
                      ),
                      if (isToday)
                        Container(
                          width: 79,
                          height: 25,
                          alignment: .center,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEF4E5),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Text(
                            'appointment.today'.tr(),
                            style: const TextStyle(
                              color: Color(0xFF526C30),
                              fontSize: 11,
                              fontWeight: .w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(
              top: 5,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            sliver: SliverToBoxAdapter(
              child: schedulesOfSelectedDay.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Center(
                        child: Text(
                          'appointment.empty_schedules'.tr(),
                          style: const TextStyle(
                            color: Color(0xFF768079),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: schedulesOfSelectedDay.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = schedulesOfSelectedDay[index];
                        return _buildScheduleCard(item);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // Hàm định dạng ngày header tương thích đa ngôn ngữ
  String _formatLocalizedHeaderDate(DateTime date) {
    final weekdayKeys = [
      'appointment.weekdays.sun',
      'appointment.weekdays.mon',
      'appointment.weekdays.tue',
      'appointment.weekdays.wed',
      'appointment.weekdays.thu',
      'appointment.weekdays.fri',
      'appointment.weekdays.sat',
    ];
    final weekdayKey = weekdayKeys[date.weekday % 7];
    final weekday = weekdayKey.tr();
    final dayMonth = DateFormat('dd/MM').format(date);
    return '$weekday, $dayMonth';
  }

  Widget _buildScheduleCard(ScheduleModel item) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE8ECE8), width: 1),
      ),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Column(
            crossAxisAlignment: .start,
            children: [
              Row(
                crossAxisAlignment: .start,
                children: [
                  SvgPicture.asset(
                    'assets/icons/ic_dumbbell.svg',
                    width: 23,
                    height: 23,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          color: Color(0xFF1C2520),
                          fontSize: 16,
                          fontWeight: .w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.time,
                        style: const TextStyle(
                          color: Color(0xFF768079),
                          fontSize: 14,
                          fontWeight: .w400,
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
                    tr('appointment.reminder_at', args: [item.reminderTime]),
                    style: const TextStyle(
                      color: Color(0xFF768079),
                      fontSize: 13,
                      fontWeight: .w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SvgPicture.asset(
            'assets/icons/ic_chevron_right.svg',
            width: 20,
            height: 20,
          ),
        ],
      ),
    );
  }
}

class _BuildAppointmentCard extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _BuildAppointmentCard({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_BuildAppointmentCard oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
