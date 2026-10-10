import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stride/features/auth/auth_cubit/auth_cubit.dart';
import 'package:stride/widgets/item_bottom_button.dart';

class OnboardingPermissionScreen extends StatefulWidget {
  const OnboardingPermissionScreen({super.key});

  @override
  State<OnboardingPermissionScreen> createState() =>
      _OnboardingPermissionScreenState();
}

class _OnboardingPermissionScreenState
    extends State<OnboardingPermissionScreen> {
  bool _isProcessing = false;

  Future<void> _handlePermissions(
    BuildContext context, {
    required bool shouldRequest,
  }) async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      if (!shouldRequest) {
        if (context.mounted) {
          await _finishOnboarding(context);
        }
        return;
      }

      final initialCameraStatus = await Permission.camera.status;
      final initialNotificationStatus = await Permission.notification.status;

      final wasCameraPermanentlyDenied =
          initialCameraStatus.isPermanentlyDenied;
      final wasNotificationPermanentlyDenied =
          initialNotificationStatus.isPermanentlyDenied;

      if (!wasCameraPermanentlyDenied) {
        await Permission.camera.request();
      }
      if (!wasNotificationPermanentlyDenied) {
        await Permission.notification.request();
      }

      if (!context.mounted) return;

      if (wasCameraPermanentlyDenied || wasNotificationPermanentlyDenied) {
        final shouldOpenSettings = await _showPermanentlyDeniedDialog(context);
        if (shouldOpenSettings == true) {
          await openAppSettings();
        }
      }

      if (context.mounted) {
        await _finishOnboarding(context);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _finishOnboarding(BuildContext context) async {
    await context.read<AuthCubit>().completePermissionOnboarding();
  }

  Future<bool?> _showPermanentlyDeniedDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(
          'onboarding_permission.dialog_title'.tr(),
          style: const TextStyle(fontSize: 18, fontWeight: .bold),
        ),
        content: Text(
          'onboarding_permission.dialog_content'.tr(),
          style: const TextStyle(fontSize: 14, color: Color(0xFF768079)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'onboarding_permission.dialog_cancel'.tr(),
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              'onboarding_permission.dialog_open_settings'.tr(),
              style: const TextStyle(
                color: Color(0xFF526C30),
                fontWeight: .bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                'onboarding_permission.title'.tr(),
                style: const TextStyle(
                  color: Color(0xFF1C2520),
                  fontSize: 34,
                  fontWeight: .w700,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'onboarding_permission.subtitle'.tr(),
                style: const TextStyle(
                  color: Color(0xFF768079),
                  fontSize: 15,
                  fontWeight: .w400,
                ),
              ),
              const SizedBox(height: 40),
              _buildInfoRow(
                title: 'onboarding_permission.camera_title'.tr(),
                description: 'onboarding_permission.camera_desc'.tr(),
                icon: Icons.camera_alt_outlined,
              ),
              const SizedBox(height: 25),
              _buildInfoRow(
                title: 'onboarding_permission.notification_title'.tr(),
                description: 'onboarding_permission.notification_desc'.tr(),
                icon: Icons.notifications_none_outlined,
              ),
              const Spacer(),
              ItemBottomButton(
                text: 'onboarding_permission.btn_allow'.tr(),
                isLoading: _isProcessing,
                onTap: _isProcessing
                    ? null
                    : () => _handlePermissions(context, shouldRequest: true),
              ),
              const SizedBox(height: 15),
              ItemBottomButton(
                text: 'onboarding_permission.btn_skip'.tr(),
                backgroundColor: const Color(0xFFFFFFFF),
                textColor: const Color(0xFF768079),
                borderColor: Colors.transparent,
                borderWidth: 0,
                onTap: _isProcessing
                    ? null
                    : () => _handlePermissions(context, shouldRequest: false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Row(
      crossAxisAlignment: .start,
      children: [
        Container(
          width: 44,
          height: 44,
          alignment: .center,
          decoration: BoxDecoration(
            color: const Color(0xFFEEF4E5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF526C30)),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF1C2520),
                  fontSize: 16,
                  fontWeight: .w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  color: Color(0xFF768079),
                  fontSize: 14,
                  fontWeight: .w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
