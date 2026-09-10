import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ItemDropdownDuration extends StatefulWidget {
  const new({super.key});

  @override
  State<ItemDropdownDuration> createState() => _ItemDropdownDurationState();
}

class _ItemDropdownDurationState extends State<ItemDropdownDuration> {
  final List<String> durations = ["1 tháng", "2 tháng", "3 tháng"];

  late String? selectedDuration;

  @override
  void initState() {
    super.initState();
    selectedDuration = durations.isNotEmpty ? durations.first : null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          "Thời lượng",
          style: TextStyle(
            color: Color(0xFF768079),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        DropdownMenu(
          initialSelection: selectedDuration,
          expandedInsets: EdgeInsets.zero,
          textStyle: TextStyle(
            color: Color(0xFF1C2520),
            fontSize: 15,
            fontWeight: .w500,
          ),
          trailingIcon: SvgPicture.asset(
            "assets/icons/ic_chevron_down.svg",
            width: 20,
            height: 20,
          ),
          selectedTrailingIcon: SvgPicture.asset(
            "assets/icons/ic_chevron_up.svg",
            width: 20,
            height: 20,
          ),
          menuStyle: MenuStyle(
            backgroundColor: WidgetStateProperty.all(Color(0xFFFFFFFF)),
            maximumSize: WidgetStateProperty.all(const Size.fromHeight(200)),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(12),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Color(0xFFFFFFFF),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFFE8ECE8),
                width: 1,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFFE8ECE8),
                width: 1,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onSelected: (value) {},
          dropdownMenuEntries: durations.map((duration) {
            return DropdownMenuEntry(value: duration, label: duration);
          }).toList(),
        ),
      ],
    );
  }
}
