import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class ItemDateTime extends StatefulWidget {
  final String label;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final ValueChanged<DateTime> onDateSelected;
  final DateTime? lastDate;

  const ItemDateTime({
    super.key,
    required this.label,
    this.initialDate,
    required this.onDateSelected,
    this.firstDate,
    this.lastDate,
  });

  @override
  State<ItemDateTime> createState() => _ItemDateTimeState();
}

class _ItemDateTimeState extends State<ItemDateTime> {
  DateTime? selectedDayTime;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    selectedDayTime = widget.initialDate;
    _controller = TextEditingController(
      text: widget.initialDate != null
          ? DateFormat("dd/MM/yyyy").format(widget.initialDate!)
          : DateFormat("dd/MM/yyyy").format(DateTime.now()),
    );
  }

  @override
  void didUpdateWidget(covariant ItemDateTime oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialDate != oldWidget.initialDate) {
      selectedDayTime = widget.initialDate;
      _controller.text = widget.initialDate != null
          ? DateFormat("dd/MM/yyyy").format(widget.initialDate!)
          : '';
    }
  }

  void openSelectDayTime() async {
    final minDate = widget.firstDate ?? DateTime(1900);
    final currentInitial = selectedDayTime ?? DateTime.now();

    final result = await showDatePicker(
      context: context,
      // Đảm bảo initialDate không bao giờ nhỏ hơn firstDate
      initialDate: currentInitial.isBefore(minDate) ? minDate : currentInitial,
      firstDate: minDate,
      lastDate: widget.lastDate ?? DateTime(2100),
    );

    if (result != null) {
      setState(() {
        selectedDayTime = result;
        _controller.text = DateFormat("dd/MM/yyyy").format(result);
      });
      widget.onDateSelected(result);
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            color: Color(0xFF768079),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          height: 49,
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(11),
          ),
          child: TextField(
            onTap: openSelectDayTime,
            controller: _controller,
            readOnly: true,
            style: const TextStyle(
              color: Color(0xFF1C2520),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: DateFormat("dd/MM/yyyy").format(DateTime.now()),
              filled: true,
              fillColor: const Color(0xFFFFFFFF),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color(0xFFE8ECE8),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color(0xFFE8ECE8),
                  width: 1,
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
