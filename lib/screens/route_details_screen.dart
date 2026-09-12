import 'package:flutter/material.dart';
import 'package:stride/widgets/item_app_bar_title.dart';
import 'package:stride/widgets/item_bottom_button.dart';

class RouteDetailsScreen extends StatelessWidget {
  const RouteDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(title: ItemAppBarTitle(data: "Lộ trình tập gym")),
        body: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Container(
                width: 183,
                height: 25,
                padding: EdgeInsets.symmetric(horizontal: 10),
                alignment: .center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: const Color(0xFFEEF4E5),
                ),
                child: Text(
                  "SỨC KHỎE & THỂ CHẤT",
                  style: TextStyle(
                    color: const Color(0xFF526C30),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "Tập luyện bền bỉ",
                style: TextStyle(
                  color: const Color(0xFF1C2520),
                  fontSize: 29,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "3 tháng tạo thói quen, từng bước tiến bộ.",
                style: TextStyle(
                  color: const Color(0xFF768079),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              // Khung anh
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 145,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/img_background.jpg'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: .end,
                  crossAxisAlignment: .start,
                  children: [
                    Container(
                      width: 157,
                      height: 25,
                      alignment: .center,
                      margin: EdgeInsets.only(left: 15, bottom: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        "17/08 – 17/11/2026",
                        style: TextStyle(
                          color: Color(0xFF1C2520),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Thoi gian tap luyen
              const SizedBox(height: 20),
              Container(
                height: 81,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Color(0xFFE8ECE8), width: 1),
                ),
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          "12 / 40",
                          style: TextStyle(
                            color: Color(0xFF1C2520),
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "buổi hoàn thành",
                          style: TextStyle(
                            color: Color(0xFF768079),
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          "3 buổi",
                          style: TextStyle(
                            color: Color(0xFF1C2520),
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Mỗi tuần",
                          style: TextStyle(
                            color: Color(0xFF768079),
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          "64",
                          style: TextStyle(
                            color: Color(0xFF1C2520),
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "ngày còn lại",
                          style: TextStyle(
                            color: Color(0xFF768079),
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Tabbar
              const SizedBox(height: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Container(
                      height: 42,
                      padding: EdgeInsets.all(5),
                      alignment: .center,
                      decoration: BoxDecoration(
                        color: Color(0xFFEBEEE9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TabBar(
                        dividerColor: Colors.transparent,
                        indicatorSize: TabBarIndicatorSize.tab,
                        overlayColor: WidgetStateProperty.all(
                          Colors.transparent,
                        ),
                        labelStyle: TextStyle(
                          color: Color(0xFF1C2520),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        unselectedLabelColor: Color(0xFF768079),
                        indicator: BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        tabs: [
                          Tab(text: "Tổng quan"),
                          Tab(text: "Lịch tập"),
                          Tab(text: "Nhật ký"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _OverView(),
                          Center(child: Text("Lịch tâp")),
                          Center(child: Text("Nhật ký")),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: ItemBottomButton(
          text: "Xem lịch tập",
          onTap: () {},
        ),
      ),
    );
  }
}

class _OverView extends StatelessWidget {
  const _OverView();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          "Cột mốc của bạn",
          style: TextStyle(
            color: Color(0xFF1C2520),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 15),
        Expanded(
          child: ListView(
            children: [
              _BuildTabViewContent(
                number: "01",
                title: "Xây dựng thói quen",
                timeLine: "17/08 – 16/09",
                inProgress: true,
              ),
              const SizedBox(height: 15),

              _BuildTabViewContent(
                number: "02",
                title: "Ổn định nhịp tập",
                timeLine: "17/09 – 16/10",
                inProgress: false,
              ),
              const SizedBox(height: 15),
              _BuildTabViewContent(
                number: "03",
                title: "Duy trì & đánh giá",
                timeLine: "17/10 – 17/11",
                inProgress: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BuildTabViewContent extends StatelessWidget {
  final String number;
  final String title;
  final String timeLine;
  final bool inProgress;

  const _BuildTabViewContent({
    required this.number,
    required this.title,
    required this.timeLine,
    this.inProgress = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .center,
      children: [
        SizedBox(
          width: 34,
          height: 34,
          child: CircleAvatar(
            backgroundColor: inProgress ? Color(0xFFEEF4E5) : Color(0xFFECEFEB),
            child: Text(
              number,
              style: TextStyle(
                color: inProgress ? Color(0xFF526C30) : Color(0xFF768079),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Color(0xFF1C2520),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                inProgress ? "$timeLine · Đang thực hiện" : timeLine,
                style: TextStyle(
                  color: Color(0xFF768079),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
