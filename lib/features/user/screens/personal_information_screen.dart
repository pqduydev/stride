import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:stride/core/utils/app_toast.dart';
import 'package:stride/features/auth/auth_cubit/auth_cubit.dart';
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

    _initialLastName = user?.lastName ?? '';
    _initialFirstName = user?.firstName ?? '';
    _initialEmail = user?.email ?? '';
    _initialPhone = user?.phone ?? '';
    _initialHeight = user?.heightCm?.toString().split('.').first ?? '';
    _initialWeight = user?.weightKg?.toString().split('.').first ?? '';

    _usernameController = TextEditingController(text: user?.username ?? '');

    String joinedStr = '';
    if (user?.dateJoined != null) {
      joinedStr = DateFormat("dd/MM/yyyy").format(user!.dateJoined!);
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
      AppToast.showError(context, 'personal_info.error_check_fields'.tr());
      return;
    }

    final currentUser = context.read<AuthCubit>().state.user;
    final Map<String, dynamic> changedFields = {};

    final currentFirstName = _firstNameController.text.trim();
    if (currentFirstName != (currentUser?.firstName ?? '')) {
      changedFields['first_name'] = currentFirstName;
    }

    final currentLastName = _lastNameController.text.trim();
    if (currentLastName != (currentUser?.lastName ?? '')) {
      changedFields['last_name'] = currentLastName;
    }

    final currentEmail = _emailController.text.trim();
    if (currentEmail != (currentUser?.email ?? '')) {
      changedFields['email'] = currentEmail;
    }

    final currentPhone = _phoneController.text.trim();
    if (currentPhone != (currentUser?.phone ?? '')) {
      changedFields['phone'] = currentPhone;
    }

    if (_selectedDateOfBirth != currentUser?.dateOfBirth) {
      changedFields['date_of_birth'] = _selectedDateOfBirth != null
          ? DateFormat('yyyy-MM-dd').format(_selectedDateOfBirth!)
          : null;
    }

    final currentHeight = double.tryParse(_heightController.text.trim());
    if (currentHeight != currentUser?.heightCm) {
      changedFields['height_cm'] = currentHeight;
    }

    final currentWeight = double.tryParse(_weightController.text.trim());
    if (currentWeight != currentUser?.weightKg) {
      changedFields['weight_kg'] = currentWeight;
    }

    final currentBio = _bioController.text.trim();
    if (currentBio != (currentUser?.bio ?? '')) {
      changedFields['bio'] = currentBio;
    }

    if (changedFields.isEmpty) {
      AppToast.showWarning(context, 'personal_info.warning_no_changes'.tr());
      return;
    }

    context.read<UserCubit>().updateProfile(changedFields);
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final maxAllowedDate = DateTime(today.year - 16, today.month, today.day);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppbarCustom(
          title: ItemAppBarTitle(data: 'personal_info.appbar_title'.tr()),
        ),
      ),
      body: BlocListener<UserCubit, UserState>(
        listener: (context, state) {
          if (state.status == UserStatus.success) {
            if (state.user != null) {
              context.read<AuthCubit>().updateUserInMemory(state.user!);
            }

            AppToast.showSuccess(context, 'personal_info.success_update'.tr());
            context.pop();
          } else if (state.status == UserStatus.failure) {
            _formKey.currentState?.validate();
            if (state.errorMessage != null) {
              AppToast.showError(context, state.errorMessage!);
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
                Text(
                  'personal_info.subtitle'.tr(),
                  style: const TextStyle(
                    color: Color(0xFF768079),
                    fontSize: 14,
                    fontWeight: .w400,
                  ),
                ),
                BlocBuilder<UserCubit, UserState>(
                  builder: (context, userState) {
                    final isLoading = userState.status == UserStatus.loading;
                    final user =
                        userState.user ?? context.read<AuthCubit>().state.user;
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
                                    fontWeight: .w700,
                                  ),
                                ),
                              ),
                            ),

                            // Username
                            ItemCustomTextField(
                              label: 'personal_info.username'.tr(),
                              controller: _usernameController,
                              readOnly: true,
                              backgroundColor: 0xFFEEF4E5,
                            ),
                            const SizedBox(height: 5),

                            // Date Joined
                            ItemCustomTextField(
                              label: 'personal_info.date_joined'.tr(),
                              controller: _dateJoinedController,
                              readOnly: true,
                              backgroundColor: 0xFFEEF4E5,
                            ),
                            const SizedBox(height: 5),

                            // Last Name
                            ItemCustomTextField(
                              label: 'personal_info.last_name.label'.tr(),
                              controller: _lastNameController,
                              suffixIcon: SvgPicture.asset(
                                "assets/icons/ic_user.svg",
                                width: 19,
                                height: 19,
                              ),
                              validator: (_) {
                                final currentValue = _lastNameController.text
                                    .trim();
                                if (currentValue.isEmpty) {
                                  if (_initialLastName.isNotEmpty) {
                                    return 'personal_info.last_name.error_empty'
                                        .tr();
                                  }
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
                              label: 'personal_info.first_name.label'.tr(),
                              controller: _firstNameController,
                              suffixIcon: SvgPicture.asset(
                                "assets/icons/ic_user.svg",
                                width: 19,
                                height: 19,
                              ),
                              validator: (_) {
                                final currentValue = _firstNameController.text
                                    .trim();
                                if (currentValue.isEmpty) {
                                  if (_initialFirstName.isNotEmpty) {
                                    return 'personal_info.first_name.error_empty'
                                        .tr();
                                  }
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
                              label: 'personal_info.email.label'.tr(),
                              controller: _emailController,
                              suffixIcon: SvgPicture.asset(
                                "assets/icons/ic_mail.svg",
                                width: 19,
                                height: 19,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (_) {
                                final currentValue = _emailController.text
                                    .trim();
                                if (currentValue.isEmpty) {
                                  if (_initialEmail.isNotEmpty) {
                                    return 'personal_info.email.error_empty'
                                        .tr();
                                  }
                                  return null;
                                }
                                final emailRegex = RegExp(
                                  r'^[a-z0-9_\-\.]+@([a-z0-9\-]+\.)+[a-z]{2,4}$',
                                );
                                if (!emailRegex.hasMatch(currentValue)) {
                                  return 'personal_info.email.error_format'
                                      .tr();
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
                              label: 'personal_info.phone.label'.tr(),
                              controller: _phoneController,
                              suffixIcon: SvgPicture.asset(
                                "assets/icons/ic_phone.svg",
                                width: 19,
                                height: 19,
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (_) {
                                final currentValue = _phoneController.text
                                    .trim();
                                if (currentValue.isEmpty) {
                                  if (_initialPhone.isNotEmpty) {
                                    return 'personal_info.phone.error_empty'
                                        .tr();
                                  }
                                  return null;
                                }
                                final phoneRegex = RegExp(r'^[35789]\d{8}$');
                                if (!phoneRegex.hasMatch(currentValue)) {
                                  return 'personal_info.phone.error_format'
                                      .tr();
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
                              label: 'personal_info.dob'.tr(),
                              initialDate: _selectedDateOfBirth,
                              lastDate: maxAllowedDate,
                              onDateSelected: (date) {
                                setState(() {
                                  _selectedDateOfBirth = date;
                                });
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
                                    label: 'personal_info.height.label'.tr(),
                                    controller: _heightController,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    validator: (_) {
                                      final currentValue = _heightController
                                          .text
                                          .trim();
                                      if (currentValue.isEmpty) {
                                        if (_initialHeight.isNotEmpty) {
                                          return 'personal_info.height.error_empty'
                                              .tr();
                                        }
                                        return null;
                                      }
                                      if (double.tryParse(currentValue) ==
                                          null) {
                                        return 'personal_info.error_must_be_number'
                                            .tr();
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
                                    label: 'personal_info.weight.label'.tr(),
                                    controller: _weightController,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    validator: (_) {
                                      final currentValue = _weightController
                                          .text
                                          .trim();
                                      if (currentValue.isEmpty) {
                                        if (_initialWeight.isNotEmpty) {
                                          return 'personal_info.weight.error_empty'
                                              .tr();
                                        }
                                        return null;
                                      }
                                      if (double.tryParse(currentValue) ==
                                          null) {
                                        return 'personal_info.error_must_be_number'
                                            .tr();
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
                              label: 'personal_info.bio'.tr(),
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
              text: 'personal_info.btn_save'.tr(),
              isLoading: isLoading,
              onTap: isLoading ? null : _submit,
            ),
          );
        },
      ),
    );
  }
}
