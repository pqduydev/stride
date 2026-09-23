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
        child: AppbarCustom(title: ItemAppBarTitle(data: 'Dữ liệu của bạn')),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              'Bạn kiểm soát cách Stride sử dụng thông tin.',
              style: TextStyle(
                color: Color(0xFF768079),
                fontSize: 14,
                fontWeight: .w400,
              ),
            ),

            Container(
              width: double.infinity,
              height: 98,
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.only(top: 40),
              decoration: BoxDecoration(
                color: Color(0xFFEEF4E5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: .start,
                mainAxisAlignment: .spaceBetween,
                children: [
                  Text(
                    'Tài khoản & đồng bộ',
                    style: TextStyle(
                      color: Color(0xFF526C30),
                      fontSize: 14,
                      fontWeight: .w600,
                    ),
                  ),
                  Text(
                    'Lưu hồ sơ, lộ trình, hoạt động và nhật ký\nđể tiếp tục hành trình trên các thiết bị.',
                    style: TextStyle(
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
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.only(top: 35),
              decoration: BoxDecoration(
                color: Color(0xFFEEF4E5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: .start,
                mainAxisAlignment: .spaceBetween,
                children: [
                  Text(
                    'Cá nhân hóa tùy chọn',
                    style: TextStyle(
                      color: Color(0xFF526C30),
                      fontSize: 14,
                      fontWeight: .w600,
                    ),
                  ),
                  Text(
                    'Chỉ dùng dữ liệu được bạn cho phép.\nTắt AI vẫn giữ nguyên các tính năng chính.',
                    style: TextStyle(
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
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.only(top: 35),
              decoration: BoxDecoration(
                color: Color(0xFFEEF4E5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: .start,
                mainAxisAlignment: .spaceBetween,
                children: [
                  Text(
                    'Thông tin sức khỏe',
                    style: TextStyle(
                      color: Color(0xFF526C30),
                      fontSize: 14,
                      fontWeight: .w600,
                    ),
                  ),
                  Text(
                    'Có lựa chọn riêng trước khi gửi cho AI.\nBạn có thể thu hồi quyền trong Hồ sơ.',
                    style: TextStyle(
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
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 80),
        child: ItemBottomButton(text: 'Đã hiểu', onTap: () => context.pop()),
      ),
    );
  }
}
