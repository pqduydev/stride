import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:stride/widgets/item_bottom_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

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
                    SvgPicture.asset('assets/icons/ic_stride.svg', height: 28),
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

              Container(
                width: 103,
                height: 25,
                alignment: .center,
                decoration: BoxDecoration(
                  color: Color(0xFFEEF4E5),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(
                  'CÙNG BẠN',
                  style: TextStyle(
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

      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.only(top: 40, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                'Mỗi mục tiêu.\nMột hành trình.',
                style: TextStyle(
                  color: Color(0xFF1C2520),
                  fontSize: 34,
                  fontWeight: .w700,
                ),
              ),

              const SizedBox(height: 15),
              Text(
                'Lên kế hoạch, giữ đúng hẹn và nhận\ngợi ý phù hợp với tiến trình của bạn.',
                style: TextStyle(
                  color: Color(0xFF768079),
                  fontSize: 15,
                  fontWeight: .w400,
                ),
              ),

              const SizedBox(height: 25),
              Container(
                width: double.infinity,
                height: 200,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFF202C25),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          alignment: .center, // Phải có để icon không bị ép kích thước bởi Container
                          margin: EdgeInsets.only(right: 15),
                          decoration: BoxDecoration(
                            color: Color(0xFF526C30),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/ic_graduation_cap.svg',
                            width: 20,
                            height: 20,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: .start,
                          children: [
                            Text(
                              'Học thêm điều mới',
                              style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 15,
                                fontWeight: .w600,
                              ),
                            ),
                            Text(
                              'Bài học, cột mốc & thành quả',
                              style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 12,
                                fontWeight: .w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          alignment: .center, // Phải có để icon không bị ép kích thước bởi Container
                          margin: EdgeInsets.only(right: 15),
                          decoration: BoxDecoration(
                            color: Color(0xFF526C30),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/ic_stethoscope.svg',
                            width: 20,
                            height: 20,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: .start,
                          children: [
                            Text(
                              'Chủ động theo dõi điều trị',
                              style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 15,
                                fontWeight: .w600,
                              ),
                            ),
                            Text(
                              'Lịch hẹn, ghi nhận & hồ sơ',
                              style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 12,
                                fontWeight: .w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          alignment: .center, // Phải có để icon không bị ép kích thước bởi Container
                          margin: EdgeInsets.only(right: 15),
                          decoration: BoxDecoration(
                            color: Color(0xFF526C30),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/ic_dumbbell_white.svg',
                            width: 20,
                            height: 20,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: .start,
                          children: [
                            Text(
                              'Duy trì nhịp vận động',
                              style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 15,
                                fontWeight: .w600,
                              ),
                            ),
                            Text(
                              'Hoạt động & nhật ký hình ảnh',
                              style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 12,
                                fontWeight: .w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
              ItemBottomButton(
                text: 'Tạo tài khoản',
                onTap: () => context.push('/register'),
              ),

              const SizedBox(height: 15),
              ItemBottomButton(
                text: 'Đã có tài khoản? Đăng nhập',
                backgroundColor: Color(0xFFFFFFFF),
                textColor: Color(0xFF526C30),
                borderColor: Color(0xFFE8ECE8),
                borderWidth: 1,
                onTap: () => context.push('/login'),
              ),

              const SizedBox(height: 40),
              Center(
                child: Text(
                  'Dữ liệu của bạn, hành trình của bạn.',
                  style: TextStyle(
                    color: Color(0xFF768079),
                    fontSize: 12,
                    fontWeight: .w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
