import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stride/core/theme/app_colors.dart';

/// Widget danh sách ngang hiển thị các thẻ Skeleton khi đang tải dữ liệu
class RouteCardSkeletonList extends StatelessWidget {
  const RouteCardSkeletonList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      physics: const NeverScrollableScrollPhysics(), // Khóa cuộn khi loading
      itemCount: 2,
      separatorBuilder: (context, index) => const SizedBox(width: 15),
      itemBuilder: (context, index) => const RouteCardSkeletonItem(),
    );
  }
}

/// Widget Skeleton phân tách rõ ràng Phần Ảnh (Top) và Phần Nội Dung (Bottom)
class RouteCardSkeletonItem extends StatelessWidget {
  const RouteCardSkeletonItem({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>() ?? AppColors.light;
    final double cardWidth = MediaQuery.of(context).size.width - 60;

    return Shimmer.fromColors(
      baseColor: colors.skeletonBase,
      highlightColor: colors.skeletonHighlight,
      period: const Duration(milliseconds: 1200),
      child: Container(
        width: cardWidth,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(color: colors.line, width: 1),
        ),
        child: Column(
          children: [
            // 1. Phần Ảnh (Top)
            Container(
              width: double.infinity,
              height: 140,
              decoration: BoxDecoration(
                color: colors.skeletonImage, // Màu đậm riêng biệt cho phần Ảnh
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
            ),

            // 2. Phần Nội Dung (Bottom)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  // Hàng 1: "Đã hoàn thành" — "... / ... buổi"
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Container(
                        width: 95,
                        height: 15,
                        decoration: BoxDecoration(
                          color: colors.skeletonLine,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Container(
                        width: 75,
                        height: 16,
                        decoration: BoxDecoration(
                          color: colors.skeletonLine,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 13),

                  // Thanh Progress Bar (Thanh nền & vệt tiến độ)
                  Container(
                    height: 7,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: colors.line,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  const SizedBox(height: 13),

                  // Hàng 2: "Tuần ..." — "...%"
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Container(
                        width: 50,
                        height: 14,
                        decoration: BoxDecoration(
                          color: colors.skeletonLine,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Container(
                        width: 35,
                        height: 16,
                        decoration: BoxDecoration(
                          color: colors.skeletonLine,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
