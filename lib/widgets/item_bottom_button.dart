import 'package:flutter/material.dart';
import 'package:stride/core/theme/app_colors.dart';

class ItemBottomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onTap;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double borderWidth;
  final Color? borderColor;

  const ItemBottomButton({
    super.key,
    required this.text,
    this.onTap,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.borderWidth = 0,
    this.borderColor,
  });

  @override
  State<ItemBottomButton> createState() => _ItemBottomButtonState();
}

class _ItemBottomButtonState extends State<ItemBottomButton> {
  bool _isPressed = false;

  bool get _canPress => widget.onTap != null && !widget.isLoading;

  void _handleTap() {
    // 1. Tắt bàn phím ngay lập tức
    FocusScope.of(context).unfocus();

    // 2. Thực thi callback onTap được truyền từ ngoài vào
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>() ?? AppColors.light;

    final resolvedBgColor = widget.backgroundColor ?? colors.accent;
    // Nếu dùng nền accent mặc định, sử dụng onAccent để màu chữ không bị chói ở Dark Mode
    final defaultTextColor = resolvedBgColor == colors.accent
        ? colors.onAccent
        : colors.ink;
    final resolvedTextColor = widget.textColor ?? defaultTextColor;
    final resolvedBorderColor = widget.borderColor ?? Colors.transparent;

    return GestureDetector(
      onTapDown: (_) {
        if (_canPress) {
          setState(() => _isPressed = true);
        }
      },
      onTapUp: (_) {
        if (_canPress) {
          setState(() => _isPressed = false);
        }
      },
      onTapCancel: () {
        if (_canPress) {
          setState(() => _isPressed = false);
        }
      },
      // Tự động thu bàn phím khi bấm nút
      onTap: _canPress ? _handleTap : null,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: Container(
          width: double.infinity,
          height: 50,
          alignment: .center,
          decoration: BoxDecoration(
            color: resolvedBgColor,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: resolvedBorderColor,
              width: widget.borderWidth,
              style: BorderStyle.solid,
            ),
          ),
          child: widget.isLoading
              ? CircularProgressIndicator(color: colors.surface)
              : Text(
                  widget.text,
                  style: TextStyle(
                    color: resolvedTextColor,
                    fontSize: 15,
                    fontWeight: .w700,
                  ),
                ),
        ),
      ),
    );
  }
}
