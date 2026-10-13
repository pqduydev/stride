import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:stride/core/theme/app_colors.dart';
import 'package:stride/widgets/item_custom_text_field.dart';
import 'package:stride/widgets/appbar_custom.dart';
import 'package:stride/widgets/item_app_bar_title.dart';
import 'package:stride/widgets/item_bottom_button.dart';

class LoginWithPhoneNumberScreen extends StatelessWidget {
  const LoginWithPhoneNumberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>() ?? AppColors.light;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppbarCustom(
          title: ItemAppBarTitle(data: 'login_phone.appbar_title'.tr()),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                'login_phone.subtitle'.tr(),
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
                    'assets/icons/ic_phone_green.svg',
                    width: 48,
                    height: 48,
                  ),
                ),
              ),
              Text(
                'login_phone.title'.tr(),
                style: TextStyle(
                  color: colors.ink,
                  fontSize: 24,
                  fontWeight: .w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'login_phone.desc'.tr(),
                style: TextStyle(
                  color: colors.muted,
                  fontSize: 14,
                  fontWeight: .w400,
                ),
              ),
              const SizedBox(height: 35),
              ItemCustomTextField(
                label: 'login_phone.phone_label'.tr(),
                suffixIcon: SvgPicture.asset(
                  "assets/icons/ic_phone.svg",
                  width: 19,
                  height: 19,
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'login_phone.error_empty'.tr();
                  }
                  final phoneRegex = RegExp(r'^[35789]\d{8}$');
                  if (!phoneRegex.hasMatch(value.trim())) {
                    return 'login_phone.error_format'.tr();
                  }
                  return null;
                },
              ),
              Text(
                'login_phone.phone_note'.tr(),
                style: TextStyle(
                  color: colors.muted,
                  fontSize: 12,
                  fontWeight: .w400,
                ),
              ),
              const SizedBox(height: 60),
              ItemBottomButton(text: 'login_phone.btn_submit'.tr()),
              const SizedBox(height: 30),
              InkWell(
                onTap: () => context.pop(),
                child: Center(
                  child: Text(
                    'login_phone.other_method'.tr(),
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
      ),
    );
  }
}
