import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:stride/core/theme/app_colors.dart';

class AppToast {
  static void _showCustomToast({
    required BuildContext context,
    required String message,
    required Color primaryColor,
    required Color backgroundColor,
    required IconData iconData,
  }) {
    final colors = Theme.of(context).extension<AppColors>() ?? AppColors.light;
    toastification.showCustom(
      context: context,
      autoCloseDuration: const Duration(seconds: 3),
      alignment: .topRight,
      animationDuration: const Duration(milliseconds: 300),
      builder: (context, holder) {
        return Row(
          mainAxisAlignment: .end,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 300,
                minHeight: 50, // Chiều cao tối thiểu tương đương 2 dòng
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                margin: const EdgeInsets.only(top: 5, right: 20),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: colors.background.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: .min,
                  crossAxisAlignment:
                      .center, // Căn giữa icon và text theo chiều dọc
                  children: [
                    Icon(iconData, color: primaryColor, size: 20),
                    const SizedBox(width: 8),
                    // Expanded giúp text tự động xuống dòng và co giãn chiều cao khi dài ra
                    Expanded(
                      child: Text(
                        message,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: primaryColor,
                          height: 1.3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    GestureDetector(
                      onTap: () => toastification.dismiss(holder),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Icon(
                          Icons.close,
                          color: primaryColor.withValues(alpha: 0.7),
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static void showSuccess(BuildContext context, String message) {
    final colors = Theme.of(context).extension<AppColors>() ?? AppColors.light;
    _showCustomToast(
      context: context,
      message: message,
      primaryColor: colors.green,
      backgroundColor: colors.avatarBackground,
      iconData: Icons.check_circle,
    );
  }

  static void showError(BuildContext context, String message) {
    final colors = Theme.of(context).extension<AppColors>() ?? AppColors.light;
    _showCustomToast(
      context: context,
      message: message,
      primaryColor: colors.error,
      backgroundColor: colors.errorContainer,
      iconData: Icons.error,
    );
  }

  static void showWarning(BuildContext context, String message) {
    final colors = Theme.of(context).extension<AppColors>() ?? AppColors.light;
    _showCustomToast(
      context: context,
      message: message,
      primaryColor: colors.warning,
      backgroundColor: colors.warningContainer,
      iconData: Icons.warning_rounded,
    );
  }

  static void showInfo(BuildContext context, String message) {
    final colors = Theme.of(context).extension<AppColors>() ?? AppColors.light;
    _showCustomToast(
      context: context,
      message: message,
      primaryColor: colors.info,
      backgroundColor: colors.infoContainer,
      iconData: Icons.info,
    );
  }
}
