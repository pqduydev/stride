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
      alignment: .topCenter, // Căn giữa ở đỉnh màn hình
      animationDuration: const Duration(milliseconds: 500),
      builder: (context, holder) {
        return _SwipeableToastContainer(
          holder: holder,
          backgroundColor: backgroundColor,
          primaryColor: primaryColor,
          iconData: iconData,
          message: message,
          colors: colors,
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

/// Widget hỗ trợ xử lý cử chỉ vuốt trái, phải, lên để tắt toast
class _SwipeableToastContainer extends StatefulWidget {
  final ToastificationItem holder;
  final Color backgroundColor;
  final Color primaryColor;
  final IconData iconData;
  final String message;
  final AppColors colors;

  const _SwipeableToastContainer({
    required this.holder,
    required this.backgroundColor,
    required this.primaryColor,
    required this.iconData,
    required this.message,
    required this.colors,
  });

  @override
  State<_SwipeableToastContainer> createState() =>
      _SwipeableToastContainerState();
}

class _SwipeableToastContainerState extends State<_SwipeableToastContainer> {
  Offset _offset = Offset.zero;
  double _opacity = 1.0;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: _offset,
      child: Opacity(
        opacity: _opacity,
        child: GestureDetector(
          // Lắng nghe cử chỉ chạm
          onPanUpdate: (details) {
            setState(() {
              // Chỉ cho phép dịch chuyển theo chiều ngang (trái/phải), khóa cứng chiều dọc bằng 0
              double newDx = _offset.dx + details.delta.dx;
              _offset = Offset(newDx, 0);

              // Tính toán độ mờ dựa trên khoảng cách dịch chuyển ngang
              double distance = _offset.dx.abs();
              _opacity = (1.0 - (distance / 150)).clamp(0.0, 1.0);
            });
          },
          onPanEnd: (details) {
            // Chỉ kiểm tra điều kiện vuốt ngang (trái hoặc phải)
            if (_offset.dx.abs() > 70 ||
                details.velocity.pixelsPerSecond.dx.abs() > 400) {
              // Gọi hàm đóng toast của thư viện toastification
              toastification.dismiss(widget.holder);
            } else {
              // Trả về vị trí cũ nếu chưa đủ điều kiện dismiss
              setState(() {
                _offset = Offset.zero;
                _opacity = 1.0;
              });
            }
          },
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420, minHeight: 50),
            margin: const EdgeInsets.only(top: 0, left: 16, right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: widget.colors.background.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: .min,
              crossAxisAlignment: .center,
              children: [
                Icon(widget.iconData, color: widget.primaryColor, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.message,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: widget.primaryColor,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
