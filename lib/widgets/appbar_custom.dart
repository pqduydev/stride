import 'package:flutter/material.dart';
import 'package:stride/core/theme/app_colors.dart';

class AppbarCustom extends StatelessWidget {
  const AppbarCustom({super.key, required this.title});

  final Widget title;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>() ?? AppColors.light;

    return AppBar(
      backgroundColor: colors.background,
      forceMaterialTransparency: true,
      scrolledUnderElevation: 0,
      title: title,
    );
  }
}
