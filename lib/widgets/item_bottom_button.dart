import 'package:flutter/material.dart';

class ItemBottomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onTap;
  final bool isLoading;
  final Color backgroundColor;
  final Color textColor;
  final double borderWidth;
  final Color borderColor;

  const ItemBottomButton({
    super.key,
    required this.text,
    this.onTap,
    this.isLoading = false,
    this.backgroundColor = const Color(0xFFD2F36B),
    this.textColor = const Color(0xFF1C2520),
    this.borderWidth = 0,
    this.borderColor = Colors.transparent,
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
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: widget.borderColor,
              width: widget.borderWidth,
              style: BorderStyle.solid,
            ),
          ),
          child: widget.isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
                  widget.text,
                  style: TextStyle(
                    color: widget.textColor,
                    fontSize: 15,
                    fontWeight: .w700,
                  ),
                ),
        ),
      ),
    );
  }
}
