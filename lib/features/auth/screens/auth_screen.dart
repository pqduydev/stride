import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:stride/features/auth/auth_cubit/auth_cubit.dart';
import 'package:stride/features/auth/auth_cubit/auth_state.dart';
import 'package:stride/widgets/item_custom_text_field.dart';
import 'package:stride/core/utils/instant_obscure_controller.dart';
import 'package:stride/widgets/appbar_custom.dart';
import 'package:stride/widgets/item_app_bar_title.dart';
import 'package:stride/widgets/item_bottom_button.dart';
import 'package:stride/widgets/item_social_button.dart';

class AuthScreen extends StatelessWidget {
  final bool isLogin;

  const AuthScreen({super.key, required this.isLogin});

  @override
  Widget build(BuildContext context) {
    return AuthView(isLogin: isLogin);
  }
}

class AuthView extends StatefulWidget {
  final bool isLogin;

  const AuthView({super.key, required this.isLogin});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
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
        if (context.read<AuthCubit>().state.status == AuthStatus.failure) {
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
    if (!_formKey.currentState!.validate()) return;

    final cubit = context.read<AuthCubit>();
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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppbarCustom(
          title: ItemAppBarTitle(
            data: _isLogin ? "Đăng nhập" : "Tạo tài khoản",
          ),
        ),
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            context.go('/main_navigation_bar');
          } else if (state.status == AuthStatus.failure) {
            _formKey.currentState?.validate();

            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          } else if (state.status == AuthStatus.success && !_isLogin) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Đăng ký thành công! Vui lòng đăng nhập.",
                  style: TextStyle(color: Color(0xFF526C30)),
                ),
                backgroundColor: Color(0xFFEEF4E5),
              ),
            );

            setState(() {
              _isLogin = true;

              // Clear các field
              _firstNameController.clear();
              _lastNameController.clear();
              _usernameController.clear();
              _mailController.clear();
              _passwordController.clear();
              _passwordConfirmController.clear();

              // Đặt lại trạng thái icon
              _obscurePassword = true;
              _obscureConfirmPassword = true;

              // Cập nhật trạng thái cho controller
              _passwordController.isObscured = true;
              _passwordConfirmController.isObscured = true;
            });

            context.read<AuthCubit>().resetStatus();
          }
        },
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  _isLogin
                      ? "Chào mừng bạn trở lại. Tiếp tục hành trình nhé!"
                      : "Bắt đầu hành trình của riêng bạn.",
                  style: const TextStyle(
                    color: Color(0xFF768079),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 30),
                if (!_isLogin) ...[
                  Row(
                    children: [
                      Expanded(
                        child: ItemCustomTextField(
                          label: 'Họ',
                          controller: _lastNameController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Vui lòng nhập họ';
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
                          label: 'Tên',
                          controller: _firstNameController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Vui lòng nhập tên';
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
                  label: 'Tên đăng nhập',
                  controller: _usernameController,
                  suffixIcon: SvgPicture.asset(
                    "assets/icons/ic_user.svg",
                    width: 19,
                    height: 19,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập tên đăng nhập';
                    }
                    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]{3,20}$');
                    if (!usernameRegex.hasMatch(value.trim())) {
                      return 'Username từ 3-20 ký tự, chỉ gồm chữ, số và dấu _';
                    }
                    final fieldErrors = context
                        .read<AuthCubit>()
                        .state
                        .fieldErrors;
                    if (fieldErrors != null &&
                        fieldErrors.containsKey('username')) {
                      final errors = fieldErrors['username'];
                      if (errors is List && errors.isNotEmpty) return errors[0];
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 3),
                if (!_isLogin) ...[
                  ItemCustomTextField(
                    label: 'Email',
                    controller: _mailController,
                    suffixIcon: SvgPicture.asset(
                      "assets/icons/ic_mail.svg",
                      width: 19,
                      height: 19,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Vui lòng nhập email';
                      }
                      final emailRegex = RegExp(
                        r'^[a-z0-9_\-\.]+@([a-z0-9\-]+\.)+[a-z]{2,4}$',
                      );
                      if (!emailRegex.hasMatch(value.trim())) {
                        return 'Email không đúng định dạng';
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
                  label: 'Mật khẩu',
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
                      color: const Color(0xFF768079),
                      size: 19,
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  autocorrect: false,
                  enableSuggestions: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mật khẩu';
                    }
                    if (value.length < 6) {
                      return 'Mật khẩu phải có ít nhất 6 ký tự';
                    }
                    final fieldErrors = context
                        .read<AuthCubit>()
                        .state
                        .fieldErrors;
                    if (fieldErrors != null &&
                        fieldErrors.containsKey('password')) {
                      final errors = fieldErrors['password'];
                      if (errors is List && errors.isNotEmpty) return errors[0];
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 3),
                if (!_isLogin) ...[
                  ItemCustomTextField(
                    label: 'Xác nhận mật khẩu',
                    controller: _passwordConfirmController,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                          _passwordConfirmController.isObscured =
                              _obscureConfirmPassword;
                        });
                      },
                      child: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: const Color(0xFF768079),
                        size: 19,
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    autocorrect: false,
                    enableSuggestions: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng xác nhận mật khẩu';
                      }
                      if (value != _passwordController.text) {
                        return 'Mật khẩu xác nhận không khớp';
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
                          onTap: () => context.push('/login/forget_password'),
                          child: Text(
                            "Quên mật khẩu?",
                            style: TextStyle(
                              color: Color(0xFF526C30),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
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
                      const Text(
                        "Dùng ít nhất 6 ký tự cho mật khẩu.",
                        style: TextStyle(
                          color: Color(0xFF768079),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 25),
                      const Text(
                        "Khi tạo tài khoản, bạn đồng ý với",
                        style: TextStyle(
                          color: Color(0xFF768079),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () => context.push('/register/privacy'),
                        child: const Text(
                          "Điều khoản sử dụng và Quyền riêng tư.",
                          style: TextStyle(
                            color: Color(0xFF526C30),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    if (state.status == AuthStatus.loading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF526C30),
                        ),
                      );
                    }
                    return ItemBottomButton(
                      text: _isLogin ? "Đăng nhập" : "Tạo tài khoản bằng email",
                      onTap: _submit,
                    );
                  },
                ),
                if (_isLogin)
                  Column(
                    crossAxisAlignment: .center,
                    children: [
                      const SizedBox(height: 30),
                      const Text(
                        "HOẶC TIẾP TỤC BẰNG",
                        style: TextStyle(
                          color: Color(0xFF768079),
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 30),
                      ItemSocialButton(
                        text: 'Số điện thoại',
                        fontWeight: FontWeight.w700,
                        backgroundColor: const Color(0xFFFFFFFF),
                        textColor: const Color(0xFF526C30),
                        icon: SvgPicture.asset(
                          "assets/icons/ic_phone.svg",
                          width: 20,
                          height: 20,
                        ),
                        borderColor: const Color(0xFFE8ECE8),
                        onTap: () =>
                            context.push('/login/login_with_phone_number'),
                      ),
                    ],
                  ),
                const SizedBox(height: 15),
                ItemSocialButton(
                  text: 'Tiếp tục với Google',
                  backgroundColor: const Color(0xFFFFFFFF),
                  textColor: const Color(0xFF1F1F1F),
                  icon: SvgPicture.asset(
                    "assets/icons/ic_google.svg",
                    width: 20,
                    height: 20,
                  ),
                  borderColor: const Color(0xFF747775),
                  onTap: () => context.push('/register/login_with_google'),
                ),
                const SizedBox(height: 15),
                ItemSocialButton(
                  text: 'Tiếp tục với Apple',
                  backgroundColor: const Color(0xFF000000),
                  textColor: const Color(0xFFFFFFFF),
                  icon: SvgPicture.asset(
                    "assets/icons/ic_apple.svg",
                    width: 20,
                    height: 20,
                  ),
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

                        // Đặt lại trạng thái icon
                        _obscurePassword = true;
                        _obscureConfirmPassword = true;

                        // Cập nhật trạng thái cho controller
                        _passwordController.isObscured = true;
                        _passwordConfirmController.isObscured = true;

                        context.read<AuthCubit>().resetStatus();
                      },
                      child: Text(
                        _isLogin
                            ? "Chưa có tài khoản? Đăng ký"
                            : "Đã có tài khoản? Đăng nhập",
                        style: const TextStyle(
                          color: Color(0xFF526C30),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
