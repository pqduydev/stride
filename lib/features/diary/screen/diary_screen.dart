import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:stride/features/diary/widgets/weekly_record_card.dart';
import 'package:stride/widgets/appbar_custom.dart';
import 'package:stride/widgets/item_app_bar_title.dart';
import 'package:stride/widgets/item_bottom_button.dart';

class DiaryScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Khởi tạo TabController với 2 tab
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
          title: ItemAppBarTitle(data: 'Nhật ký phát triển', padding: 5),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),

              // Subtitle
              Text(
                'Mỗi bước tiến đều đáng nhớ.',
                style: TextStyle(color: Color(0xFF768079), fontSize: 14),
              ),

              const SizedBox(height: 20),

              // Container bao bọc TabBar
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
                  const Text(
                    '4 tuần giữ nhịp',
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 18,
                      fontWeight: .w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                '12 buổi tập đã hoàn thành',
                style: TextStyle(color: Color(0xFFB5B8B6), fontSize: 14),
              ),
            ],
          ),
        ),

        const SizedBox(height: 30),

        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text(
              'Tuần 4',
              style: TextStyle(
                color: Color(0xFF1C2520),
                fontSize: 20,
                fontWeight: .w700,
              ),
            ),
            Text(
              '07 – 13/09',
              style: TextStyle(
                color: Color(0xFF768079),
                fontSize: 12,
                fontWeight: .w400,
              ),
            ),
          ],
        ),

        const SizedBox(height: 15),

        const WeeklyRecordCard(
          imagePath: 'assets/images/img_background.jpg',
          title: 'Đều đặn hơn mỗi tuần',
          description: 'Đã hoàn thành 3 buổi tập. Cảm thấy thoải mái hơn với lịch tập mới.',
        ),

        const SizedBox(height: 30),

        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text(
              'Tuần 5',
              style: TextStyle(
                color: Color(0xFF1C2520),
                fontSize: 20,
                fontWeight: .w700,
              ),
            ),
            Text(
              '14 – 20/09',
              style: TextStyle(
                color: Color(0xFF768079),
                fontSize: 12,
                fontWeight: .w400,
              ),
            ),
          ],
        ),

        const SizedBox(height: 15),

        ItemBottomButton(
          text: '+  Thêm ảnh & cập nhật',
          onTap: onTap,
          backgroundColor: Color(0xFFFFFFFF),
          textColor: Color(0xFF526C30),
          borderColor: Color(0xFFE8ECE8),
          borderWidth: 1,
        ),
      ],
    ),
  );
}

// Nội dung Tab 2: "Theo tháng"
Widget _buildMonthlyView() {
  return const Center(
    child: Padding(
      padding: EdgeInsetsGeometry.only(top: 40),
      child: Text(
        'Nội dung "Theo tháng" sẽ được thêm sau',
        style: TextStyle(color: Colors.grey),
      ),
    ),
  );
}
