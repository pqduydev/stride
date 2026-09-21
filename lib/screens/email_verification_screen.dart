import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stride/widgets/appbar_custom.dart';
import 'package:stride/widgets/item_app_bar_title.dart';
import 'package:stride/widgets/item_bottom_button.dart';
import 'package:stride/widgets/item_infomation.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppbarCustom(title: ItemAppBarTitle(data: 'Dữ liệu của bạn')),
      ),

      body: Padding(
        padding: EdgeInsetsGeometry.only(top: 15, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              'Chỉ còn một bước để bảo vệ tài khoản.',
              style: TextStyle(
                color: Color(0xFF768079),
                fontSize: 14,
                fontWeight: .w400,
              ),
            ),

            Center(
              child: Container(
                width: 100,
                height: 100,
                margin: EdgeInsets.only(top: 60, bottom: 50),
                alignment: .center,
                decoration: BoxDecoration(
                  color: Color(0xFFEEF4E5),
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
              'Kiểm tra hộp thư của bạn',
              style: TextStyle(
                color: Color(0xFF1C2520),
                fontSize: 24,
                fontWeight: .w700,
              ),
            ),

            const SizedBox(height: 10),
            Text(
              'Liên kết xác thực đã được gửi đến\nminhan@example.com.',
              style: TextStyle(
                color: Color(0xFF768079),
                fontSize: 14,
                fontWeight: .w400,
              ),
            ),

            ItemInfomation(
              title: 'Tiếp tục sau khi xác thực',
              info: 'Mở email và chạm vào liên kết.\nSau đó quay lại Stride để tiếp tục.',
            ),

            const SizedBox(height: 80),
            ItemBottomButton(text: 'Tôi đã xác thực email'),

            const SizedBox(height: 30),
            InkWell(
              child: Center(
                child: Text(
                  'Gửi lại email',
                  style: TextStyle(
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
