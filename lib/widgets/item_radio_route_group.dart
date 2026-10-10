import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ItemRadioRouteGroup extends StatelessWidget {
  final String selectedGoalKey;
  final ValueChanged<String> onGoalChanged;

  const ItemRadioRouteGroup({
    super.key,
    required this.selectedGoalKey,
    required this.onGoalChanged,
  });

  // Ánh xạ value với key dùng cho đa ngôn ngữ
  static const Map<String, String> goalKeys = {
    "weight_loss": "item_radio_route_group.goals.weight_loss",
    "muscle_gain": "item_radio_route_group.goals.muscle_gain",
    "endurance": "item_radio_route_group.goals.endurance",
    "flexibility": "item_radio_route_group.goals.flexibility",
    "general": "item_radio_route_group.goals.general",
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        // Tiêu đề và dấu hiệu nhận biết cuộn ngang
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text(
              "item_radio_route_group.section_title".tr(),
              style: const TextStyle(
                color: Color(0xFF768079),
                fontSize: 13,
                fontWeight: .w500,
              ),
            ),
            Row(
              children: [
                Text(
                  "item_radio_route_group.scroll_hint".tr(),
                  style: const TextStyle(
                    color: Color(0xFFB0B8B3),
                    fontSize: 11,
                    fontWeight: .w400,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 10,
                  color: Color(0xFFB0B8B3),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Danh sách nhóm mục tiêu
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: goalKeys.entries.map((entry) {
              final String value = entry.key;
              final String translationKey = entry.value;
              final bool isSelected = selectedGoalKey == value;

              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: InkWell(
                  onTap: () => onGoalChanged(value),
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 39,
                    decoration: BoxDecoration(
                      color: Color(isSelected ? 0xFF1C2520 : 0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF1C2520)
                            : const Color(0xFFE8ECE8),
                        width: 1,
                      ),
                    ),
                    alignment: .center,
                    child: Text(
                      translationKey.tr(),
                      style: TextStyle(
                        color: Color(isSelected ? 0xFFFFFFFF : 0xFF768079),
                        fontSize: 13,
                        fontWeight: .w500,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
