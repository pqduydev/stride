import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stride/core/theme/app_colors.dart';

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
    final colors = Theme.of(context).extension<AppColors>() ?? AppColors.light;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.line, width: 1),
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
                dropdownColor: colors.surface,
                icon: Icon(Icons.keyboard_arrow_down, color: colors.muted),
                style: TextStyle(
                  color: colors.ink,
                  fontSize: 15,
                  fontWeight: .w600,
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
