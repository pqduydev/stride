import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:stride/widgets/item_custom_text_field.dart';
import 'package:stride/widgets/appbar_custom.dart';
import 'package:stride/widgets/item_app_bar_title.dart';
import 'package:stride/widgets/item_bottom_button.dart';

class LoginWithPhoneNumberScreen extends StatelessWidget {
  const LoginWithPhoneNumberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppbarCustom(title: ItemAppBarTitle(data: 'Số điện thoại')),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.only(top: 15, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                'Đăng ký hoặc đăng nhập bằng mã xác thực.',
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
                    'assets/icons/ic_phone_green.svg',
                    width: 48,
                    height: 48,
                  ),
                ),
              ),

              Text(
                'Nhập số điện thoại',
                style: TextStyle(
                  color: Color(0xFF1C2520),
                  fontSize: 24,
                  fontWeight: .w700,
                ),
              ),

              const SizedBox(height: 10),
              Text(
                'Chúng tôi sẽ gửi mã xác thực qua SMS.',
                style: TextStyle(
                  color: Color(0xFF768079),
                  fontSize: 14,
                  fontWeight: .w400,
                ),
              ),

              const SizedBox(height: 35),
              ItemCustomTextField(
                label: 'Việt Nam (+84)',
                suffixIcon: SvgPicture.asset(
                  "assets/icons/ic_phone.svg",
                  width: 19,
                  height: 19,
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập số điện thoại';
                  }

                  // Regex kiểm tra số điện thoại VN không có số 0 ở đầu:
                  // ^[35789] : Bắt đầu bằng 3, 5, 7, 8 hoặc 9 (các đầu số di động hợp lệ)
                  // \d{8}$   : Tiếp theo là chính xác 8 chữ số
                  final phoneRegex = RegExp(r'^[35789]\d{8}$');

                  if (!phoneRegex.hasMatch(value.trim())) {
                    return 'Số điện thoại không hợp lệ (bỏ số 0 ở đầu)';
                  }
                  return null;
                },
              ),

              Text(
                'Không nhập số 0 đầu tiên sau mã +84.',
                style: TextStyle(
                  color: Color(0xFF768079),
                  fontSize: 12,
                  fontWeight: .w400,
                ),
              ),

              const SizedBox(height: 60),
              ItemBottomButton(text: 'Gửi mã xác thực'),

              const SizedBox(height: 30),
              InkWell(
                onTap: () => context.pop(),
                child: Center(
                  child: Text(
                    'Dùng email hoặc tài khoản khác',
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
