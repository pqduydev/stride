import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:stride/widgets/item_custom_text_field.dart';
import 'package:stride/widgets/appbar_custom.dart';
import 'package:stride/widgets/item_app_bar_title.dart';
import 'package:stride/widgets/item_bottom_button.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppbarCustom(
          title: ItemAppBarTitle(data: 'forget_password.appbar_title'.tr()),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                'forget_password.subtitle'.tr(),
                style: const TextStyle(
                  color: Color(0xFF768079),
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
                    color: const Color(0xFFEEF4E5),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/ic_lock_green.svg',
                    width: 44,
                    height: 44,
                  ),
                ),
              ),
              ItemCustomTextField(
                label: 'forget_password.email_label'.tr(),
                suffixIcon: SvgPicture.asset(
                  "assets/icons/ic_mail.svg",
                  width: 19,
                  height: 19,
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'forget_password.error_empty'.tr();
                  }
                  final emailRegex = RegExp(
                    r'^[a-z0-9_\-\.]+@([a-z0-9\-]+\.)+[a-z]{2,4}$',
                  );
                  if (!emailRegex.hasMatch(value.trim())) {
                    return 'forget_password.error_format'.tr();
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Text(
                'forget_password.note'.tr(),
                style: const TextStyle(
                  color: Color(0xFF768079),
                  fontSize: 14,
                  fontWeight: .w400,
                ),
              ),
              const SizedBox(height: 70),
              ItemBottomButton(
                text: 'forget_password.btn_submit'.tr(),
                onTap: () => context.push(
                  '/login/forget_password/check_email',
                  extra: {
                    'app_bar_title': 'forget_password.check_email_title'.tr(),
                    'title': 'forget_password.check_email_title'.tr(),
                    'info': 'forget_password.check_email_info'.tr(),
                    'button_title': 'forget_password.btn_back_login'.tr(),
                    'on_tap': () => Navigator.of(context)
                        .popUntil((route) => route.settings.name == '/login'),
                  },
                ),
              ),
              const SizedBox(height: 30),
              InkWell(
                onTap: () => context.pop(),
                child: Center(
                  child: Text(
                    'forget_password.back_to_login'.tr(),
                    style: const TextStyle(
                      color: Color(0xFF526C30),
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
