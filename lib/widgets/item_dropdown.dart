import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ItemDropdown extends StatelessWidget {
  final String selectedItem;
  final ValueChanged<String> onItemChanged;
  final List<String> listDropdown;
  final String? icon;

  const ItemDropdown({
    super.key,
    required this.onItemChanged,
    required this.selectedItem,
    required this.listDropdown,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8ECE8), width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: Row(
          children: [
            if (icon != null) ...[
              SvgPicture.asset(icon!, width: 21, height: 21),
              const SizedBox(width: 10),
            ],
            // Bọc bằng Expanded để tránh lỗi Layout với thuộc tính isExpanded: true
            Expanded(
              child: DropdownButton<String>(
                value: listDropdown.contains(selectedItem)
                    ? selectedItem
                    : listDropdown.first,
                isExpanded: true,
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xFF768079),
                ),
                style: const TextStyle(
                  color: Color(0xFF1C2520),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                onChanged: (value) {
                  if (value != null) onItemChanged(value);
                },
                items: listDropdown.map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
