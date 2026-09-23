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
        child: AppbarCustom(title: ItemAppBarTitle(data: 'Quên mật khẩu')),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                  child: SvgPicture.asset(
                    'assets/icons/ic_lock_green.svg',
                    width: 44,
                    height: 44,
                  ),
                ),
              ),

              ItemCustomTextField(
                label: 'Email',
                suffixIcon: SvgPicture.asset(
                  "assets/icons/ic_mail.svg",
                  width: 19,
                  height: 19,
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập email';
                  }
                  final emailRegex = RegExp(
                    r'^[a-z0-9_\-\.]+@([a-z0-9\-]+\.)+[a-z]{2,4}$',
                  );
                  if (!emailRegex.hasMatch(value.trim())) {
                    return 'Email không đúng định dạng';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 10),
              Text(
                'Bạn sẽ nhận được hướng dẫn đặt lại\nmật khẩu nếu email này đã được đăng ký.',
                style: TextStyle(
                  color: Color(0xFF768079),
                  fontSize: 14,
                  fontWeight: .w400,
                ),
              ),

              const SizedBox(height: 70),
              ItemBottomButton(
                text: 'Gửi hướng dẫn',
                onTap: () => context.push(
                  '/login/forget_password/check_email',
                  extra: {
                    'app_bar_title': 'Kiểm tra email',
                    'title': 'Kiểm tra email',
                    'info': 'Nếu tài khoản tồn tại, hướng dẫn đặt lại\nmật khẩu sẽ được gửi đến email của bạn.',
                    'button_title': 'Về đăng nhập',
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
                    'Quay lại đăng nhập',
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
      ),
    );
  }
}
