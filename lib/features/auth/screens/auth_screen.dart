import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:stride/core/theme/app_colors.dart';
import 'package:stride/core/utils/app_toast.dart';
import 'package:stride/features/auth/auth_cubit/auth_cubit.dart';
import 'package:stride/features/auth/auth_cubit/auth_state.dart';
import 'package:stride/widgets/item_custom_text_field.dart';
import 'package:stride/core/utils/instant_obscure_controller.dart';
import 'package:stride/widgets/appbar_custom.dart';
import 'package:stride/widgets/item_app_bar_title.dart';
import 'package:stride/widgets/item_bottom_button.dart';
import 'package:stride/widgets/item_social_button.dart';

class AuthScreen extends StatefulWidget {
  final bool isLogin;

  const AuthScreen({super.key, required this.isLogin});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  late bool _isLogin;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _mailController = TextEditingController();
  final _passwordController = InstantObscureController();
  final _passwordConfirmController = InstantObscureController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _isLogin = widget.isLogin;

    final controllers = [
      _usernameController,
      _firstNameController,
      _lastNameController,
      _mailController,
      _passwordController,
      _passwordConfirmController,
    ];

    for (var controller in controllers) {
      controller.addListener(() {
        final state = context.read<AuthCubit>().state;
        if (state.status == AuthStatus.failure ||
            (state.fieldErrors?.isNotEmpty ?? false)) {
          context.read<AuthCubit>().resetErrors();
        }
      });
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _mailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  void _submit() {
    final cubit = context.read<AuthCubit>();

    if (cubit.state.status == AuthStatus.failure ||
        cubit.state.fieldErrors != null) {
      cubit.resetErrors();
    }

    if (!_formKey.currentState!.validate()) return;

    if (_isLogin) {
      cubit.login(
        username: _usernameController.text,
        password: _passwordController.text,
      );
    } else {
      cubit.register(
        username: _usernameController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _mailController.text.trim(),
        password: _passwordController.text,
        passwordConfirm: _passwordConfirmController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>() ?? AppColors.light;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppbarCustom(
          title: ItemAppBarTitle(
            data: _isLogin
                ? 'auth.login_title'.tr()
                : 'auth.register_title'.tr(),
          ),
        ),
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.failure &&
              state.errorMessage != null) {
            _formKey.currentState?.validate();

            if (state.errorMessage != null) {
              AppToast.showError(context, state.errorMessage!);
            }
          } else if (state.status == AuthStatus.success && !_isLogin) {
            AppToast.showSuccess(context, 'auth.register_success'.tr());

            setState(() {
              _isLogin = true;
              _firstNameController.clear();
              _lastNameController.clear();
              _usernameController.clear();
              _mailController.clear();
              _passwordController.clear();
              _passwordConfirmController.clear();

              _obscurePassword = true;
              _obscureConfirmPassword = true;

              _passwordController.isObscured = true;
              _passwordConfirmController.isObscured = true;
            });

            context.read<AuthCubit>().resetStatus();
          }
        },
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            final isLoading = state.status == AuthStatus.loading;

            return AbsorbPointer(
              absorbing: isLoading,
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        _isLogin
                            ? 'auth.login_welcome'.tr()
                            : 'auth.register_welcome'.tr(),
                        style: TextStyle(
                          color: colors.muted,
                          fontSize: 14,
                          fontWeight: .w400,
                        ),
                      ),
                      const SizedBox(height: 30),
                      if (!_isLogin) ...[
                        Row(
                          children: [
                            Expanded(
                              child: ItemCustomTextField(
                                label: 'auth.fields.last_name'.tr(),
                                controller: _lastNameController,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'auth.validation.empty_last_name'
                                        .tr();
                                  }
                                  final fieldErrors = context
                                      .read<AuthCubit>()
                                      .state
                                      .fieldErrors;
                                  if (fieldErrors != null &&
                                      fieldErrors.containsKey('last_name')) {
                                    final errors = fieldErrors['last_name'];
                                    if (errors is List && errors.isNotEmpty) {
                                      return errors[0];
                                    }
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ItemCustomTextField(
                                label: 'auth.fields.first_name'.tr(),
                                controller: _firstNameController,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'auth.validation.empty_first_name'
                                        .tr();
                                  }
                                  final fieldErrors = context
                                      .read<AuthCubit>()
                                      .state
                                      .fieldErrors;
                                  if (fieldErrors != null &&
                                      fieldErrors.containsKey('first_name')) {
                                    final errors = fieldErrors['first_name'];
                                    if (errors is List && errors.isNotEmpty) {
                                      return errors[0];
                                    }
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                      ],
                      ItemCustomTextField(
                        label: 'auth.fields.username'.tr(),
                        controller: _usernameController,
                        suffixIcon: SvgPicture.asset(
                          "assets/icons/ic_user.svg",
                          width: 19,
                          height: 19,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'auth.validation.empty_username'.tr();
                          }
                          final usernameRegex = RegExp(r'^[a-zA-Z0-9_]{3,20}$');
                          if (!usernameRegex.hasMatch(value.trim())) {
                            return 'auth.validation.username_invalid'.tr();
                          }
                          final fieldErrors = context
                              .read<AuthCubit>()
                              .state
                              .fieldErrors;
                          if (fieldErrors != null &&
                              fieldErrors.containsKey('username')) {
                            final errors = fieldErrors['username'];
                            if (errors is List && errors.isNotEmpty) {
                              return errors[0];
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 3),
                      if (!_isLogin) ...[
                        ItemCustomTextField(
                          label: 'auth.fields.email'.tr(),
                          controller: _mailController,
                          suffixIcon: SvgPicture.asset(
                            "assets/icons/ic_mail.svg",
                            width: 19,
                            height: 19,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'auth.validation.empty_email'.tr();
                            }
                            final emailRegex = RegExp(
                              r'^[a-z0-9_\-\.]+@([a-z0-9\-]+\.)+[a-z]{2,4}$',
                            );
                            if (!emailRegex.hasMatch(value.trim())) {
                              return 'auth.validation.email_invalid'.tr();
                            }
                            final fieldErrors = context
                                .read<AuthCubit>()
                                .state
                                .fieldErrors;
                            if (fieldErrors != null &&
                                fieldErrors.containsKey('email')) {
                              final errors = fieldErrors['email'];
                              if (errors is List && errors.isNotEmpty) {
                                return errors[0];
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 3),
                      ],
                      ItemCustomTextField(
                        label: 'auth.fields.password'.tr(),
                        controller: _passwordController,
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                              _passwordController.isObscured = _obscurePassword;
                            });
                          },
                          child: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: colors.muted,
                            size: 19,
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        autocorrect: false,
                        enableSuggestions: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'auth.validation.empty_password'.tr();
                          }
                          if (value.length < 6) {
                            return 'auth.validation.password_too_short'.tr();
                          }
                          final fieldErrors = context
                              .read<AuthCubit>()
                              .state
                              .fieldErrors;
                          if (fieldErrors != null &&
                              fieldErrors.containsKey('password')) {
                            final errors = fieldErrors['password'];
                            if (errors is List && errors.isNotEmpty) {
                              return errors[0];
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 3),
                      if (!_isLogin) ...[
                        ItemCustomTextField(
                          label: 'auth.fields.password_confirm'.tr(),
                          controller: _passwordConfirmController,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                                _passwordConfirmController.isObscured =
                                    _obscureConfirmPassword;
                              });
                            },
                            child: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: colors.muted,
                              size: 19,
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          autocorrect: false,
                          enableSuggestions: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'auth.validation.empty_password_confirm'
                                  .tr();
                            }
                            if (value != _passwordController.text) {
                              return 'auth.validation.password_mismatch'.tr();
                            }
                            final fieldErrors = context
                                .read<AuthCubit>()
                                .state
                                .fieldErrors;
                            if (fieldErrors != null &&
                                fieldErrors.containsKey('password_confirm')) {
                              final errors = fieldErrors['password_confirm'];
                              if (errors is List && errors.isNotEmpty) {
                                return errors[0];
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 3),
                      ],
                      if (_isLogin)
                        Row(
                          mainAxisAlignment: .end,
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(0, 10, 35, 35),
                              child: InkWell(
                                onTap: () =>
                                    context.push('/login/forget_password'),
                                child: Text(
                                  'auth.actions.forgot_password'.tr(),
                                  style: TextStyle(
                                    color: colors.green,
                                    fontSize: 13,
                                    fontWeight: .w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      else
                        Column(
                          crossAxisAlignment: .start,
                          children: [
                            const SizedBox(height: 15),
                            Text(
                              'auth.hints.password_hint'.tr(),
                              style: TextStyle(
                                color: colors.muted,
                                fontSize: 12,
                                fontWeight: .w400,
                              ),
                            ),
                            const SizedBox(height: 25),
                            Text(
                              'auth.terms.agreement_prefix'.tr(),
                              style: TextStyle(
                                color: colors.muted,
                                fontSize: 12,
                                fontWeight: .w400,
                              ),
                            ),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: () => context.push('/register/privacy'),
                              child: Text(
                                'auth.terms.agreement_link'.tr(),
                                style: TextStyle(
                                  color: colors.green,
                                  fontSize: 12,
                                  fontWeight: .w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),

                      if (isLoading)
                        Center(
                          child: CircularProgressIndicator(color: colors.green),
                        )
                      else
                        ItemBottomButton(
                          text: _isLogin
                              ? 'auth.buttons.login'.tr()
                              : 'auth.buttons.register_email'.tr(),
                          onTap: _submit,
                        ),

                      if (_isLogin)
                        Column(
                          crossAxisAlignment: .center,
                          children: [
                            const SizedBox(height: 30),
                            Text(
                              'auth.social.divider'.tr(),
                              style: TextStyle(
                                color: colors.muted,
                                fontSize: 13.5,
                                fontWeight: .w600,
                              ),
                            ),
                            const SizedBox(height: 30),
                            ItemSocialButton(
                              text: 'auth.social.phone'.tr(),
                              fontWeight: .w700,
                              backgroundColor: colors.surface,
                              textColor: colors.green,
                              icon: SvgPicture.asset(
                                "assets/icons/ic_phone.svg",
                                width: 20,
                                height: 20,
                              ),
                              borderColor: colors.line,
                              onTap: () => context.push(
                                '/login/login_with_phone_number',
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 15),
                      ItemSocialButton(
                        text: 'auth.social.google'.tr(),
                        backgroundColor: colors.surface,
                        textColor: colors.ink,
                        icon: SvgPicture.asset(
                          "assets/icons/ic_google.svg",
                          width: 20,
                          height: 20,
                        ),
                        borderColor: colors.muted,
                        onTap: () =>
                            context.push('/register/login_with_google'),
                      ),
                      const SizedBox(height: 15),
                      ItemSocialButton(
                        text: 'auth.social.apple'.tr(),
                        // Dùng màu surface cho nền ở Dark Mode và ink ở Light Mode để nút luôn nổi bật tương phản tốt
                        backgroundColor: isDarkMode
                            ? colors.surface
                            : colors.ink,
                        textColor: isDarkMode ? colors.ink : colors.surface,
                        icon: SvgPicture.asset(
                          "assets/icons/ic_apple.svg",
                          width: 20,
                          height: 20,
                          colorFilter: ColorFilter.mode(
                            isDarkMode ? colors.ink : colors.surface,
                            BlendMode.srcIn,
                          ),
                        ),
                        borderColor: isDarkMode ? colors.line : null,
                        onTap: () => context.push('/register/login_with_apple'),
                      ),
                      const SizedBox(height: 35),
                      Row(
                        mainAxisAlignment: .center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isLogin = !_isLogin;
                                _formKey.currentState?.reset();
                              });

                              _usernameController.clear();
                              _mailController.clear();
                              _passwordController.clear();
                              _passwordConfirmController.clear();
                              _firstNameController.clear();
                              _lastNameController.clear();

                              _obscurePassword = true;
                              _obscureConfirmPassword = true;

                              _passwordController.isObscured = true;
                              _passwordConfirmController.isObscured = true;

                              context.read<AuthCubit>().resetStatus();
                            },
                            child: Text(
                              _isLogin
                                  ? 'auth.switches.to_register'.tr()
                                  : 'auth.switches.to_login'.tr(),
                              style: TextStyle(
                                color: colors.green,
                                fontSize: 13,
                                fontWeight: .w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
