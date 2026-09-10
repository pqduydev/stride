import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemDateTime extends StatefulWidget {
  final String label;
  DateTime defaultDate;

  ItemDateTime({super.key, required this.label, required this.defaultDate});

  @override
  State<ItemDateTime> createState() => _ItemDateTimeState();
}

class _ItemDateTimeState extends State<ItemDateTime> {
  DateTime? selectedDayTime;
  final TextEditingController _controller = TextEditingController();

  void openSelectDayTime() async {
    final result = await showDatePicker(
      context: context,
      initialDate: selectedDayTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (result != null) {
      setState(() {
        selectedDayTime = result;
        _controller.text = DateFormat("dd/MM/yyyy").format(result);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            color: Color(0xFF768079),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: 150,
          height: 49,
          decoration: BoxDecoration(
            color: Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(11),
          ),
          child: TextField(
            onTap: openSelectDayTime,
            controller: _controller,
            readOnly: true,
            style: TextStyle(
              color: Color(0xFF1C2520),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: DateFormat("dd/MM/yyyy").format(widget.defaultDate),
              filled: true,
              fillColor: const Color(0xFFFFFFFF),

              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: const Color(0xFFE8ECE8),
                  width: 1,
                  style: BorderStyle.solid,
                ),

                borderRadius: BorderRadius.circular(12),
              ),

              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: const Color(0xFFE8ECE8),
                  width: 1,
                  style: BorderStyle.solid,
                ),

                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
