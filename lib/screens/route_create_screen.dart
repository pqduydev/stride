import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:stride/model/route_model.dart';
import 'package:stride/route/route_cubit/route_cubit.dart';
import 'package:stride/route/route_cubit/route_state.dart';
import 'package:stride/widgets/item_bottom_button.dart';
import 'package:stride/widgets/item_date_time.dart';
import 'package:stride/widgets/item_dropdown_duration.dart';
import 'package:stride/widgets/item_radio_route_group.dart';
import 'package:stride/widgets/item_text_field.dart';

class RouteCreateScreen extends StatefulWidget {
  final RouteModel? routeToEdit;

  const RouteCreateScreen({super.key, this.routeToEdit});

  @override
  State<RouteCreateScreen> createState() => _RouteCreateScreenState();
}

class _RouteCreateScreenState extends State<RouteCreateScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedCategory = 'Sức khỏe';
  String _selectedDuration = '1 tháng';
  DateTime? _startDate;
  DateTime? _endDate = DateTime.now().add(const Duration(days: 30));

  bool get isEditMode => widget.routeToEdit != null;

  final DateFormat _dateFormat = DateFormat("dd/MM/yyyy");

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      final route = widget.routeToEdit!;
      _titleController.text = route.title;
      _descriptionController.text = route.description;
      _selectedCategory = route.category;
      _selectedDuration = route.duration;

      try {
        _startDate = _dateFormat.parse(route.startDate);
        _endDate = _dateFormat.parse(route.endDate);
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onSave(BuildContext context) {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tên lộ trình')),
      );
      return;
    }

    final cubit = context.read<RouteCubit>();
    final startDateStr = _startDate != null
        ? _dateFormat.format(_startDate!)
        : '';
    final endDateStr = _endDate != null ? _dateFormat.format(_endDate!) : '';

    if (isEditMode) {
      final updatedRoute = widget.routeToEdit!.copyWith(
        title: title,
        category: _selectedCategory,
        duration: _selectedDuration,
        startDate: startDateStr,
        endDate: endDateStr,
        description: _descriptionController.text,
      );
      cubit.updateRoute(updatedRoute);
    } else {
      final newRoute = RouteModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        category: _selectedCategory,
        duration: _selectedDuration,
        startDate: startDateStr,
        endDate: endDateStr,
        description: _descriptionController.text,
      );
      cubit.addRoute(newRoute);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RouteCubit, RouteState>(
      builder: (context, state) {
        final isLoading = state.status == RouteStatus.loading;

        return Scaffold(
          appBar: AppBar(
            title: Text(isEditMode ? 'Chỉnh sửa lộ trình' : 'Tạo lộ trình mới'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tên lộ trình",
                  style: TextStyle(
                    color: const Color(0xFF768079),
                    fontSize: 13,
                    fontWeight: .w500,
                  ),
                ),
                const SizedBox(height: 5),
                ItemTextField(
                  hintText: 'Nhập tên lộ trình...',
                  hintTextFontSize: 15,
                  controller: _titleController,
                  textColor: 0xFF1C2520,
                  textFontSize: 15,
                  textFontWeight: FontWeight.w500,
                  borderColor: '0xFFE8ECE8',
                  borderWidth: 1,
                  borderStyle: 'solid',
                ),
                const SizedBox(height: 16),
                ItemRadioTouteGroup(
                  selectedCategory: _selectedCategory,
                  onCategoryChanged: (category) {
                    setState(() => _selectedCategory = category);
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  "Thời lượng",
                  style: TextStyle(
                    color: const Color(0xFF768079),
                    fontSize: 13,
                    fontWeight: .w500,
                  ),
                ),
                const SizedBox(height: 5),
                ItemDropdownDuration(
                  selectedDuration: _selectedDuration,
                  onDurationChanged: (duration) {
                    setState(() => _selectedDuration = duration);
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ItemDateTime(
                        label: 'Ngày bắt đầu',
                        initialDate: _startDate,
                        onDateSelected: (date) {
                          setState(() => _startDate = date);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ItemDateTime(
                        label: 'Ngày kết thúc',
                        initialDate: _endDate,
                        onDateSelected: (date) {
                          setState(() => _endDate = date);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  "Mô tả mục tiêu",
                  style: TextStyle(
                    color: const Color(0xFF768079),
                    fontSize: 13,
                    fontWeight: .w500,
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  height: 90,
                  child: ItemTextField(
                    hintText: 'Nhập mô tả mục tiêu...',
                    hintTextFontSize: 15,
                    controller: _descriptionController,
                    textColor: 0xFF1C2520,
                    textFontSize: 15,
                    textFontWeight: FontWeight.w400,
                    borderColor: '0xFFE8ECE8',
                    borderWidth: 1,
                    borderStyle: 'solid',
                    maxLines: 3,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          bottomNavigationBar: ItemBottomButton(
            text: isEditMode ? 'Lưu thay đổi' : 'Tạo lộ trình',
            isLoading: isLoading,
            onTap: () => _onSave(context),
          ),
        );
      },
    );
  }
}
