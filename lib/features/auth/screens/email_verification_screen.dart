import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stride/core/theme/app_colors.dart';
import 'package:stride/widgets/appbar_custom.dart';
import 'package:stride/widgets/item_app_bar_title.dart';
import 'package:stride/widgets/item_bottom_button.dart';
import 'package:stride/widgets/item_infomation.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>() ?? AppColors.light;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppbarCustom(
          title: ItemAppBarTitle(data: 'email_verification.appbar_title'.tr()),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              'email_verification.subtitle'.tr(),
              style: TextStyle(
                color: colors.muted,
                fontSize: 14,
                fontWeight: .w400,
              ),
            ),
            Center(
              child: Container(
                width: 100,
                height: 100,
                margin: const EdgeInsets.only(top: 60, bottom: 50),
                alignment: .center,
                decoration: BoxDecoration(
                  color: colors.avatarBackground,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: SvgPicture.asset(
                  'assets/icons/ic_mail_green.svg',
                  width: 48,
                  height: 48,
                ),
              ),
            ),
            Text(
              'email_verification.title'.tr(),
              style: TextStyle(
                color: colors.ink,
                fontSize: 24,
                fontWeight: .w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'email_verification.desc'.tr(),
              style: TextStyle(
                color: colors.muted,
                fontSize: 14,
                fontWeight: .w400,
              ),
            ),
            ItemInfomation(
              title: 'email_verification.info_title'.tr(),
              info: 'email_verification.info_desc'.tr(),
            ),
            const SizedBox(height: 80),
            ItemBottomButton(text: 'email_verification.btn_verify'.tr()),
            const SizedBox(height: 30),
            InkWell(
              child: Center(
                child: Text(
                  'email_verification.resend'.tr(),
                  style: TextStyle(
                    color: colors.green,
                    fontSize: 13,
                    fontWeight: .w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
