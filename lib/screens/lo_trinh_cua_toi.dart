import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LoTrinhCuaToi extends StatelessWidget {
  const LoTrinhCuaToi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                      'assets/icons/logo.svg',
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
                        'assets/icons/arrow_up_right.svg',
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 153,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/background.jpg'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
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
                            padding: EdgeInsets.only(
                              left: 10,
                              right: 30,
                              top: 5,
                              bottom: 5,
                            ),
                            decoration: const BoxDecoration(
                              color: Color(0xFFD2F36B),
                              borderRadius: BorderRadius.all(
                                Radius.circular(6),
                              ),
                            ),
                            child: Text(
                              "MỤC TIÊU 3 THÁNG",
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1C2520),
                                  ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            child: Column(
                              crossAxisAlignment: .start,
                              children: [
                                Text(
                                  "Tập luyện bền bỉ",
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontSize: 26,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "17/08 - 17/11/2026",
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontSize: 11,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                            borderRadius: BorderRadius.all(Radius.circular(5)),
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
          ],
        ),
      ),
    );
  }
}
