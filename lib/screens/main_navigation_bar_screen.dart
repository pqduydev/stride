import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stride/screens/appointment_reminder_screen.dart';
import 'package:stride/screens/appointment_screen.dart';
import 'package:stride/screens/diary_screen.dart';
import 'package:stride/route/screen/my_route_screen.dart';

class MainNavigationBarScreen extends StatefulWidget {
  const MainNavigationBarScreen({super.key});

  @override
  State<MainNavigationBarScreen> createState() =>
      _MainNavigationBarScreenState();
}

class _MainNavigationBarScreenState extends State<MainNavigationBarScreen> {
  late int _selectedIndex;

  final _pages = [
    MyRouteScreen(),
    AppointmentScreen(),
    DiaryScreen(),
    AppointmentReminderScreen(),
  ];

  @override
  void initState() {
    _selectedIndex = 0;
    super.initState();
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildCuttomIconSvg({
    required String assetName,
    required bool isSelected,
  }) {
    return Container(
      width: 40,
      height: 28,
      alignment: .center,
      margin: EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFD2F36B) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SvgPicture.asset(
        assetName,
        width: 21,
        height: 21,
        colorFilter: ColorFilter.mode(
          isSelected ? const Color(0xFF1C2520) : const Color(0xFF8E8E93),
          BlendMode.srcIn,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: SizedBox(
        height: 74,
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF1C2520),
          unselectedItemColor: const Color(0xFF8E8E93),
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w400,
          ),
          backgroundColor: Color(0xFFFFFFFF),
          items: [
            BottomNavigationBarItem(
              icon: _buildCuttomIconSvg(
                assetName: 'assets/icons/ic_layout_grid.svg',
                isSelected: false,
              ),
              activeIcon: _buildCuttomIconSvg(
                assetName: 'assets/icons/ic_layout_grid.svg',
                isSelected: true,
              ),
              label: "Lộ trình",
            ),
            BottomNavigationBarItem(
              icon: _buildCuttomIconSvg(
                assetName: 'assets/icons/ic_calendar_days.svg',
                isSelected: false,
              ),
              activeIcon: _buildCuttomIconSvg(
                assetName: 'assets/icons/ic_calendar_days.svg',
                isSelected: true,
              ),
              label: "Lịch hẹn",
            ),
            BottomNavigationBarItem(
              icon: _buildCuttomIconSvg(
                assetName: 'assets/icons/ic_diary.svg',
                isSelected: false,
              ),
              activeIcon: _buildCuttomIconSvg(
                assetName: 'assets/icons/ic_diary.svg',
                isSelected: true,
              ),
              label: "Nhật ký",
            ),
            BottomNavigationBarItem(
              icon: _buildCuttomIconSvg(
                assetName: 'assets/icons/ic_bell.svg',
                isSelected: false,
              ),
              activeIcon: _buildCuttomIconSvg(
                assetName: 'assets/icons/ic_bell.svg',
                isSelected: true,
              ),
              label: "Nhắc hẹn",
            ),
          ],
        ),
      ),
    );
  }
}
