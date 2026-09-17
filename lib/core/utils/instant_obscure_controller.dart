import 'package:flutter/material.dart';

class InstantObscureController extends TextEditingController {
  bool isObscured;

  InstantObscureController({super.text, this.isObscured = true});

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    // Nếu đang mở mắt (không ẩn) hoặc chưa gõ gì -> hiển thị chữ bình thường
    if (!isObscured || text.isEmpty) {
      return super.buildTextSpan(
        context: context,
        style: style,
        withComposing: withComposing,
      );
    }

    // Thay thế toàn bộ chuỗi hiển thị bằng dấu chấm ngay lập tức
    return TextSpan(text: '•' * text.length, style: style);
  }
}
