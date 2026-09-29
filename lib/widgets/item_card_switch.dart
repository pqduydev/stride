import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ItemCardSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const ItemCardSwitch({super.key, required this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: EdgeInsets.all(15),
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
                colorFilter: ColorFilter.mode(
                  Color(0xFF526C30),
                  BlendMode.srcIn,
                ),
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
          SizedBox(
            width: 52,
            height: 40,
            child: FittedBox(
              fit: BoxFit.fill,
              child: Switch(
                value: value, // ← lấy từ ngoài
                onChanged: onChanged, // ← báo ra ngoài
                activeThumbColor: const Color(0xFFFFFFFF),
                activeTrackColor: const Color(0xFFD2F36B),
                inactiveThumbColor: const Color(0xFF768079),
                inactiveTrackColor: const Color(0xFFF7F8FA),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
