import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stride/core/theme/app_colors.dart';
import 'package:stride/widgets/appbar_custom.dart';
import 'package:stride/widgets/item_app_bar_title.dart';
import 'package:stride/widgets/item_bottom_button.dart';

class CheckScreen extends StatelessWidget {
  const CheckScreen({
    super.key,
    this.appBarTitle,
    this.title,
    this.info,
    this.buttonTitle,
    this.onTap,
  });

  final String? appBarTitle;
  final String? title;
  final String? info;
  final String? buttonTitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>() ?? AppColors.light;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppbarCustom(
          title: ItemAppBarTitle(
            data: appBarTitle ?? 'check.default_title'.tr(),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.only(top: 80, bottom: 50),
                  alignment: .center,
                  decoration: BoxDecoration(
                    color: colors.avatarBackground,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/ic_circle_check.svg',
                    width: 44,
                    height: 44,
                  ),
                ),
              ),
              Center(
                child: Column(
                  children: [
                    Text(
                      title ?? 'check.default_heading'.tr(),
                      style: TextStyle(
                        color: colors.ink,
                        fontSize: 24,
                        fontWeight: .w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      info ?? '',
                      style: TextStyle(
                        color: colors.muted,
                        fontSize: 14,
                        fontWeight: .w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 80,
          top: 30,
        ),
        child: ItemBottomButton(
          text: buttonTitle ?? 'check.btn_continue'.tr(),
          onTap: onTap,
        ),
      ),
    );
  }
}
