import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:stride/core/utils/app_toast.dart';
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<RouteCubit>().resetErrors();
      }
    });

    if (isEditMode) {
      final route = widget.routeToEdit!;
      _titleController.text = route.title;
      _descriptionController.text = route.description ?? '';
      _selectedGoal = route.goal;

      _startDate = DateTime.parse(route.startDate);
      _endDate = DateTime.parse(route.endDate);
    }

    final controllers = [_titleController, _descriptionController];

    for (var controller in controllers) {
      controller.addListener(() {
        final state = context.read<RouteCubit>().state;
        if (state.actionStatus == RouteStatus.failure ||
            (state.fieldErrors?.isNotEmpty ?? false)) {
          context.read<RouteCubit>().resetErrors();
        }
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onSave() {
    final cubit = context.read<RouteCubit>();
    cubit.resetErrors();

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
                Text(
                  'route_create.delete_dialog_title'.tr(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: .w700,
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
                      TextSpan(text: 'route_create.delete_dialog_prefix'.tr()),
                      TextSpan(
                        text: '"${route.title}"',
                        style: const TextStyle(
                          fontWeight: .w700,
                          color: Color(0xFF1C2520),
                        ),
                      ),
                      TextSpan(text: 'route_create.delete_dialog_suffix'.tr()),
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
                        child: Text(
                          'route_create.btn_cancel'.tr(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: .w600,
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
                        child: Text(
                          'route_create.btn_confirm_delete'.tr(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: .w600,
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
          AppToast.showError(
            context,
            state.errorMessage ?? 'route_create.error_default'.tr(),
          );
        } else if (state.actionStatus == RouteStatus.success) {
          String message = 'route_create.success_create'.tr();

          if (_currentAction == FormAction.deleting) {
            message = 'route_create.success_delete'.tr();
          } else if (_currentAction == FormAction.saving && isEditMode) {
            message = 'route_create.success_update'.tr();
          }

          AppToast.showSuccess(context, message);
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: AppbarCustom(
              title: ItemAppBarTitle(
                data: isEditMode
                    ? 'route_create.title_edit'.tr()
                    : 'route_create.title_create'.tr(),
              ),
            ),
          ),
          body: AbsorbPointer(
            absorbing: state.actionStatus == RouteStatus.loading,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      'route_create.subtitle'.tr(),
                      style: const TextStyle(
                        color: Color(0xFF768079),
                        fontSize: 14,
                        fontWeight: .w400,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'route_create.label_title'.tr(),
                      style: const TextStyle(
                        color: Color(0xFF768079),
                        fontSize: 13,
                        fontWeight: .w500,
                      ),
                    ),
                    const SizedBox(height: 5),
                    ItemTextField(
                      hintText: 'route_create.hint_title'.tr(),
                      hintTextFontSize: 15,
                      controller: _titleController,
                      textColor: const Color(0xFF1C2520),
                      textFontSize: 15,
                      textFontWeight: .w500,
                      borderColor: const Color(0xFFE8ECE8),
                      borderWidth: 1,
                      borderStyle: 'solid',
                      validator: (value) {
                        final currentText = _titleController.text.trim();
                        if (currentText.isEmpty) {
                          return 'route_create.error_empty_title'.tr();
                        }
                        final routeState = context.read<RouteCubit>().state;
                        if (routeState.actionStatus == RouteStatus.failure &&
                            routeState.fieldErrors != null &&
                            routeState.fieldErrors!.containsKey('title')) {
                          final errors = routeState.fieldErrors!['title'];
                          if (errors is List && errors.isNotEmpty) {
                            return errors[0];
                          }
                        }
                        return null;
                      },
                    ),
                    ItemRadioRouteGroup(
                      selectedGoalKey: _selectedGoal,
                      onGoalChanged: (goalEnum) {
                        setState(() => _selectedGoal = goalEnum);
                        if (state.actionStatus == RouteStatus.failure ||
                            (state.fieldErrors?.isNotEmpty ?? false)) {
                          context.read<RouteCubit>().resetErrors();
                        }
                      },
                    ),
                    if (state.fieldErrors != null &&
                        state.fieldErrors!.containsKey('goal') &&
                        (state.fieldErrors!['goal'] as List).isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 12, top: 4),
                        child: Text(
                          (state.fieldErrors!['goal'] as List)[0],
                          style: const TextStyle(
                            color: Color(0xFFD32F2F),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    const SizedBox(height: 18),
                    Row(
                      crossAxisAlignment: .start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: .start,
                            children: [
                              ItemDateTime(
                                label: 'route_create.label_start_date'.tr(),
                                initialDate: _startDate,
                                firstDate:
                                    isEditMode &&
                                        _startDate.isBefore(DateTime.now())
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
                                  if (state.actionStatus ==
                                          RouteStatus.failure ||
                                      (state.fieldErrors?.isNotEmpty ??
                                          false)) {
                                    context.read<RouteCubit>().resetErrors();
                                  }
                                },
                              ),
                              if (state.fieldErrors != null &&
                                  state.fieldErrors!.containsKey(
                                    'start_date',
                                  ) &&
                                  (state.fieldErrors!['start_date'] as List)
                                      .isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 12,
                                    top: 4,
                                  ),
                                  child: Text(
                                    (state.fieldErrors!['start_date']
                                        as List)[0],
                                    style: const TextStyle(
                                      color: Color(0xFFD32F2F),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: .start,
                            children: [
                              ItemDateTime(
                                label: 'route_create.label_end_date'.tr(),
                                initialDate: _endDate,
                                firstDate: _startDate.add(
                                  const Duration(days: 1),
                                ),
                                onDateSelected: (newDate) {
                                  setState(() {
                                    _endDate = newDate;
                                  });
                                  if (state.actionStatus ==
                                          RouteStatus.failure ||
                                      (state.fieldErrors?.isNotEmpty ??
                                          false)) {
                                    context.read<RouteCubit>().resetErrors();
                                  }
                                },
                              ),
                              if (state.fieldErrors != null &&
                                  state.fieldErrors!.containsKey('end_date') &&
                                  (state.fieldErrors!['end_date'] as List)
                                      .isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 12,
                                    top: 4,
                                  ),
                                  child: Text(
                                    (state.fieldErrors!['end_date'] as List)[0],
                                    style: const TextStyle(
                                      color: Color(0xFFD32F2F),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
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
                          Text(
                            'route_create.duration_prefix'.tr(),
                            style: const TextStyle(
                              color: Color(0xFF768079),
                              fontSize: 13,
                              fontWeight: .w500,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              TimeUtils.formatDuration(_startDate, _endDate),
                              style: const TextStyle(
                                color: Color(0xFF202C25),
                                fontSize: 15,
                                fontWeight: .w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'route_create.label_description'.tr(),
                      style: const TextStyle(
                        color: Color(0xFF768079),
                        fontSize: 13,
                        fontWeight: .w500,
                      ),
                    ),
                    const SizedBox(height: 5),
                    ItemTextField(
                      hintText: 'route_create.hint_description'.tr(),
                      hintTextFontSize: 14,
                      controller: _descriptionController,
                      textColor: const Color(0xFF1C2520),
                      textFontSize: 14,
                      textFontWeight: .w400,
                      borderColor: const Color(0xFFE8ECE8),
                      borderWidth: 1,
                      borderStyle: 'solid',
                      maxLines: 3,
                      validator: (value) {
                        final routeState = context.read<RouteCubit>().state;
                        if (routeState.actionStatus == RouteStatus.failure &&
                            routeState.fieldErrors != null &&
                            routeState.fieldErrors!.containsKey(
                              'description',
                            )) {
                          final errors = routeState.fieldErrors!['description'];
                          if (errors is List && errors.isNotEmpty) {
                            return errors[0] as String;
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
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
                        text: 'route_create.btn_delete'.tr(),
                        backgroundColor: const Color(0xFFFF5252),
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
                      text: isEditMode
                          ? 'route_create.btn_save_changes'.tr()
                          : 'route_create.btn_create'.tr(),
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
