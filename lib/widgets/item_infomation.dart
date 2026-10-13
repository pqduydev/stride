import 'package:flutter/material.dart';
import 'package:stride/core/theme/app_colors.dart';

class ItemInfomation extends StatelessWidget {
  const ItemInfomation({super.key, required this.title, required this.info});

  final String title;
  final String info;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>() ?? AppColors.light;

    return Container(
      width: double.infinity,
      height: 107,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(top: 40),
      decoration: BoxDecoration(
        color: colors.avatarBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: .start,
        mainAxisAlignment: .spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: colors.green,
              fontSize: 14,
              fontWeight: .w600,
            ),
          ),
          Text(
            info,
            style: TextStyle(
              color: colors.muted,
              fontSize: 13,
              fontWeight: .w400,
            ),
          ),
        ],
      ),
    );
  }
}
