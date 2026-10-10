import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:stride/core/utils/app_toast.dart';
import 'package:stride/core/utils/instant_obscure_controller.dart';
import 'package:stride/features/user/user_cubit/user_cubit.dart';
import 'package:stride/features/user/user_cubit/user_state.dart';
import 'package:stride/widgets/appbar_custom.dart';
import 'package:stride/widgets/item_app_bar_title.dart';
import 'package:stride/widgets/item_bottom_button.dart';
import 'package:stride/widgets/item_custom_text_field.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();

  final _oldPasswordController = InstantObscureController();
  final _newPasswordController = InstantObscureController();
  final _newPasswordConfirmController = InstantObscureController();

  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmNewPassword = true;

  @override
  void initState() {
    super.initState();

    final controllers = [
      _oldPasswordController,
      _newPasswordController,
      _newPasswordConfirmController,
    ];

    for (var controller in controllers) {
      controller.addListener(() {
        final state = context.read<UserCubit>().state;
        if (state.status == UserStatus.failure ||
            (state.fieldErrors?.isNotEmpty ?? false)) {
          context.read<UserCubit>().resetErrors();
        }
      });
    }
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _newPasswordConfirmController.dispose();
    super.dispose();
  }

  void _submit() {
    final cubit = context.read<UserCubit>();

    if (cubit.state.status == UserStatus.failure ||
        (cubit.state.fieldErrors?.isNotEmpty ?? false)) {
      cubit.resetErrors();
    }

    if (!_formKey.currentState!.validate()) return;

    context.read<UserCubit>().changePassword({
      'old_password': _oldPasswordController.text,
      'new_password': _newPasswordController.text,
      'new_password_confirm': _newPasswordConfirmController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppbarCustom(
          title: ItemAppBarTitle(data: 'change_password.appbar_title'.tr()),
        ),
      ),
      body: BlocListener<UserCubit, UserState>(
        listener: (context, state) {
          if (state.status == UserStatus.failure) {
            _formKey.currentState?.validate();

            if (state.errorMessage != null) {
              AppToast.showError(context, state.errorMessage!);
            }
          } else if (state.status == UserStatus.success) {
            AppToast.showSuccess(context, 'change_password.success'.tr());

            context.read<UserCubit>().resetStatus();
            context.pop();
          }
        },
        child: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            final isLoading = state.status == UserStatus.loading;

            return AbsorbPointer(
              absorbing: isLoading,
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 15,
                      left: 20,
                      right: 20,
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.only(top: 80, bottom: 50),
                            alignment: .center,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEF4E5),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: SvgPicture.asset(
                              'assets/icons/ic_lock_green.svg',
                              width: 44,
                              height: 44,
                            ),
                          ),
                        ),

                        // 1. Mật khẩu cũ
                        ItemCustomTextField(
                          label: 'change_password.old_password.label'.tr(),
                          controller: _oldPasswordController,
                          textInputAction: TextInputAction.next,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureOldPassword = !_obscureOldPassword;
                                _oldPasswordController.isObscured =
                                    _obscureOldPassword;
                              });
                            },
                            child: Icon(
                              _obscureOldPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: const Color(0xFF768079),
                              size: 19,
                            ),
                          ),
                          autocorrect: false,
                          enableSuggestions: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'change_password.old_password.error_empty'
                                  .tr();
                            }
                            if (value.length < 6) {
                              return 'change_password.error_min_length'.tr();
                            }
                            final fieldErrors = context
                                .read<UserCubit>()
                                .state
                                .fieldErrors;
                            if (fieldErrors != null &&
                                fieldErrors.containsKey('old_password')) {
                              final errors = fieldErrors['old_password'];
                              if (errors is List && errors.isNotEmpty) {
                                return errors[0];
                              }
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        // 2. Mật khẩu mới
                        ItemCustomTextField(
                          label: 'change_password.new_password.label'.tr(),
                          controller: _newPasswordController,
                          textInputAction: TextInputAction.next,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureNewPassword = !_obscureNewPassword;
                                _newPasswordController.isObscured =
                                    _obscureNewPassword;
                              });
                            },
                            child: Icon(
                              _obscureNewPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: const Color(0xFF768079),
                              size: 19,
                            ),
                          ),
                          autocorrect: false,
                          enableSuggestions: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'change_password.new_password.error_empty'
                                  .tr();
                            }
                            if (value.length < 6) {
                              return 'change_password.error_min_length'.tr();
                            }

                            final oldPassword = _oldPasswordController.text;
                            if (oldPassword.isNotEmpty &&
                                _newPasswordController.text == oldPassword) {
                              return 'change_password.new_password.error_same_old'
                                  .tr();
                            }

                            final fieldErrors = context
                                .read<UserCubit>()
                                .state
                                .fieldErrors;
                            if (fieldErrors != null &&
                                fieldErrors.containsKey('new_password')) {
                              final errors = fieldErrors['new_password'];
                              if (errors is List && errors.isNotEmpty) {
                                return errors[0];
                              }
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        // 3. Xác nhận mật khẩu mới
                        ItemCustomTextField(
                          label: 'change_password.confirm_password.label'.tr(),
                          controller: _newPasswordConfirmController,
                          textInputAction: TextInputAction.done,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureConfirmNewPassword =
                                    !_obscureConfirmNewPassword;
                                _newPasswordConfirmController.isObscured =
                                    _obscureConfirmNewPassword;
                              });
                            },
                            child: Icon(
                              _obscureConfirmNewPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: const Color(0xFF768079),
                              size: 19,
                            ),
                          ),
                          autocorrect: false,
                          enableSuggestions: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'change_password.confirm_password.error_empty'
                                  .tr();
                            }
                            if (value.length < 6) {
                              return 'change_password.error_min_length'.tr();
                            }

                            final newPassword = _newPasswordController.text;
                            if (newPassword.isNotEmpty &&
                                _newPasswordConfirmController.text !=
                                    newPassword) {
                              return 'change_password.confirm_password.error_mismatch'
                                  .tr();
                            }

                            final fieldErrors = context
                                .read<UserCubit>()
                                .state
                                .fieldErrors;
                            if (fieldErrors != null &&
                                fieldErrors.containsKey(
                                  'new_password_confirm',
                                )) {
                              final errors =
                                  fieldErrors['new_password_confirm'];
                              if (errors is List && errors.isNotEmpty) {
                                return errors[0];
                              }
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BlocBuilder<UserCubit, UserState>(
        builder: (context, userState) {
          final isLoading = userState.status == UserStatus.loading;

          return Container(
            margin: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 30,
              top: 20,
            ),
            child: ItemBottomButton(
              text: 'change_password.btn_submit'.tr(),
              isLoading: isLoading,
              onTap: isLoading ? null : _submit,
            ),
          );
        },
      ),
    );
  }
}
