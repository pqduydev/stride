import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LanguageSwitchButton extends StatelessWidget {
  final double? width;
  final double? height;

  const LanguageSwitchButton({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;
    final isVietnamese = currentLocale.languageCode == 'vi';

    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: PopupMenuButton<Locale>(
        offset: const Offset(0, 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white,
        elevation: 4,
        onSelected: (Locale locale) async {
          if (context.locale != locale) {
            await context.setLocale(locale);
          }
        },
        itemBuilder: (BuildContext context) => [
          PopupMenuItem<Locale>(
            value: const Locale('vi', 'VN'),
            child: Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                const Text('Tiếng Việt', style: TextStyle(fontSize: 14)),
                if (isVietnamese)
                  const Icon(Icons.check, color: Color(0xFF526C30), size: 18),
              ],
            ),
          ),
          PopupMenuItem<Locale>(
            value: const Locale('en', 'US'),
            child: Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                const Text('English', style: TextStyle(fontSize: 14)),
                if (!isVietnamese)
                  const Icon(Icons.check, color: Color(0xFF526C30), size: 18),
              ],
            ),
          ),
        ],
        child: Container(
          width: width,
          height: height,
          padding: width != null
              ? EdgeInsets.zero
              : const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          alignment: .center,
          decoration: BoxDecoration(
            color: const Color(0xFFEEF4E5),
            borderRadius: BorderRadius.circular(width != null ? 7 : 20),
            border: Border.all(
              color: const Color(0xFF526C30).withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: .center,
            children: [
              Image.asset(
                'assets/images/img_language.png',
                width: 16,
                height: 16,
                color: const Color(0xFF526C30),
              ),
              const SizedBox(width: 5),
              Text(
                isVietnamese ? 'VI' : 'EN',
                style: const TextStyle(
                  color: Color(0xFF526C30),
                  fontSize: 12,
                  fontWeight: .w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
