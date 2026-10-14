import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:stride/core/theme/app_colors.dart';
import 'package:stride/core/theme/theme_cubit.dart';
import 'package:stride/widgets/item_bottom_button.dart';
import 'package:stride/widgets/language_switch_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ép widget lắng nghe thay đổi locale để tự động rebuild ngay lập tức khi đổi ngôn ngữ
    context.locale;
    final colors = Theme.of(context).extension<AppColors>() ?? AppColors.light;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
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
                          color: colors.avatarBackground,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Text(
                          'welcome.badge'.tr(),
                          style: TextStyle(
                            color: colors.green,
                            fontSize: 11,
                            fontWeight: .w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // HÀNG 2: Nút chuyển đổi ngôn ngữ nằm tách biệt ở bên dưới (căn lề phải)
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: .end,
                    children: [
                      // Nút đổi giao diện chỉ có icon, đặt song song và cùng kích thước (width: 103, height: 25) với nút ngôn ngữ
                      InkWell(
                        onTap: () {
                          context.read<ThemeCubit>().toggleTheme(!isDarkMode);
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 70,
                          height: 25,
                          alignment: .center,
                          decoration: BoxDecoration(
                            color: colors.avatarBackground,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: colors.green.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            isDarkMode
                                ? Icons.dark_mode_rounded
                                : Icons.light_mode_rounded,
                            size: 16,
                            color: colors.green,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const LanguageSwitchButton(width: 103, height: 25),
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
                style: TextStyle(
                  color: colors.ink,
                  fontSize: 34,
                  fontWeight: .w700,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'welcome.subtitle'.tr(),
                style: TextStyle(
                  color: colors.muted,
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
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: colors.line, width: 1),
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
                            color: colors.green,
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
                              style: TextStyle(
                                color: colors.ink,
                                fontSize: 15,
                                fontWeight: .w600,
                              ),
                            ),
                            Text(
                              'welcome.feature_1_desc'.tr(),
                              style: TextStyle(
                                color: colors.muted,
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
                            color: colors.green,
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
                              style: TextStyle(
                                color: colors.ink,
                                fontSize: 15,
                                fontWeight: .w600,
                              ),
                            ),
                            Text(
                              'welcome.feature_2_desc'.tr(),
                              style: TextStyle(
                                color: colors.muted,
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
                            color: colors.green,
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
                              style: TextStyle(
                                color: colors.ink,
                                fontSize: 15,
                                fontWeight: .w600,
                              ),
                            ),
                            Text(
                              'welcome.feature_3_desc'.tr(),
                              style: TextStyle(
                                color: colors.muted,
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
                backgroundColor: colors.surface,
                textColor: colors.green,
                borderColor: colors.line,
                borderWidth: 1,
                onTap: () => context.push('/login'),
              ),
              const SizedBox(height: 40),
              Center(
                child: Text(
                  'welcome.footer'.tr(),
                  style: TextStyle(
                    color: colors.muted,
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
