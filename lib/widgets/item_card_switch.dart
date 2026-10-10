import 'package:easy_localization/easy_localization.dart';
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
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color(0xFFFFFFFF),
      ),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/ic_bell.svg',
                  width: 25,
                  height: 25,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF526C30),
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  // Bọc Column trong Expanded để văn bản tự động co giãn và xuống dòng/cắt bớt khi dài
                  child: Column(
                    crossAxisAlignment: .start,
                    mainAxisAlignment: .center,
                    children: [
                      Text(
                        'item_card_switch.title'.tr(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: const Color(0xFF1C2520),
                              fontSize: 16,
                              fontWeight: .w600,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'item_card_switch.subtitle'.tr(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: const Color(0xFF768079),
                          fontSize: 12,
                          fontWeight: .w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 52,
            height: 40,
            child: FittedBox(
              fit: BoxFit.fill,
              child: Switch(
                value: value,
                onChanged: onChanged,
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
