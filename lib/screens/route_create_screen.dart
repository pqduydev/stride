import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stride/widgets/item_app_bar_title.dart';
import 'package:stride/widgets/item_bottom_button.dart';
import 'package:stride/widgets/item_date_time.dart';
import 'package:stride/widgets/item_dropdown_duration.dart';
import 'package:stride/widgets/item_radio_route_group.dart';
import 'package:stride/widgets/item_text_field.dart';

class RouteCreateScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: ItemAppBarTitle(data: "Tạo lộ trình")),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                "Một mục tiêu, một hành trình mới.",
                style: TextStyle(
                  color: const Color(0xFF768079),
                  fontSize: 14,
                  fontWeight: .w400,
                ),
              ),
              const SizedBox(height: 15),
              // TextField
              Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    "Tên lộ trình",
                    style: TextStyle(
                      color: const Color(0xFF768079),
                      fontSize: 13,
                      fontWeight: .w500,
                    ),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    height: 52,
                    child: ItemTextField(hintText: "Nhập tên lộ trình"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Cac Radio button
              ItemRadioTouteGroup(),
              const SizedBox(height: 20),
              // Dropdown menu
              ItemDropdownDuration(),
              // Form chon ngay
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: .spaceBetween,
                crossAxisAlignment: .center,
                children: [
                  ItemDateTime(
                    label: "Ngày bắt đầu",
                    defaultDate: DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day,
                    ),
                  ),
                  ItemDateTime(
                    label: "Ngày kết thúc",
                    defaultDate: DateTime(
                      DateTime.now().year,
                      DateTime.now().month + 1,
                      DateTime.now().day,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // TextField soan thao
              Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    "Mô tả mục tiêu",
                    style: TextStyle(
                      color: const Color(0xFF768079),
                      fontSize: 13,
                      fontWeight: .w500,
                    ),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    height: 90,
                    child: TextField(
                      maxLines: 3,
                      style: TextStyle(
                        color: const Color(0xFF1C2520),
                        fontSize: 14,
                        fontWeight: .w400,
                      ),
                      decoration: InputDecoration(
                        hintText: "Nhập mô tả mục tiêu",
                        hintStyle: TextStyle(
                          color: const Color(0xFF768079),
                          fontSize: 14,
                          fontWeight: .w400,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFFFFFFF),

                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: const Color(0xFFE8ECE8),
                            width: 1,
                            style: BorderStyle.solid,
                          ),

                          borderRadius: BorderRadius.circular(12),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: const Color(0xFFE8ECE8),
                            width: 1,
                            style: BorderStyle.solid,
                          ),

                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Container(
                height: 57,
                padding: EdgeInsets.all(15),
                alignment: .center,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF4E5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: .center,
                      children: [
                        SvgPicture.asset(
                          "assets/icons/ic_bell.svg",
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Thêm lịch tập & nhắc hẹn",
                          style: TextStyle(
                            color: const Color(0xFF526C30),
                            fontSize: 14,
                            fontWeight: .w600,
                          ),
                        ),
                      ],
                    ),
                    SvgPicture.asset(
                      "assets/icons/Ic_chevron_right.svg",
                      width: 18,
                      height: 18,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ItemBottomButton(data: "Tạo lộ trình"),
    );
  }
}
