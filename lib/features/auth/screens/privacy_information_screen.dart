import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stride/widgets/appbar_custom.dart';
import 'package:stride/widgets/item_app_bar_title.dart';
import 'package:stride/widgets/item_bottom_button.dart';

class PrivacyInformationScreen extends StatelessWidget {
  const PrivacyInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppbarCustom(
          title: ItemAppBarTitle(data: 'privacy_info.appbar_title'.tr()),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              'privacy_info.subtitle'.tr(),
              style: const TextStyle(
                color: Color(0xFF768079),
                fontSize: 14,
                fontWeight: .w400,
              ),
            ),
            Container(
              width: double.infinity,
              height: 98,
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.only(top: 40),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF4E5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: .start,
                mainAxisAlignment: .spaceBetween,
                children: [
                  Text(
                    'privacy_info.sync_title'.tr(),
                    style: const TextStyle(
                      color: Color(0xFF526C30),
                      fontSize: 14,
                      fontWeight: .w600,
                    ),
                  ),
                  Text(
                    'privacy_info.sync_desc'.tr(),
                    style: const TextStyle(
                      color: Color(0xFF768079),
                      fontSize: 13,
                      fontWeight: .w400,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 98,
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.only(top: 35),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF4E5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: .start,
                mainAxisAlignment: .spaceBetween,
                children: [
                  Text(
                    'privacy_info.personalize_title'.tr(),
                    style: const TextStyle(
                      color: Color(0xFF526C30),
                      fontSize: 14,
                      fontWeight: .w600,
                    ),
                  ),
                  Text(
                    'privacy_info.personalize_desc'.tr(),
                    style: const TextStyle(
                      color: Color(0xFF768079),
                      fontSize: 13,
                      fontWeight: .w400,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 98,
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.only(top: 35),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF4E5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: .start,
                mainAxisAlignment: .spaceBetween,
                children: [
                  Text(
                    'privacy_info.health_title'.tr(),
                    style: const TextStyle(
                      color: Color(0xFF526C30),
                      fontSize: 14,
                      fontWeight: .w600,
                    ),
                  ),
                  Text(
                    'privacy_info.health_desc'.tr(),
                    style: const TextStyle(
                      color: Color(0xFF768079),
                      fontSize: 13,
                      fontWeight: .w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 80),
        child: ItemBottomButton(
          text: 'privacy_info.btn_understood'.tr(),
          onTap: () => context.pop(),
        ),
      ),
    );
  }
}
