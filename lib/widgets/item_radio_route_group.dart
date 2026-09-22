import 'package:flutter/material.dart';

class ItemRadioRouteGroup extends StatelessWidget {
  final String selectedGoalKey;
  final ValueChanged<String> onGoalChanged;

  const ItemRadioRouteGroup({
    super.key,
    required this.selectedGoalKey,
    required this.onGoalChanged,
  });

  static const Map<String, String> goalOptions = {
    "Giảm cân": "weight_loss",
    "Tăng cơ": "muscle_gain",
    "Tăng sức bền": "endurance",
    "Tăng linh hoạt": "flexibility",
    "Tổng quát": "general",
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
            const Text(
              "Nhóm mục tiêu",
              style: TextStyle(
                color: Color(0xFF768079),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              children: const [
                Text(
                  "Cuộn ngang",
                  style: TextStyle(
                    color: Color(0xFFB0B8B3),
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(width: 4),
                Icon(
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
            children: goalOptions.entries.map((entry) {
              final String label = entry.key;
              final String value = entry.value;
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
                      label,
                      style: TextStyle(
                        color: Color(isSelected ? 0xFFFFFFFF : 0xFF768079),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
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
