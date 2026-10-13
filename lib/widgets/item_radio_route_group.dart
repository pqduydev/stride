import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stride/core/theme/app_colors.dart';

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
    final colors = Theme.of(context).extension<AppColors>() ?? AppColors.light;

    return Column(
      crossAxisAlignment: .start,
      children: [
        // Tiêu đề và dấu hiệu nhận biết cuộn ngang
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text(
              "item_radio_route_group.section_title".tr(),
              style: TextStyle(
                color: colors.muted,
                fontSize: 13,
                fontWeight: .w500,
              ),
            ),
            Row(
              children: [
                Text(
                  "item_radio_route_group.scroll_hint".tr(),
                  style: TextStyle(
                    color: colors.muted,
                    fontSize: 11,
                    fontWeight: .w400,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 10,
                  color: colors.muted,
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
                      color: isSelected ? colors.ink : colors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? colors.ink : colors.line,
                        width: 1,
                      ),
                    ),
                    alignment: .center,
                    child: Text(
                      translationKey.tr(),
                      style: TextStyle(
                        color: isSelected ? colors.surface : colors.muted,
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
