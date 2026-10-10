import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

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
    final double cardWidth = MediaQuery.of(context).size.width - 60;

    return Shimmer.fromColors(
      baseColor: const Color(0xFFE2E8E3),
      highlightColor: const Color(0xFFF5F8F5),
      period: const Duration(milliseconds: 1200),
      child: Container(
        width: cardWidth,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(color: const Color(0xFFE8ECE8), width: 1),
        ),
        child: Column(
          children: [
            // 1. Phần Ảnh (Top)
            Container(
              width: double.infinity,
              height: 140,
              decoration: const BoxDecoration(
                color: Color(0xFFC0CAC2), // Màu đậm riêng biệt cho phần Ảnh
                borderRadius: BorderRadius.all(Radius.circular(20)),
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
                          color: const Color(0xFFD4DCD5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Container(
                        width: 75,
                        height: 16,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4DCD5),
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
                      color: const Color(0xFFE8ECE8),
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
                          color: const Color(0xFFD4DCD5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Container(
                        width: 35,
                        height: 16,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4DCD5),
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
