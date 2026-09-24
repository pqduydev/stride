import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:stride/core/utils/time_utils.dart';
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

enum FormAction { none, saving, deleting }

class _RouteCreateScreenState extends State<RouteCreateScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedGoal = 'weight_loss';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 1));

  bool get isEditMode => widget.routeToEdit != null;

  FormAction _currentAction = FormAction.none;

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

    setState(() => _currentAction = FormAction.saving);
    final cubit = context.read<RouteCubit>();
    isEditMode ? cubit.updateRoute(route) : cubit.addRoute(route);
  }

  void _showDeleteConfirmDialog(BuildContext context, RouteModel route) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFDE8E8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: Color(0xFFE53935),
                    size: 24,
                  ),
                ),
                const SizedBox(height: 16),

                const Text(
                  'Xóa lộ trình',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1C2520),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF768079),
                      height: 1.4,
                    ),
                    children: [
                      const TextSpan(text: 'Bạn có chắc muốn xóa lộ trình '),
                      TextSpan(
                        text: '"${route.title}"',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1C2520),
                        ),
                      ),
                      const TextSpan(
                        text: ' ? Thao tác này không thể hoàn tác.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: Color(0xFFE8ECE8)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Hủy',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF768079),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final cubit = context.read<RouteCubit>();

                          Navigator.pop(dialogContext);
                          setState(() => _currentAction = FormAction.deleting);

                          cubit.deleteRoute(route.id!);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: const Color(0xFFE53935),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Xóa',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
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
          setState(() => _currentAction = FormAction.none);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Đã xảy ra lỗi'),
              backgroundColor: Colors.redAccent,
            ),
          );
        } else if (state.actionStatus == RouteStatus.success) {
          String message = 'Tạo lộ trình thành công';

          if (_currentAction == FormAction.deleting) {
            message = 'Xóa lộ trình thành công';
          } else if (_currentAction == FormAction.saving && isEditMode) {
            message = 'Cập nhật lộ trình thành công';
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                message,
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

                  ItemRadioRouteGroup(
                    selectedGoalKey: _selectedGoal,
                    onGoalChanged: (goalEnum) {
                      setState(() => _selectedGoal = goalEnum);
                    },
                  ),

                  const SizedBox(height: 18),
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

                  const SizedBox(height: 10),
                  Container(
                    constraints: const BoxConstraints(minHeight: 35),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    alignment: .centerLeft,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF4E5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Text(
                          'Thời lượng: ',
                          style: TextStyle(
                            color: Color(0xFF768079),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            TimeUtils.formatDuration(_startDate, _endDate),
                            style: const TextStyle(
                              color: Color(0xFF202C25),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),
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
              final isGlobalLoading =
                  routeState.actionStatus == RouteStatus.loading;

              final isSaving =
                  isGlobalLoading && _currentAction == FormAction.saving;
              final isDeleting =
                  isGlobalLoading && _currentAction == FormAction.deleting;

              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isEditMode) ...[
                      ItemBottomButton(
                        text: 'Xoá lộ trình',
                        backgroundColor: Color(0xFFFF5252),
                        isLoading: isDeleting,
                        onTap: isGlobalLoading
                            ? null
                            : () => _showDeleteConfirmDialog(
                                context,
                                widget.routeToEdit!,
                              ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    ItemBottomButton(
                      text: isEditMode ? 'Lưu thay đổi' : 'Tạo lộ trình',
                      isLoading: isSaving,
                      onTap: isGlobalLoading ? null : _onSave,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
