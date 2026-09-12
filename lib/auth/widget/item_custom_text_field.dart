import 'package:flutter/material.dart';

class ItemCustomTextField extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;

  const ItemCustomTextField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.suffixIcon,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.autofillHints,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: validator,
      initialValue: controller?.text,
      builder: (field) {
        final hasError = field.hasError;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 76.15,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: hasError ? Colors.redAccent : const Color(0xFFE8ECE8),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Color(0xFF768079),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          autofillHints: autofillHints,
                          obscureText: obscureText,
                          textInputAction: textInputAction,
                          keyboardType: keyboardType,
                          onChanged: (value) {
                            field.didChange(value);
                          },
                          style: const TextStyle(
                            color: Color(0xFF1C2520),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            hintText: hintText,
                            hintStyle: const TextStyle(
                              color: Color(0xFFC4C9C5),
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      ),
                      if (suffixIcon != null) ...[
                        const SizedBox(width: 8),
                        suffixIcon!,
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Giữ cố định kích thước ô lỗi, không làm giật/đẩy layout bên dưới
            Padding(
              padding: const EdgeInsets.only(top: 1, left: 2),
              child: Visibility(
                visible: hasError,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: Text(
                  field.errorText ?? '',
                  style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
