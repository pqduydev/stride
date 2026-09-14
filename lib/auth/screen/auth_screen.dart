import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:stride/auth/auth_cubit/auth_cubit.dart';
import 'package:stride/auth/auth_cubit/auth_state.dart';
import 'package:stride/auth/widget/item_custom_text_field.dart';
import 'package:stride/repository/auth_repository.dart';
import 'package:stride/widgets/appbar_custom.dart';
import 'package:stride/widgets/item_app_bar_title.dart';
import 'package:stride/widgets/item_bottom_button.dart';
import 'package:stride/widgets/item_social_button.dart';

// AuthScreen đóng vai trò bọc BlocProvider
class AuthScreen extends StatelessWidget {
  final bool isLogin;

  const AuthScreen({super.key, required this.isLogin});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(AuthRepository()),
      child: AuthView(isLogin: isLogin),
    );
  }
}

// AuthView chứa toàn bộ giao diện và logic UI
class AuthView extends StatefulWidget {
  final bool isLogin;

  const AuthView({super.key, required this.isLogin});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final _formKey = GlobalKey<FormState>();
  late bool _isLogin;

  String? _repositoryThrowError;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _mailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isLogin = widget.isLogin;

    // Lắng nghe thay đổi input để tự động xóa trạng
    // thái lỗi cũ, giúp nút bấm sumbit không bị đơ
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
    // Reset lỗi form cũ trước khi gửi request mới
    setState(() {});

    if (!_formKey.currentState!.validate()) return;

    final cubit = context.read<AuthCubit>();
    if (_isLogin) {
      cubit.login(
        email: _mailController.text.trim(),
        password: _passwordController.text,
      );
    } else {
      cubit.register(
        username: _usernameController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _mailController.text.trim(),
        password: _passwordController.text,
        passwordConfirm: _passwordConfirmController.text, // Thêm tham số này
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
          if (state.status == AuthStatus.failure) {
            // Ép form validate lại để các ItemCustomTextField đọc lỗi từ state.fieldErrors
            _formKey.currentState?.validate();

            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          } else if (state.status == AuthStatus.success) {
            if (state.status == AuthStatus.success && !_isLogin) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Đăng ký thành công! Vui lòng đăng nhập.",
                    style: TextStyle(color: Color(0xFF526C30)),
                  ),
                  backgroundColor: Color(0xFFEEF4E5),
                ),
              );

              // Đăng ký thành công -> Chuyển sang UI Đăng nhập
              setState(() {
                _isLogin = true;

                // Xóa trắng Form
                _firstNameController.clear();
                _lastNameController.clear();
                _usernameController.clear();
                _mailController.clear();
                _passwordController.clear();
                _lastNameController.clear();
                _passwordConfirmController.clear();
              });

              context.read<AuthCubit>().resetStatus();
            } else {
              // Đăng nhập thành công
              final currentUser = state.users.isNotEmpty
                  ? state.users.last
                  : null;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Đăng nhập thành công! Chào ${currentUser?.username ?? ''}",
                  ),
                  backgroundColor: const Color(0xFF526C30),
                ),
              );
              context.pop(context);
            }
          }
        },
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                          controller: _firstNameController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Vui lòng nhập họ';
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
                      const SizedBox(
                        width: 10,
                      ), // Khoảng cách giữa ô Họ và ô Tên
                      Expanded(
                        child: ItemCustomTextField(
                          label: 'Tên',
                          controller: _lastNameController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Vui lòng nhập tên';
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

                    // Biểu thức chính quy kiểm tra ràng buộc username
                    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]{3,20}$');
                    if (!usernameRegex.hasMatch(value.trim())) {
                      return 'Username từ 3-20 ký tự, chỉ gồm chữ, số và dấu _';
                    }

                    // Đọc lỗi từ Cubit/State do Django trả về
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
                      if (_repositoryThrowError != null) {
                        return _repositoryThrowError;
                      }

                      // Đọc lỗi từ Cubit/State do Django trả về
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
                ],
                const SizedBox(height: 3),
                ItemCustomTextField(
                  label: 'Mật khẩu',
                  controller: _passwordController,
                  suffixIcon: SvgPicture.asset(
                    "assets/icons/ic_lock.svg",
                    width: 19,
                    height: 19,
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.password],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mật khẩu';
                    }
                    if (value.length < 6) {
                      return 'Mật khẩu phải có ít nhất 6 ký tự';
                    }
                    if (_isLogin && _repositoryThrowError != null) {
                      return _repositoryThrowError;
                    }

                    // Đọc lỗi từ Cubit/State do Django trả về
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
                    obscureText: true,
                    suffixIcon: SvgPicture.asset(
                      "assets/icons/ic_lock.svg",
                      width: 19,
                      height: 19,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng xác nhận mật khẩu';
                      }
                      if (value != _passwordController.text) {
                        return 'Mật khẩu xác nhận không khớp';
                      }

                      // Kiểm tra lỗi trả về từ Django cho trường password_confirm
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
                ],
                const SizedBox(height: 3),
                if (_isLogin)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 10, 35, 35),
                        child: const Text(
                          "Quên mật khẩu?",
                          style: TextStyle(
                            color: Color(0xFF526C30),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SizedBox(height: 15),
                      Text(
                        "Dùng ít nhất 12 ký tự cho mật khẩu.",
                        style: TextStyle(
                          color: Color(0xFF768079),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 25),
                      Text(
                        "Khi tạo tài khoản, bạn đồng ý với",
                        style: TextStyle(
                          color: Color(0xFF768079),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Điều khoản sử dụng và Quyền riêng tư.",
                        style: TextStyle(
                          color: Color(0xFF526C30),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 40),
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
                      onTap: state.status == AuthStatus.loading
                          ? null
                          : _submit,
                    );
                  },
                ),
                if (_isLogin)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                        onTap: () {},
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
                  onTap: () {},
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
                  onTap: () {},
                ),
                const SizedBox(height: 35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isLogin = !_isLogin;
                          _formKey.currentState?.reset();
                        });

                        // Xóa trắng Form
                        _usernameController.clear();
                        _mailController.clear();
                        _passwordController.clear();
                        _firstNameController.clear();
                        _lastNameController.clear();

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
