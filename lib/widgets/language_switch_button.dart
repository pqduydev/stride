import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stride/core/theme/app_colors.dart';

class LanguageSwitchButton extends StatelessWidget {
  final double? width;
  final double? height;

  const LanguageSwitchButton({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>() ?? AppColors.light;
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
        color: colors.surface,
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
                Text(
                  'Tiếng Việt',
                  style: TextStyle(fontSize: 14, color: colors.ink),
                ),
                if (isVietnamese)
                  Icon(Icons.check, color: colors.green, size: 18),
              ],
            ),
          ),
          PopupMenuItem<Locale>(
            value: const Locale('en', 'US'),
            child: Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text(
                  'English',
                  style: TextStyle(fontSize: 14, color: colors.ink),
                ),
                if (!isVietnamese)
                  Icon(Icons.check, color: colors.green, size: 18),
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
            color: colors.avatarBackground,
            borderRadius: BorderRadius.circular(width != null ? 7 : 20),
            border: Border.all(
              color: colors.green.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: .min,
            mainAxisAlignment: .center,
            children: [
              Image.asset(
                'assets/images/img_language.png',
                width: 16,
                height: 16,
                color: colors.green,
              ),
              const SizedBox(width: 5),
              Text(
                isVietnamese ? 'VI' : 'EN',
                style: TextStyle(
                  color: colors.green,
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
