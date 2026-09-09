import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:stride/widgets/item_card_switch.dart';

class MyRouteScreen extends StatelessWidget {
  const MyRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        shadowColor: Colors.transparent,
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisAlignment: .spaceBetween,
            crossAxisAlignment: .center,
            children: [
              SizedBox(
                width: 135,
                height: 39.15,
                child: Stack(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/ic_logo.svg',
                      height: 29,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF1C2520),
                        BlendMode.srcIn,
                      ),
                    ),

                    Positioned(
                      top: -5,
                      right: 0,
                      child: SvgPicture.asset(
                        'assets/icons/ic_arrow_up_right.svg',
                        width: 28,
                        height: 28,
                      ),
                    ),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 21,
                backgroundColor: const Color(0xFFE7EDD9),
                child: Text(
                  "TA",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF526C30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 30),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "THỨ HAI, 14 THÁNG 9",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF768079),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: .spaceBetween,
                crossAxisAlignment: .center,
                children: [
                  Text(
                    "Lộ trình của tôi",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1C2520),
                    ),
                  ),
                  CircleAvatar(
                    radius: 21,
                    backgroundColor: Color(0xFFD2F36B),
                    child: Icon(Icons.add, color: Color(0xFF1C2520)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  border: Border.all(
                    color: const Color(0xFFE8ECE8),
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                ),
                child: InkWell(
                  onTap: () => context.push("/route_details"),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 140,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage(
                              'assets/images/img_background.jpg',
                            ),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF202C25).withValues(alpha: 0.64),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
                            child: Column(
                              crossAxisAlignment: .start,
                              mainAxisAlignment: .spaceBetween,
                              children: [
                                Container(
                                  width: 151,
                                  height: 25,
                                  alignment: .center,
                                  padding: EdgeInsets.only(left: 10),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFD2F36B),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(6),
                                    ),
                                  ),
                                  child: Text(
                                    "MỤC TIÊU 3 THÁNG",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF1C2520),
                                        ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                SizedBox(
                                  child: Column(
                                    crossAxisAlignment: .start,
                                    children: [
                                      Text(
                                        "Tập luyện bền bỉ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              color: Color(0xFFFFFFFF),
                                              fontSize: 25,
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "17/08 - 17/11/2026",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                              color: Color(0xFFE4EBE3),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            Row(
                              mainAxisAlignment: .spaceBetween,
                              crossAxisAlignment: .center,
                              children: [
                                Text(
                                  "Đã hoàn thành",
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        color: Color(0xFF768079),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                      ),
                                ),
                                Text(
                                  "12 / 40 buổi",
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        color: Color(0xFF1C2520),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 13),
                            Container(
                              height: 7,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color(0xFFE8ECE8),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              child: FractionallySizedBox(
                                alignment: .centerLeft,
                                widthFactor: 0.37,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFF526C30),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 13),
                            Row(
                              mainAxisAlignment: .spaceBetween,
                              crossAxisAlignment: .center,
                              children: [
                                Text(
                                  "Tuần 5",
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        color: Color(0xFF768079),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                      ),
                                ),
                                Text(
                                  "30%",
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        color: Color(0xFF526C30),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text(
                        "Hôm nay",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1C2520),
                        ),
                      ),
                      Text(
                        "Xem lịch",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF526C30),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 135,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border: Border.all(
                        color: const Color(0xFFE8ECE8),
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 5,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0xFFD2F36B),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(5),
                              bottom: Radius.circular(5),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: .spaceAround,
                            crossAxisAlignment: .start,
                            children: [
                              Row(
                                mainAxisAlignment: .spaceBetween,
                                crossAxisAlignment: .center,
                                children: [
                                  Text(
                                    "18:00",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(
                                          color: Color(0xFF1C2520),
                                          fontSize: 23,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                  Container(
                                    width: 88,
                                    height: 25,
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF7F8FA),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(7),
                                      ),
                                    ),
                                    child: Text(
                                      "60 phút",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(
                                            color: Color(0xFF768079),
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "Thân trên & core",
                                style: Theme.of(context).textTheme.labelLarge
                                    ?.copyWith(
                                      color: Color(0xFF1C2520),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset('assets/icons/ic_bell.svg'),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Nhắc trước 15 phút",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(
                                          color: Color(0xFF768079),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    crossAxisAlignment: .center,
                    children: [
                      Text(
                        "Nhìn lại hành trình",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Color(0xFF1C2520),
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SvgPicture.asset(
                        'assets/icons/ic_arrow_up_right.svg',
                        width: 20,
                        height: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 89,
                    child: Row(
                      children: [
                        Container(
                          width: 98,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'assets/images/img_background.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color(0xFFFFFFFF),
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: .start,
                              mainAxisAlignment: .spaceBetween,
                              children: [
                                Container(
                                  width: 69,
                                  height: 25,
                                  alignment: .center,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFEEF4E5),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(7),
                                    ),
                                  ),
                                  child: Text(
                                    "TUẦN 4",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                          color: Color(0xFF526C30),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ),
                                Text(
                                  "Đều đặn hơn mỗi tuần",
                                  style: Theme.of(context).textTheme.labelMedium
                                      ?.copyWith(
                                        color: Color(0xFF1C2520),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                Text(
                                  "3 buổi tập · 1 cập nhật",
                                  style: Theme.of(context).textTheme.labelMedium
                                      ?.copyWith(
                                        color: Color(0xFF768079),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              ItemCardSwitch(),
            ],
          ),
        ),
      ),
    );
  }
}
