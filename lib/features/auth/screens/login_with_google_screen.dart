import 'package:flutter/material.dart';
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
          title: ItemAppBarTitle(data: 'Đăng nhập với Google'),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              'Kết nối an toàn với tài khoản của bạn.',
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
                child: Image.asset(
                  'assets/images/img_google.png',
                  width: 42,
                  height: 42,
                ),
              ),
            ),

            Center(
              child: Column(
                children: [
                  Text(
                    'Tiếp tục với Google',
                    style: TextStyle(
                      color: Color(0xFF1C2520),
                      fontSize: 24,
                      fontWeight: .w700,
                    ),
                  ),

                  const SizedBox(height: 10),
                  Text(
                    'Bạn sẽ xác nhận đăng nhập trên\nmàn hình bảo mật của Google.',
                    style: TextStyle(
                      color: Color(0xFF768079),
                      fontSize: 14,
                      fontWeight: .w400,
                    ),
                  ),
                ],
              ),
            ),

            ItemInfomation(
              title: 'Thông tin cơ bản',
              info: 'Stride dùng tên và email để tạo hồ sơ.\nBạn có thể chỉnh sửa hồ sơ sau đăng nhập.',
            ),

            const SizedBox(height: 80),
            ItemBottomButton(text: 'Tiếp tục'),

            const SizedBox(height: 30),
            InkWell(
              onTap: () => context.pop(),
              child: Center(
                child: Text(
                  'Dùng cách đăng nhập khác',
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
