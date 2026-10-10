import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:stride/features/diary/widgets/weekly_record_card.dart';
import 'package:stride/widgets/appbar_custom.dart';
import 'package:stride/widgets/item_app_bar_title.dart';
import 'package:stride/widgets/item_bottom_button.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppbarCustom(
          title: ItemAppBarTitle(data: 'diary.appbar_title'.tr(), padding: 5),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 0,
            left: 20,
            right: 20,
            bottom: 30,
          ),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              const SizedBox(height: 15),
              Text(
                'diary.subtitle'.tr(),
                style: const TextStyle(color: Color(0xFF768079), fontSize: 14),
              ),
              const SizedBox(height: 20),
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFEFEF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TabBar(
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    indicator: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    labelColor: const Color(0xFF1C2520),
                    unselectedLabelColor: const Color(0xFF768079),
                    labelStyle: const TextStyle(
                      fontWeight: .w600,
                      fontSize: 14,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: .w500,
                      fontSize: 14,
                    ),
                    tabs: [
                      Tab(text: 'diary.tabs.weekly'.tr()),
                      Tab(text: 'diary.tabs.monthly'.tr()),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              AnimatedBuilder(
                animation: _tabController,
                builder: (context, _) {
                  if (_tabController.index == 0) {
                    return _buildWeeklyView(() {
                      context.push('/add_image');
                    });
                  } else {
                    return _buildMonthlyView();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Nội dung Tab 1: "Theo tuần"
Widget _buildWeeklyView(VoidCallback onTap) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
    child: Column(
      crossAxisAlignment: .start,
      children: [
        Container(
          height: 100,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF202C25),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: .start,
            mainAxisAlignment: .center,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/ic_trending_up.svg',
                    width: 23,
                    height: 23,
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      'diary.weekly.banner_title'.tr(),
                      maxLines: 1, // Giới hạn đúng 1 dòng
                      overflow:
                          TextOverflow.ellipsis, // Cắt bớt và thêm dấu ...
                      style: const TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 18,
                        fontWeight: .w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'diary.weekly.banner_desc'.tr(),
                style: const TextStyle(color: Color(0xFFB5B8B6), fontSize: 14),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text(
              'diary.weekly.week_4_label'.tr(),
              style: const TextStyle(
                color: Color(0xFF1C2520),
                fontSize: 20,
                fontWeight: .w700,
              ),
            ),
            Text(
              'diary.weekly.week_4_date'.tr(),
              style: const TextStyle(
                color: Color(0xFF768079),
                fontSize: 12,
                fontWeight: .w400,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        WeeklyRecordCard(
          imagePath: 'assets/images/img_background.jpg',
          title: 'diary.weekly.week_4_title'.tr(),
          description: 'diary.weekly.week_4_desc'.tr(),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text(
              'diary.weekly.week_5_label'.tr(),
              style: const TextStyle(
                color: Color(0xFF1C2520),
                fontSize: 20,
                fontWeight: .w700,
              ),
            ),
            Text(
              'diary.weekly.week_5_date'.tr(),
              style: const TextStyle(
                color: Color(0xFF768079),
                fontSize: 12,
                fontWeight: .w400,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        ItemBottomButton(
          text: 'diary.weekly.btn_add_update'.tr(),
          onTap: onTap,
          backgroundColor: const Color(0xFFFFFFFF),
          textColor: const Color(0xFF526C30),
          borderColor: const Color(0xFFE8ECE8),
          borderWidth: 1,
        ),
      ],
    ),
  );
}

// Nội dung Tab 2: "Theo tháng"
Widget _buildMonthlyView() {
  return Center(
    child: Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Text(
        'diary.monthly.coming_soon'.tr(),
        style: const TextStyle(color: Colors.grey),
      ),
    ),
  );
}
