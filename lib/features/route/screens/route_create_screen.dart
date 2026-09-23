import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:stride/model/route_model.dart';
import 'package:stride/features/route/route_cubit/route_cubit.dart';
import 'package:stride/features/route/route_cubit/route_state.dart';
import 'package:stride/widgets/appbar_custom.dart';
import 'package:stride/widgets/item_app_bar_title.dart';
import 'package:stride/widgets/item_bottom_button.dart';
import 'package:stride/widgets/item_date_time.dart';
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

  String _selectedGoal = 'weight_loss';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 1));

  bool get isEditMode => widget.routeToEdit != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      final route = widget.routeToEdit!;
      _titleController.text = route.title;
      _descriptionController.text = route.description;
      _selectedGoal = route.goal;

      _startDate = DateTime.parse(route.startDate);
      _endDate = DateTime.parse(route.endDate);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final String formattedStartDate = DateFormat('yyyy-MM-dd')
        .format(_startDate);
    final String formattedEndDate = DateFormat('yyyy-MM-dd').format(_endDate);

    final route = RouteModel(
      id: widget.routeToEdit?.id ?? 0,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      goal: _selectedGoal,
      startDate: formattedStartDate,
      endDate: formattedEndDate,
      isActive: true,
    );

    final cubit = context.read<RouteCubit>();

    isEditMode ? cubit.updateRoute(route) : cubit.addRoute(route);
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
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: AppbarCustom(
              title: ItemAppBarTitle(
                data: isEditMode ? 'Chỉnh sửa lộ trình' : 'Tạo lộ trình mới',
              ),
            ),
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  const Text(
                    "Một mục tiêu, một hành trình mới.",
                    style: TextStyle(
                      color: Color(0xFF768079),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Tên lộ trình",
                    style: TextStyle(
                      color: Color(0xFF768079),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
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
                  const SizedBox(height: 10),
                  ItemRadioRouteGroup(
                    selectedGoalKey: _selectedGoal,
                    onGoalChanged: (goalEnum) {
                      setState(() => _selectedGoal = goalEnum);
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
                  const Text(
                    "Mô tả mục tiêu",
                    style: TextStyle(
                      color: Color(0xFF768079),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
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

          bottomNavigationBar: BlocBuilder<RouteCubit, RouteState>(
            builder: (context, routeState) {
              final isLoading = routeState.actionStatus == RouteStatus.loading;

              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                child: ItemBottomButton(
                  text: isEditMode ? 'Lưu thay đổi' : 'Tạo lộ trình',
                  isLoading: isLoading,
                  onTap: isLoading ? null : _onSave,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
