import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stride/auth/auth_cubit/auth_cubit.dart';
import 'package:stride/auth/auth_cubit/auth_state.dart';
import 'package:stride/auth/screen/auth_screen.dart';
import 'package:stride/model/route_model.dart';
import 'package:stride/route/screen/my_route_screen.dart';
import 'package:stride/screens/add_image_screen.dart';
import 'package:stride/screens/main_navigation_bar_screen.dart';
import 'package:stride/screens/route_create_screen.dart';
import 'package:stride/screens/route_details_screen.dart';

class AppRouter {
  final AuthCubit authCubit;

  AppRouter(this.authCubit);

  late final router = GoRouter(
    // Màn hình khởi tạo
    initialLocation: '/main_navigation_bar',
    refreshListenable: GoRouterRefreshStream(authCubit.stream),
    redirect: (context, state) {
      final authStatus = authCubit.state.status;
      final isAuthRoute =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      // Đã đăng nhập thì không cho quay lại màn hình Login/Register
      if (authStatus == AuthStatus.authenticated && isAuthRoute) {
        return '/main_navigation_bar';
      }

      // Danh sách các màn hình "Bắt buộc đăng nhập"
      final isProtectedRoute =
          state.matchedLocation == '/route_create' ||
          state.matchedLocation == '/route_edit';

      // Nếu chưa đăng nhập mà bấm vào Tạo/Sửa lộ trình -> Đá văng sang Login
      if (authStatus == AuthStatus.unauthenticated && isProtectedRoute) {
        return '/login';
      }

      // Các trường hợp còn lại thì cho phép đi tiếp
      return null;
    },
    routes: [
      GoRoute(
        path: "/login",
        builder: (context, state) => const AuthScreen(isLogin: true),
      ),
      GoRoute(
        path: "/register",
        builder: (context, state) => const AuthScreen(isLogin: false),
      ),
      GoRoute(
        path: "/main_navigation_bar",
        builder: (context, state) => const MainNavigationBarScreen(),
      ),
      GoRoute(
        path: "/my_route",
        builder: (context, state) => const MyRouteScreen(),
      ),
      GoRoute(
        path: "/route_details",
        builder: (context, state) => const RouteDetailsScreen(),
      ),
      GoRoute(
        path: "/route_create",
        builder: (context, state) => const RouteCreateScreen(),
      ),
      GoRoute(
        path: "/route_edit",
        builder: (context, state) {
          final routeToEdit = state.extra as RouteModel?;
          return RouteCreateScreen(routeToEdit: routeToEdit);
        },
      ),
      GoRoute(
        path: "/add_image",
        builder: (context, state) => const AddImageScreen(),
      ),
      GoRoute(
        path: "/schedules",
        builder: (context, state) => const AddImageScreen(),
      ),
    ],
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
