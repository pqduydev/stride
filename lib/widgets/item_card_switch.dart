import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ItemCardSwitch extends StatefulWidget {
  const ItemCardSwitch({super.key});

  @override
  State<ItemCardSwitch> createState() => _ItemCardSwitchState();
}

class _ItemCardSwitchState extends State<ItemCardSwitch> {
  late bool _statusButton; // Khai bao bien trang thai

  @override
  void initState() {
    _statusButton = false; // Khoi tao gia tri ban dau cho bien trang thai
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Color(0xFFFFFFFF),
      ),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/ic_bell.svg',
                width: 25,
                height: 25,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    "Bật nhắc hẹn",
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Color(0xFF1C2520),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "Đừng bỏ lỡ buổi tập đã lên lịch",
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Color(0xFF768079),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Switch(
            value: _statusButton, // Set trang thai theo
            onChanged: (bool value) {
              // Bat su kien
              setState(() {
                _statusButton = value; // Doi trang thai, cap nhat giao dien
              });
            },
            activeThumbColor: Color(0xFFFFFFFF),
            activeTrackColor: Color(0xFFD2F36B),
            inactiveThumbColor: Color(0xFF768079),
            inactiveTrackColor: Color(0xFFF7F8FA),
          ),
        ],
      ),
    );
  }
}
