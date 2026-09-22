import 'package:flutter/material.dart';

class ItemCustomTextField extends StatefulWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final bool autocorrect;
  final bool enableSuggestions;
  final bool readOnly;
  final int maxLines;
  final double height;
  final int backgroundColor;

  const ItemCustomTextField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.suffixIcon,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.autofillHints,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.height = 76.15,
    this.backgroundColor = 0xFFFFFFFF,
  });

  @override
  State<ItemCustomTextField> createState() => _ItemCustomTextFieldState();
}

class _ItemCustomTextFieldState extends State<ItemCustomTextField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: widget.validator,
      builder: (field) {
        final hasError = field.hasError;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => _focusNode.requestFocus(),
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: widget.height,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Color(widget.backgroundColor),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: hasError
                        ? Colors.redAccent
                        : const Color(0xFFE8ECE8),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.label,
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
                            maxLines: widget.maxLines,
                            readOnly: widget.readOnly,
                            focusNode: _focusNode,
                            controller: widget.controller,
                            autofillHints: widget.autofillHints,
                            textInputAction: widget.textInputAction,
                            keyboardType: widget.keyboardType,
                            autocorrect: widget.autocorrect,
                            enableSuggestions: widget.enableSuggestions,
                            onChanged: (value) => field.didChange(value),
                            style: const TextStyle(
                              color: Color(0xFF1C2520),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              hintText: widget.hintText,
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
                        if (widget.suffixIcon != null) ...[
                          const SizedBox(width: 8),
                          widget.suffixIcon!,
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
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
