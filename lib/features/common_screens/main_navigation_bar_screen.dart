import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:stride/core/theme/app_colors.dart';
import 'package:stride/features/appointment/screens/appointment_screen.dart';
import 'package:stride/features/diary/screen/diary_screen.dart';
import 'package:stride/features/reminder/screens/reminder_settings_screen.dart';
import 'package:stride/features/route/screens/my_route_screen.dart';
import 'package:stride/services/notification_router.dart';
import 'package:stride/services/notification_service.dart';

class MainNavigationBarScreen extends StatefulWidget {
  const MainNavigationBarScreen({super.key});

  @override
  State<MainNavigationBarScreen> createState() =>
      _MainNavigationBarScreenState();
}

class _MainNavigationBarScreenState extends State<MainNavigationBarScreen> {
  late int _selectedIndex;

  List<Widget> get _pages => const [
    MyRouteScreen(),
    AppointmentScreen(),
    DiaryScreen(),
    ReminderSettingsScreen(),
  ];

  @override
  void initState() {
    _selectedIndex = 0;
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final data = NotificationService.instance.consumeLaunchData();
      if (data != null && mounted) {
        openFromNotification(GoRouter.of(context), data);
      }
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildCuttomIconSvg({
    required String assetName,
    required bool isSelected,
    required AppColors colors,
  }) {
    return Container(
      width: 40,
      height: 28,
      alignment: .center,
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        color: isSelected ? colors.accent : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SvgPicture.asset(
        assetName,
        width: 21,
        height: 21,
        colorFilter: ColorFilter.mode(
          isSelected ? colors.onAccent : colors.muted,
          BlendMode.srcIn,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.locale;
    final colors = Theme.of(context).extension<AppColors>() ?? AppColors.light;

    final itemList = [
      _Items(
        assetName: "assets/icons/ic_layout_grid.svg",
        label: 'navigation.route'.tr(),
      ),
      _Items(
        assetName: "assets/icons/ic_calendar_days.svg",
        label: 'navigation.appointment'.tr(),
      ),
      _Items(
        assetName: "assets/icons/ic_diary.svg",
        label: 'navigation.diary'.tr(),
      ),
      _Items(
        assetName: "assets/icons/ic_bell.svg",
        label: 'navigation.reminder'.tr(),
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: SizedBox(
        height: 74,
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: colors.ink,
          unselectedItemColor: colors.muted,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: .w600),
          unselectedLabelStyle: const TextStyle(
            fontSize: 11,
            fontWeight: .w400,
          ),
          backgroundColor: colors.surface,
          items: [
            for (_Items item in itemList)
              BottomNavigationBarItem(
                icon: _buildCuttomIconSvg(
                  assetName: item.assetName,
                  isSelected: false,
                  colors: colors,
                ),
                activeIcon: _buildCuttomIconSvg(
                  assetName: item.assetName,
                  isSelected: true,
                  colors: colors,
                ),
                label: item.label,
              ),
          ],
        ),
      ),
    );
  }
}

class _Items {
  late String assetName;
  late String label;

  _Items({required this.assetName, required this.label});
}
