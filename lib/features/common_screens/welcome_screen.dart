import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:stride/widgets/item_bottom_button.dart';
import 'package:stride/widgets/language_switch_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ép widget lắng nghe thay đổi locale để tự động rebuild ngay lập tức khi đổi ngôn ngữ
    context.locale;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(
          100,
        ), // Tăng chiều cao để chứa 2 hàng riêng biệt
        child: AppBar(
          forceMaterialTransparency: true,
          scrolledUnderElevation: 0,
          shadowColor: Colors.transparent,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                children: [
                  // HÀNG 1: Logo và chữ "CÙNG BẠN"
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    crossAxisAlignment: .center,
                    children: [
                      SizedBox(
                        width: 135,
                        height: 39.15,
                        child: Stack(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/ic_stride.svg',
                              height: 28,
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
                      Container(
                        width: 103,
                        height: 25,
                        alignment: .center,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF4E5),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Text(
                          'welcome.badge'.tr(),
                          style: const TextStyle(
                            color: Color(0xFF526C30),
                            fontSize: 11,
                            fontWeight: .w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // HÀNG 2: Nút chuyển đổi ngôn ngữ nằm tách biệt ở bên dưới (căn lề phải)
                  Row(
                    mainAxisAlignment: .end,
                    children: const [
                      LanguageSwitchButton(width: 103, height: 25),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                'welcome.title'.tr(),
                style: const TextStyle(
                  color: Color(0xFF1C2520),
                  fontSize: 34,
                  fontWeight: .w700,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'welcome.subtitle'.tr(),
                style: const TextStyle(
                  color: Color(0xFF768079),
                  fontSize: 15,
                  fontWeight: .w400,
                ),
              ),
              const SizedBox(height: 25),
              Container(
                width: double.infinity,
                height: 200,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF202C25),
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
                          alignment: .center,
                          margin: const EdgeInsets.only(right: 15),
                          decoration: BoxDecoration(
                            color: const Color(0xFF526C30),
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
                              'welcome.feature_1_title'.tr(),
                              style: const TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 15,
                                fontWeight: .w600,
                              ),
                            ),
                            Text(
                              'welcome.feature_1_desc'.tr(),
                              style: const TextStyle(
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
                          alignment: .center,
                          margin: const EdgeInsets.only(right: 15),
                          decoration: BoxDecoration(
                            color: const Color(0xFF526C30),
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
                              'welcome.feature_2_title'.tr(),
                              style: const TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 15,
                                fontWeight: .w600,
                              ),
                            ),
                            Text(
                              'welcome.feature_2_desc'.tr(),
                              style: const TextStyle(
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
                          alignment: .center,
                          margin: const EdgeInsets.only(right: 15),
                          decoration: BoxDecoration(
                            color: const Color(0xFF526C30),
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
                              'welcome.feature_3_title'.tr(),
                              style: const TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 15,
                                fontWeight: .w600,
                              ),
                            ),
                            Text(
                              'welcome.feature_3_desc'.tr(),
                              style: const TextStyle(
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
                text: 'welcome.btn_register'.tr(),
                onTap: () => context.push('/register'),
              ),
              const SizedBox(height: 15),
              ItemBottomButton(
                text: 'welcome.btn_login'.tr(),
                backgroundColor: const Color(0xFFFFFFFF),
                textColor: const Color(0xFF526C30),
                borderColor: const Color(0xFFE8ECE8),
                borderWidth: 1,
                onTap: () => context.push('/login'),
              ),
              const SizedBox(height: 40),
              Center(
                child: Text(
                  'welcome.footer'.tr(),
                  style: const TextStyle(
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
