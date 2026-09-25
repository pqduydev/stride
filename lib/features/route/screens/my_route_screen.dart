import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:stride/features/auth/auth_cubit/auth_cubit.dart';
import 'package:stride/features/auth/auth_cubit/auth_state.dart';
import 'package:stride/features/route/route_cubit/route_cubit.dart';
import 'package:stride/features/route/route_cubit/route_state.dart';
import 'package:stride/features/route/widgets/route_card_item.dart';
import 'package:stride/widgets/item_card_switch.dart';

class MyRouteScreen extends StatefulWidget {
  const MyRouteScreen({super.key});

  @override
  State<MyRouteScreen> createState() => _MyRouteScreenState();
}

class _MyRouteScreenState extends State<MyRouteScreen> {
  @override
  void initState() {
    super.initState();
    // Tải danh sách lộ trình ngay khi vào màn hình
    context.read<RouteCubit>().loadRoutes();
  }

  String _formatRouteDateRange(String start, String end) {
    try {
      final startDate = DateTime.parse(start);
      final endDate = DateTime.parse(end);

      // Thêm 0 trước ngày, tháng là hàng đơn vị
      final startDayMonth =
          "${startDate.day.toString().padLeft(2, '0')}/${startDate.month.toString().padLeft(2, '0')}";
      final endDayMonth =
          "${endDate.day.toString().padLeft(2, '0')}/${endDate.month.toString().padLeft(2, '0')}";

      // Kiểm tra ngày bắt đầu và kết thúc có trong cùng năm
      if (startDate.year == endDate.year) {
        return "$startDayMonth - $endDayMonth/${endDate.year}";
      } else {
        return "$startDayMonth/${startDate.year} - $endDayMonth/${endDate.year}";
      }
    } catch (e) {
      // Trả về chuỗi gốc nếu parse lỗi để tránh crash app
      return "$start - $end";
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, authState) {
        if (authState.status == AuthStatus.authenticated) {
          context.read<RouteCubit>().loadRoutes();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          scrolledUnderElevation: 0,
          shadowColor: Colors.transparent,
          title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: .spaceBetween,
              crossAxisAlignment: .center,
              children: [
                SizedBox(
                  width: 135,
                  height: 39.15,
                  child: Stack(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/ic_logo.svg',
                        height: 29,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF1C2520),
                          BlendMode.srcIn,
                        ),
                      ),
                      Positioned(
                        top: -5,
                        right: 0,
                        child: SvgPicture.asset(
                          'assets/icons/ic_arrow_up_right.svg',
                          width: 28,
                          height: 28,
                        ),
                      ),
                    ],
                  ),
                ),

                // Avatar & Menu tài khoản người dùng
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, authState) {
                    final user = authState.user;
                    final initials = user?.displayInitials;

                    return Theme(
                      data: Theme.of(context).copyWith(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                      ),
                      child: InkWell(
                        onTap: () => context.push('/profile'),
                        child: CircleAvatar(
                          radius: 21,
                          backgroundColor: const Color(0xFFE7EDD9),
                          child: Text(
                            initials ?? '',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF526C30),
                                ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 0,
              left: 20,
              right: 20,
              bottom: 30,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "THỨ HAI, 14 THÁNG 9",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF768079),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: .spaceBetween,
                  crossAxisAlignment: .center,
                  children: [
                    Text(
                      "Lộ trình của tôi",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1C2520),
                      ),
                    ),
                    InkWell(
                      onTap: () => context.push("/route_create"),
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: CircleAvatar(
                          backgroundColor: const Color(0xFFD2F36B),
                          child: SvgPicture.asset(
                            "assets/icons/ic_plus.svg",
                            colorFilter: const ColorFilter.mode(
                              Color(0xFF1C2520),
                              BlendMode.srcIn,
                            ),
                            width: 21,
                            height: 21,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                // Danh sách lộ trình
                SizedBox(
                  height: 255,
                  child: BlocBuilder<RouteCubit, RouteState>(
                    builder: (context, routeState) {
                      if (routeState.listStatus == RouteStatus.loading ||
                          routeState.listStatus == RouteStatus.initial) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (routeState.listStatus == RouteStatus.failure) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                routeState.errorMessage ?? 'Có lỗi xảy ra',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xFFE57373),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 5),
                              ElevatedButton.icon(
                                onPressed: () =>
                                    context.read<RouteCubit>().loadRoutes(),
                                icon: const Icon(
                                  Icons.refresh_rounded,
                                  size: 18,
                                ),
                                label: const Text("Thử lại"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1C2520),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      // Danh sách lộ trình trống
                      if (routeState.routes.isEmpty) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFE8ECE8)),
                            color: Colors.white,
                          ),
                          child: const Center(
                            child: Text(
                              "Bạn chưa có lộ trình tập luyện nào.",
                              style: TextStyle(
                                color: Color(0xFF768079),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      }

                      // Hiển thị danh sách cuộn ngang
                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        clipBehavior: Clip.none,
                        itemCount: routeState.routes.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 15),
                        itemBuilder: (context, index) {
                          final route = routeState.routes[index];
                          final formattedDate = _formatRouteDateRange(
                            route.startDate,
                            route.endDate,
                          );

                          return RouteCardItem(
                            route: route,
                            formattedDate: formattedDate,
                          );
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 30),

                InkWell(
                  onTap: () => context.push("/add_image"),
                  child: Container(
                    width: 100,
                    height: 40,
                    alignment: .center,
                    decoration: BoxDecoration(
                      color: Color(0xFFD2F36B),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Thêm ảnh',
                      style: TextStyle(fontSize: 15, fontWeight: .w500),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Text(
                          "Hôm nay",
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1C2520),
                              ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Text(
                            "Xem lịch",
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF526C30),
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 135,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                        border: Border.all(
                          color: const Color(0xFFE8ECE8),
                          width: 1,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 5,
                            height: double.infinity,
                            decoration: const BoxDecoration(
                              color: Color(0xFFD2F36B),
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(5),
                                bottom: Radius.circular(5),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: .spaceAround,
                              crossAxisAlignment: .start,
                              children: [
                                Row(
                                  mainAxisAlignment: .spaceBetween,
                                  crossAxisAlignment: .center,
                                  children: [
                                    Text(
                                      "18:00",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(
                                            color: const Color(0xFF1C2520),
                                            fontSize: 23,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                    Container(
                                      width: 88,
                                      height: 25,
                                      alignment: .centerLeft,
                                      padding: const EdgeInsets.only(left: 10),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFF7F8FA),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(7),
                                        ),
                                      ),
                                      child: Text(
                                        "60 phút",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(
                                              color: const Color(0xFF768079),
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "Thân trên & core",
                                  style: Theme.of(context).textTheme.labelLarge
                                      ?.copyWith(
                                        color: const Color(0xFF1C2520),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/ic_bell.svg',
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      "Nhắc trước 15 phút",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(
                                            color: const Color(0xFF768079),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
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
                  ],
                ),
                const SizedBox(height: 30),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      crossAxisAlignment: .center,
                      children: [
                        Text(
                          "Nhìn lại hành trình",
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: const Color(0xFF1C2520),
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        SvgPicture.asset(
                          'assets/icons/ic_arrow_up_right.svg',
                          width: 20,
                          height: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 89,
                      child: Row(
                        children: [
                          Container(
                            width: 98,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/images/img_background.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFFFFF),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: .start,
                                mainAxisAlignment: .spaceBetween,
                                children: [
                                  Container(
                                    width: 69,
                                    height: 25,
                                    alignment: .center,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFEEF4E5),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(7),
                                      ),
                                    ),
                                    child: Text(
                                      "TUẦN 4",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(
                                            color: const Color(0xFF526C30),
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                  Text(
                                    "Đều đặn hơn mỗi tuần",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                          color: const Color(0xFF1C2520),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  Text(
                                    "3 buổi tập · 1 cập nhật",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                          color: const Color(0xFF768079),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const ItemCardSwitch(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
