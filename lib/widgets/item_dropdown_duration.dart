import 'package:flutter/material.dart';

class ItemDropdownDuration extends StatelessWidget {
  final String selectedDuration;
  final ValueChanged<String> onDurationChanged;

  const ItemDropdownDuration({
    super.key,
    required this.onDurationChanged,
    required this.selectedDuration,
  });

  final List<String> durations = const ["1 tháng", "2 tháng", "3 tháng"];

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
        child: DropdownButton<String>(
          value: durations.contains(selectedDuration)
              ? selectedDuration
              : durations.first,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF768079)),
          style: const TextStyle(
            color: Color(0xFF1C2520),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          onChanged: (value) {
            if (value != null) onDurationChanged(value);
          },
          items: durations.map((duration) {
            return DropdownMenuItem<String>(
              value: duration,
              child: Text(duration),
            );
          }).toList(),
        ),
      ),
    );
  }
}
