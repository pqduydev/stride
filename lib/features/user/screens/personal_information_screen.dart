import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:stride/features/auth/auth_cubit/auth_cubit.dart';
import 'package:stride/features/auth/auth_cubit/auth_state.dart';
import 'package:stride/features/user/user_cubit/user_cubit.dart';
import 'package:stride/features/user/user_cubit/user_state.dart';
import 'package:stride/widgets/item_custom_text_field.dart';
import 'package:stride/widgets/appbar_custom.dart';
import 'package:stride/widgets/item_app_bar_title.dart';
import 'package:stride/widgets/item_bottom_button.dart';
import 'package:stride/widgets/item_date_time.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Khai báo các Controller
  late TextEditingController _usernameController;
  late TextEditingController _dateJoinedController;
  late TextEditingController _lastNameController;
  late TextEditingController _firstNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _bioController;

  DateTime? _selectedDateOfBirth;

  // Biến lưu trữ trạng thái ban đầu để so sánh Validator
  late String _initialLastName;
  late String _initialFirstName;
  late String _initialEmail;
  late String _initialPhone;
  late String _initialHeight;
  late String _initialWeight;

  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().resetStatus();
    final user = context.read<AuthCubit>().state.user;

    // Lưu lại trạng thái gốc của các trường bắt buộc
    _initialLastName = user?.lastName ?? '';
    _initialFirstName = user?.firstName ?? '';
    _initialEmail = user?.email ?? '';
    _initialPhone = user?.phone ?? '';
    _initialHeight = user?.heightCm?.toString().split('.').first ?? '';
    _initialWeight = user?.weightKg?.toString().split('.').first ?? '';

    // Khởi tạo Controller
    _usernameController = TextEditingController(text: user?.username ?? '');

    String joinedStr = '';
    if (user?.dateJoined != null) {
      joinedStr = DateFormat("dd/MM/yyyy HH:mm").format(user!.dateJoined!);
    }
    _dateJoinedController = TextEditingController(text: joinedStr);

    _lastNameController = TextEditingController(text: _initialLastName);
    _firstNameController = TextEditingController(text: _initialFirstName);
    _emailController = TextEditingController(text: _initialEmail);
    _phoneController = TextEditingController(text: _initialPhone);
    _heightController = TextEditingController(text: _initialHeight);
    _weightController = TextEditingController(text: _initialWeight);
    _bioController = TextEditingController(text: user?.bio ?? '');

    _selectedDateOfBirth = user?.dateOfBirth;

    final controllers = [
      _lastNameController,
      _firstNameController,
      _emailController,
      _phoneController,
      _heightController,
      _weightController,
      _bioController,
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
    _usernameController.dispose();
    _dateJoinedController.dispose();
    _lastNameController.dispose();
    _firstNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _submit() {
    final userCubit = context.read<UserCubit>();

    if (userCubit.state.status == UserStatus.failure ||
        (userCubit.state.fieldErrors?.isNotEmpty ?? false)) {
      userCubit.resetErrors();
    }

    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng kiểm tra lại các trường bị lỗi.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // Lấy dữ liệu người dùng đang lưu local để so sánh cập nhật
    final currentUser = context.read<AuthCubit>().state.user;
    final Map<String, dynamic> changedFields = {};

    // 1. First Name
    final currentFirstName = _firstNameController.text.trim();
    if (currentFirstName != (currentUser?.firstName ?? '')) {
      changedFields['first_name'] = currentFirstName;
    }

    // 2. Last Name
    final currentLastName = _lastNameController.text.trim();
    if (currentLastName != (currentUser?.lastName ?? '')) {
      changedFields['last_name'] = currentLastName;
    }

    // 3. Email
    final currentEmail = _emailController.text.trim();
    if (currentEmail != (currentUser?.email ?? '')) {
      changedFields['email'] = currentEmail;
    }

    // 4. Phone
    final currentPhone = _phoneController.text.trim();
    if (currentPhone != (currentUser?.phone ?? '')) {
      changedFields['phone'] = currentPhone;
    }

    // 5. Date of Birth (Định dạng YYYY-MM-DD theo API spec)
    if (_selectedDateOfBirth != currentUser?.dateOfBirth) {
      changedFields['date_of_birth'] = _selectedDateOfBirth != null
          ? DateFormat('yyyy-MM-dd').format(_selectedDateOfBirth!)
          : null;
    }

    // 6. Height
    final currentHeight = double.tryParse(_heightController.text.trim());
    if (currentHeight != currentUser?.heightCm) {
      changedFields['height_cm'] = currentHeight;
    }

    // 7. Weight
    final currentWeight = double.tryParse(_weightController.text.trim());
    if (currentWeight != currentUser?.weightKg) {
      changedFields['weight_kg'] = currentWeight;
    }

    // 8. Bio
    final currentBio = _bioController.text.trim();
    if (currentBio != (currentUser?.bio ?? '')) {
      changedFields['bio'] = currentBio;
    }

    // Kiểm tra người dùng có thay đổi thông tin chưa
    if (changedFields.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Không có thông tin nào thay đổi.',
            style: TextStyle(color: Color(0xFFFFFFFF)),
          ),
          backgroundColor: Colors.orangeAccent,
        ),
      );

      return;
    }

    context.read<UserCubit>().updateProfile(changedFields);
  }

  @override
  Widget build(BuildContext context) {
    // Giới hạn 16 tuổi cho DatePicker
    final today = DateTime.now();
    final maxAllowedDate = DateTime(today.year - 16, today.month, today.day);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppbarCustom(title: ItemAppBarTitle(data: 'Thông tin cá nhân')),
      ),
      body: BlocListener<UserCubit, UserState>(
        listener: (context, state) {
          if (state.status == UserStatus.success) {
            if (state.user != null) {
              // Đồng bộ dữ liệu mới nhất sang AuthCubit
              context.read<AuthCubit>().updateUserInMemory(state.user!);
            }

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Cập nhật thông tin thành công!',
                  style: TextStyle(color: Color(0xFF526C30)),
                ),
                backgroundColor: Color(0xFFEEF4E5),
              ),
            );

            context.pop();
          } else if (state.status == UserStatus.failure) {
            _formKey.currentState?.validate();
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 15,
              left: 20,
              right: 20,
              bottom: 40,
            ),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                const Text(
                  'Thông tin giúp nhắc hẹn và gợi ý phù hợp.',
                  style: TextStyle(
                    color: Color(0xFF768079),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                BlocBuilder<UserCubit, UserState>(
                  builder: (context, userState) {
                    final isLoading = userState.status == UserStatus.loading;
                    final user = userState.user;
                    final initials = user?.displayInitials;

                    return AbsorbPointer(
                      absorbing: isLoading,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Center(
                              child: Container(
                                width: 74,
                                height: 74,
                                margin: const EdgeInsets.only(
                                  top: 35,
                                  bottom: 40,
                                ),
                                alignment: .center,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEEF4E5),
                                  borderRadius: BorderRadius.circular(38),
                                ),
                                child: Text(
                                  initials ?? '',
                                  style: const TextStyle(
                                    color: Color(0xFF526C30),
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),

                            // Username
                            ItemCustomTextField(
                              label: 'Tên người dùng',
                              controller: _usernameController,
                              readOnly: true,
                              backgroundColor: 0xFFEEF4E5,
                            ),
                            const SizedBox(height: 5),

                            // Date Joined
                            ItemCustomTextField(
                              label: 'Ngày tham gia',
                              controller: _dateJoinedController,
                              readOnly: true,
                              backgroundColor: 0xFFEEF4E5,
                            ),
                            const SizedBox(height: 5),

                            // Last Name
                            ItemCustomTextField(
                              label: 'Họ',
                              controller: _lastNameController,
                              suffixIcon: SvgPicture.asset(
                                "assets/icons/ic_user.svg",
                                width: 19,
                                height: 19,
                              ),
                              validator: (_) {
                                // Lấy dữ liệu hiện tại
                                final currentValue = _lastNameController.text
                                    .trim();

                                if (currentValue.isEmpty) {
                                  // Nếu ban đầu có dữ liệu mà giờ xóa rỗng -> Lỗi
                                  if (_initialLastName.isNotEmpty) {
                                    return 'Vui lòng không để trống họ';
                                  }
                                  // Nếu ban đầu rỗng sẵn -> Hợp lệ
                                  return null;
                                }

                                final fieldErrors = context
                                    .read<UserCubit>()
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
                            const SizedBox(height: 5),

                            // First Name
                            ItemCustomTextField(
                              label: 'Tên',
                              controller: _firstNameController,
                              suffixIcon: SvgPicture.asset(
                                "assets/icons/ic_user.svg",
                                width: 19,
                                height: 19,
                              ),
                              validator: (_) {
                                // Lấy dữ liệu hiện tại
                                final currentValue = _firstNameController.text
                                    .trim();

                                if (currentValue.isEmpty) {
                                  // Nếu ban đầu có dữ liệu mà giờ xóa rỗng -> Lỗi
                                  if (_initialFirstName.isNotEmpty) {
                                    return 'Vui lòng không để trống tên';
                                  }
                                  // Nếu ban đầu rỗng sẵn -> Hợp lệ
                                  return null;
                                }

                                final fieldErrors = context
                                    .read<UserCubit>()
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
                            const SizedBox(height: 5),

                            // Email
                            ItemCustomTextField(
                              label: 'Email liên hệ',
                              controller: _emailController,
                              suffixIcon: SvgPicture.asset(
                                "assets/icons/ic_mail.svg",
                                width: 19,
                                height: 19,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (_) {
                                // Lấy dữ liệu hiện tại
                                final currentValue = _emailController.text
                                    .trim();

                                if (currentValue.isEmpty) {
                                  // Nếu ban đầu có dữ liệu mà giờ xóa rỗng -> Lỗi
                                  if (_initialEmail.isNotEmpty) {
                                    return 'Vui lòng không để trống email';
                                  }
                                  // Nếu ban đầu rỗng sẵn -> Hợp lệ
                                  return null;
                                }

                                final emailRegex = RegExp(
                                  r'^[a-z0-9_\-\.]+@([a-z0-9\-]+\.)+[a-z]{2,4}$',
                                );
                                if (!emailRegex.hasMatch(currentValue)) {
                                  return 'Email không đúng định dạng';
                                }

                                final fieldErrors = context
                                    .read<UserCubit>()
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
                            const SizedBox(height: 5),

                            // Phone
                            ItemCustomTextField(
                              label: 'Số điện thoại (+84)',
                              controller: _phoneController,
                              suffixIcon: SvgPicture.asset(
                                "assets/icons/ic_phone.svg",
                                width: 19,
                                height: 19,
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (_) {
                                // Lấy dữ liệu hiện tại
                                final currentValue = _phoneController.text
                                    .trim();

                                if (currentValue.isEmpty) {
                                  // Nếu ban đầu có dữ liệu mà giờ xóa rỗng -> Lỗi
                                  if (_initialPhone.isNotEmpty) {
                                    return 'Vui lòng không để trống số điện thoại';
                                  }
                                  // Nếu ban đầu rỗng sẵn -> Hợp lệ
                                  return null;
                                }

                                final phoneRegex = RegExp(r'^[35789]\d{8}$');
                                if (!phoneRegex.hasMatch(currentValue)) {
                                  return 'Số điện thoại không hợp lệ';
                                }

                                final fieldErrors = context
                                    .read<UserCubit>()
                                    .state
                                    .fieldErrors;
                                if (fieldErrors != null &&
                                    fieldErrors.containsKey('phone')) {
                                  final errors = fieldErrors['phone'];
                                  if (errors is List && errors.isNotEmpty) {
                                    return errors[0];
                                  }
                                }
                                return null;
                              },
                            ),

                            // Date of Birth
                            ItemDateTime(
                              label: 'Ngày sinh',
                              initialDate: _selectedDateOfBirth,
                              lastDate: maxAllowedDate,
                              onDateSelected: (date) {
                                setState(() {
                                  _selectedDateOfBirth = date;
                                });

                                // Xóa lỗi nếu đang có lỗi API
                                final state = context.read<UserCubit>().state;
                                if (state.status == UserStatus.failure ||
                                    (state.fieldErrors?.isNotEmpty ?? false)) {
                                  context.read<UserCubit>().resetErrors();
                                }
                              },
                            ),

                            const SizedBox(height: 23),

                            // Height & Weight
                            Row(
                              children: [
                                Expanded(
                                  child: ItemCustomTextField(
                                    label: 'Chiều cao (cm)',
                                    controller: _heightController,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    validator: (_) {
                                      // Lấy dữ liệu hiện tại
                                      final currentValue = _heightController
                                          .text
                                          .trim();

                                      // Kiểm tra rỗng khi ban đầu đã có dữ liệu
                                      if (currentValue.isEmpty) {
                                        // Nếu ban đầu có dữ liệu mà giờ xóa rỗng -> Lỗi
                                        if (_initialHeight.isNotEmpty) {
                                          return 'Vui lòng không để trống chiều cao';
                                        }
                                        // Nếu ban đầu rỗng sẵn -> Hợp lệ
                                        return null;
                                      }

                                      // Kiểm tra kiểu dữ liệu số
                                      if (double.tryParse(currentValue) ==
                                          null) {
                                        return 'Phải là số';
                                      }

                                      final fieldErrors = context
                                          .read<UserCubit>()
                                          .state
                                          .fieldErrors;
                                      if (fieldErrors != null &&
                                          fieldErrors.containsKey(
                                            'height_cm',
                                          )) {
                                        final errors = fieldErrors['height_cm'];
                                        if (errors is List &&
                                            errors.isNotEmpty) {
                                          return errors[0];
                                        }
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ItemCustomTextField(
                                    label: 'Cân nặng (kg)',
                                    controller: _weightController,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    validator: (_) {
                                      // Lấy dữ liệu hiện tại
                                      final currentValue = _weightController
                                          .text
                                          .trim();

                                      // Kiểm tra rỗng khi ban đầu đã có dữ liệu
                                      if (currentValue.isEmpty) {
                                        // Nếu ban đầu có dữ liệu mà giờ xóa rỗng -> Lỗi
                                        if (_initialWeight.isNotEmpty) {
                                          return 'Vui lòng không để trống cân nặng';
                                        }
                                        // Nếu ban đầu rỗng sẵn -> Hợp lệ

                                        return null;
                                      }

                                      // Kiểm tra kiểu dữ liệu số
                                      if (double.tryParse(currentValue) ==
                                          null) {
                                        return 'Phải là số';
                                      }

                                      final fieldErrors = context
                                          .read<UserCubit>()
                                          .state
                                          .fieldErrors;
                                      if (fieldErrors != null &&
                                          fieldErrors.containsKey(
                                            'weight_kg',
                                          )) {
                                        final errors = fieldErrors['weight_kg'];
                                        if (errors is List &&
                                            errors.isNotEmpty) {
                                          return errors[0];
                                        }
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),

                            // Bio
                            ItemCustomTextField(
                              label: 'Tiểu sử',
                              controller: _bioController,
                              textInputAction: TextInputAction.done,
                              height: 120,
                              maxLines: 3,
                              validator: (_) {
                                final fieldErrors = context
                                    .read<UserCubit>()
                                    .state
                                    .fieldErrors;
                                if (fieldErrors != null &&
                                    fieldErrors.containsKey('bio')) {
                                  final errors = fieldErrors['bio'];
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
                    );
                  },
                ),
              ],
            ),
          ),
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
              text: 'Lưu thay đổi',
              isLoading: isLoading,
              onTap: isLoading ? null : _submit,
            ),
          );
        },
      ),
    );
  }
}
