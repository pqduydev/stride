import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:stride/widgets/appbar_custom.dart';
import 'package:stride/widgets/item_app_bar_title.dart';
import 'package:stride/widgets/item_bottom_button.dart';
import 'package:stride/widgets/item_infomation.dart';

class LoginWithGooglesScreen extends StatelessWidget {
  const LoginWithGooglesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppbarCustom(
          title: ItemAppBarTitle(data: 'login_google.appbar_title'.tr()),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              'login_google.subtitle'.tr(),
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
                  'assets/icons/ic_google.svg',
                  width: 42,
                  height: 42,
                ),
              ),
            ),
            Center(
              child: Column(
                children: [
                  Text(
                    'login_google.title'.tr(),
                    style: const TextStyle(
                      color: Color(0xFF1C2520),
                      fontSize: 24,
                      fontWeight: .w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'login_google.desc'.tr(),
                    style: const TextStyle(
                      color: Color(0xFF768079),
                      fontSize: 14,
                      fontWeight: .w400,
                    ),
                  ),
                ],
              ),
            ),
            ItemInfomation(
              title: 'login_google.info_title'.tr(),
              info: 'login_google.info_desc'.tr(),
            ),
            const SizedBox(height: 80),
            ItemBottomButton(text: 'login_google.btn_continue'.tr()),
            const SizedBox(height: 30),
            InkWell(
              onTap: () => context.pop(),
              child: Center(
                child: Text(
                  'login_google.other_method'.tr(),
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
    );
  }
}
