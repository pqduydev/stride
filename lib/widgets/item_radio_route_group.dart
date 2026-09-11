import 'package:flutter/material.dart';

class ItemRadioTouteGroup extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;

  ItemRadioTouteGroup({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  List<String> categories = ["Sức khỏe", "Học tập", "Cá nhân"];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Nhóm mục tiêu",
          style: TextStyle(
            color: Color(0xFF768079),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: categories.map((category) {
            bool isSelected = selectedCategory == category;

            return InkWell(
              onTap: () => onCategoryChanged(category),
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              child: Container(
                width: 100,
                height: 39,
                decoration: BoxDecoration(
                  color: Color(isSelected ? 0xFF1C2520 : 0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE8ECE8), width: 1),
                ),
                alignment: Alignment.center,
                child: Text(
                  category,
                  style: TextStyle(
                    color: Color(isSelected ? 0xFFFFFFFF : 0xFF768079),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
