import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stride/auth/widget/item_custom_text_field.dart';
import 'package:stride/widgets/appbar_custom.dart';
import 'package:stride/widgets/item_app_bar_title.dart';
import 'package:stride/widgets/item_bottom_button.dart';
import 'package:stride/widgets/item_social_button.dart';

class AuthScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final bool isLogin;

  final _nameController = TextEditingController();
  final _mailController = TextEditingController();
  final _passwordController = TextEditingController();

  AuthScreen({super.key, required this.isLogin});

  void _auth() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppbarCustom(
          title: ItemAppBarTitle(data: isLogin ? "Đăng nhập" : "Tạo tài khoản"),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                isLogin
                    ? "Chào mừng bạn trở lại. Tiếp tục hành trình nhé!"
                    : "Bắt đầu hành trình của riêng bạn.",
                style: TextStyle(
                  color: Color(0xFF768079),
                  fontSize: 14,
                  fontWeight: .w400,
                ),
              ),
              const SizedBox(height: 30),
              ?isLogin
                  ? null
                  : Column(
                      children: [
                        ItemCustomTextField(
                          label: 'Họ và tên',
                          controller: _nameController,
                          suffixIcon: SvgPicture.asset(
                            "assets/icons/ic_user.svg",
                            width: 19,
                            height: 19,
                          ),
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (_nameController.text.trim().isEmpty) {
                              return 'Vui lòng nhập họ và tên';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 3),
                      ],
                    ),
              ItemCustomTextField(
                label: 'Email',
                controller: _mailController,
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
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  );
                  if (!emailRegex.hasMatch(value.trim())) {
                    return 'Email không đúng định dạng';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 3),
              ItemCustomTextField(
                label: 'Mật khẩu',
                controller: _passwordController,
                suffixIcon: SvgPicture.asset(
                  "assets/icons/ic_lock.svg",
                  width: 19,
                  height: 19,
                ),
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                textInputAction: TextInputAction.done,
                autofillHints: [AutofillHints.password],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu';
                  }
                  if (value.length < 6) {
                    return 'Mật khẩu phải có ít nhất 6 ký tự';
                  }
                  return null;
                },
              ),

              isLogin
                  ? Row(
                      mainAxisAlignment: .end,
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 10, 35, 35),
                          child: Text(
                            "Quên mật khẩu?",
                            style: TextStyle(
                              color: Color(0xFF526C30),
                              fontSize: 13,
                              fontWeight: .w600,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: .start,
                      children: [
                        const SizedBox(height: 15),
                        Text(
                          "Dùng ít nhất 12 ký tự cho mật khẩu.",
                          style: TextStyle(
                            color: Color(0xFF768079),
                            fontSize: 12,
                            fontWeight: .w400,
                          ),
                        ),

                        const SizedBox(height: 25),
                        Text(
                          "Khi tạo tài khoản, bạn đồng ý với",
                          style: TextStyle(
                            color: Color(0xFF768079),
                            fontSize: 12,
                            fontWeight: .w400,
                          ),
                        ),

                        const SizedBox(height: 8),
                        Text(
                          "Điều khoản sử dụng và Quyền riêng tư.",
                          style: TextStyle(
                            color: Color(0xFF526C30),
                            fontSize: 12,
                            fontWeight: .w600,
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),

              ItemBottomButton(
                text: isLogin ? "Đăng nhập" : "Tạo tài khoản bằng email",
                onTap: _auth,
              ),

              ?isLogin
                  ? Column(
                      crossAxisAlignment: .center,
                      children: [
                        const SizedBox(height: 30),
                        Text(
                          "HOẶC TIẾP TỤC BẰNG",
                          style: TextStyle(
                            color: Color(0xFF768079),
                            fontSize: 13.5,
                            fontWeight: .w600,
                          ),
                        ),
                        const SizedBox(height: 30),

                        ItemSocialButton(
                          text: 'Số điện thoại',
                          fontWeight: .w700,
                          backgroundColor: Color(0xFFFFFFFF),
                          textColor: Color(0xFF526C30),
                          icon: SvgPicture.asset(
                            "assets/icons/ic_phone.svg",
                            width: 20,
                            height: 20,
                          ),
                          borderColor: Color(0xFFE8ECE8),
                          onTap: () {},
                        ),
                      ],
                    )
                  : null,

              const SizedBox(height: 15),
              ItemSocialButton(
                text: 'Tiếp tục với Google',
                backgroundColor: Color(0xFFFFFFFF),
                textColor: Color(0xFF1F1F1F),
                icon: SvgPicture.asset(
                  "assets/icons/ic_google.svg",
                  width: 20,
                  height: 20,
                ),
                borderColor: Color(0xFF747775),
                onTap: () {},
              ),
              const SizedBox(height: 15),
              ItemSocialButton(
                text: 'Tiếp tục với Apple',
                backgroundColor: Color(0xFF000000),
                textColor: Color(0xFFFFFFFF),
                icon: SvgPicture.asset(
                  "assets/icons/ic_apple.svg",
                  width: 20,
                  height: 20,
                ),
                onTap: () {},
              ),

              const SizedBox(height: 35),
              Row(
                mainAxisAlignment: .center,
                children: [
                  Text(
                    isLogin
                        ? "Chưa có tài khoản? Đăng ký"
                        : "Đã có tài khoản? Đăng nhập",
                    style: TextStyle(
                      color: Color(0xFF526C30),
                      fontSize: 13,
                      fontWeight: .w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
