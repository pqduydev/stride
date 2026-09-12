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
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedCategory = 'Sức khỏe';
  String _selectedDuration = '1 tháng';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 1));

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
    // Kiểm tra việc validate form trước khi thực hiện các thao tác tiếp theo
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final title = _titleController.text.trim();
    final cubit = context.read<RouteCubit>();
    final startDateStr = _dateFormat.format(_startDate);
    final endDateStr = _dateFormat.format(_endDate);

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
      cubit.addRoute(newRoute, isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RouteCubit, RouteState>(
      listenWhen: (previous, current) =>
          previous.actionStatus == RouteStatus.loading &&
          (current.actionStatus == RouteStatus.success ||
              current.actionStatus == RouteStatus.failure),
      listener: (context, state) {
        if (state.actionStatus == RouteStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Đã xảy ra lỗi'),
              backgroundColor: Colors.redAccent,
            ),
          );
        } else if (state.actionStatus == RouteStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isEditMode
                    ? 'Cập nhật lộ trình thành công'
                    : 'Tạo lộ trình thành công',
                style: const TextStyle(color: Color(0xFF526C30)),
              ),
              backgroundColor: const Color(0xFFEEF4E5),
            ),
          );
          Navigator.pop(
            context,
          ); // Quay lại màn hình trước đó sau tạo hoặc cập nhật thành công
        }
      },
      builder: (context, state) {
        final isLoading = state.actionStatus == RouteStatus.loading;

        return Scaffold(
          appBar: AppBar(
            title: Text(isEditMode ? 'Chỉnh sửa lộ trình' : 'Tạo lộ trình mới'),
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Một mục tiêu, một hành trình mới.",
                    style: TextStyle(
                      color: Color(0xFF768079),
                      fontSize: 14,
                      fontWeight: .w400,
                    ),
                  ),
                  const SizedBox(height: 20),
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
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Vui lòng nhập tên lộ trình';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 2),
                  ItemRadioTouteGroup(
                    selectedCategory: _selectedCategory,
                    onCategoryChanged: (category) {
                      setState(() => _selectedCategory = category);
                    },
                  ),
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ItemDateTime(
                          label: 'Ngày bắt đầu',
                          initialDate: _startDate,
                          firstDate:
                              isEditMode && _startDate.isBefore(DateTime.now())
                              ? _startDate
                              : DateTime.now(),
                          onDateSelected: (newDate) {
                            setState(() {
                              _startDate = newDate;
                              if (_startDate.isAfter(_endDate)) {
                                _endDate = _startDate.add(
                                  const Duration(days: 1),
                                );
                              }
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ItemDateTime(
                          label: 'Ngày kết thúc',
                          initialDate: _endDate,
                          firstDate: _startDate.add(const Duration(days: 1)),
                          onDateSelected: (newDate) {
                            setState(() {
                              _endDate = newDate;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
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
                      hintTextFontSize: 14,
                      controller: _descriptionController,
                      textColor: 0xFF1C2520,
                      textFontSize: 14,
                      textFontWeight: FontWeight.w400,
                      borderColor: '0xFFE8ECE8',
                      borderWidth: 1,
                      borderStyle: 'solid',
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Vui lòng nhập mô tả mục tiêu";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
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
