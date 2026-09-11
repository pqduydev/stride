import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stride/widgets/item_app_bar_title.dart';
import 'package:stride/widgets/item_bottom_button.dart';

class AddImageScreen extends StatelessWidget {
  const AddImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: ItemAppBarTitle(data: "Thêm hình ảnh")),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 30),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              "Chọn ảnh để lưu vào nhật ký tuần 5.",
              style: TextStyle(
                color: const Color(0xFF768079),
                fontSize: 14,
                fontWeight: .w400,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 61,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF4E5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: .center,
                children: [
                  SvgPicture.asset(
                    "assets/icons/ic_camera.svg",
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Chụp ảnh mới",
                    style: TextStyle(
                      color: const Color(0xFF526C30),
                      fontSize: 16,
                      fontWeight: .w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  "Ảnh gần đây",
                  style: TextStyle(
                    color: const Color(0xFF1C2520),
                    fontSize: 18,
                    fontWeight: .w700,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        height: 180,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13),
                          image: DecorationImage(
                            image: AssetImage(
                              "assets/images/img_background.jpg",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: SizedBox(
                          width: 26,
                          height: 26,
                          child: CircleAvatar(
                            child: SvgPicture.asset(
                              "assets/icons/ic_check.svg",
                              width: 16,
                              height: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 180,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE9EEE4),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Column(
                          mainAxisAlignment: .center,
                          crossAxisAlignment: .center,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/ic_image.svg",
                              width: 36,
                              height: 36,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Ảnh của bạn",
                              style: TextStyle(
                                color: Color(0xFF768079),
                                fontSize: 12,
                                fontWeight: .w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              """Lưu lại những khoảnh khắc trên hành trình. Bạn có thể thêm ảnh phòng tập, bài tập hoặc ảnh ghi lại sự thay đổi của mình.""",
              style: TextStyle(
                color: Color(0xFF768079),
                fontSize: 14,
                fontWeight: .w400,
              ),
              textDirection: .ltr,
            ),
          ],
        ),
      ),
      bottomNavigationBar: ItemBottomButton(text: "Thêm 1 ảnh", onTap: () {}),
    );
  }
}
