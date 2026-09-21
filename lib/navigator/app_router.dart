import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stride/appointment/screen/appointment_screen.dart';
import 'package:stride/auth/auth_cubit/auth_cubit.dart';
import 'package:stride/auth/auth_cubit/auth_state.dart';
import 'package:stride/auth/screen/auth_screen.dart';
import 'package:stride/model/route_model.dart';
import 'package:stride/route/screen/my_route_screen.dart';
import 'package:stride/screens/add_image_screen.dart';
import 'package:stride/screens/check_screen.dart';
import 'package:stride/screens/email_verification_screen.dart';
import 'package:stride/screens/forget_password_screen.dart';
import 'package:stride/screens/login_with_google_screen.dart';
import 'package:stride/screens/login_with_phone_number_screen.dart';
import 'package:stride/screens/main_navigation_bar_screen.dart';
import 'package:stride/screens/privacy_information_screen.dart';
import 'package:stride/screens/route_create_screen.dart';
import 'package:stride/screens/route_details_screen.dart';
import 'package:stride/screens/welcome_screen.dart';
import 'package:stride/widgets/login_with_apple_screen.dart';

class AppRouter {
  final AuthCubit authCubit;

  AppRouter(this.authCubit);

  late final router = GoRouter(
    // Màn hình khởi tạo
    initialLocation: '/welcome',
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

      // Danh sách các màn hình "không bắt buộc đăng nhập"
      final publicRoutes = ['/welcome', '/login', '/register'];

      // Kiểm tra xem đích đến hiện tại có nằm trong danh sách public không
      final isPublicRoute = publicRoutes.any(
        (route) => state.matchedLocation.startsWith(route),
      );

      // Nếu chưa đăng nhập và màn hình đích không thuộc danh sách public -> Đá về login
      if (authStatus == AuthStatus.unauthenticated && !isPublicRoute) {
        return '/welcome';
      }

      // Các trường hợp còn lại thì cho phép đi tiếp
      return null;
    },
    routes: [
      GoRoute(
        path: "/welcome",
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: "/login",
        builder: (context, state) => const AuthScreen(isLogin: true),
        routes: [
          GoRoute(
            path: "forget_password",
            builder: (context, state) => const ForgetPasswordScreen(),
            routes: [
              GoRoute(
                path: "check_email",
                builder: (context, state) {
                  final data = state.extra as Map<String, dynamic>;

                  final appBarTitle = data['app_bar_title'] as String?;
                  final title = data?['title'] as String?;
                  final info = data?['info'] as String?;
                  final buttonTitle = data?['button_title'] as String?;
                  final onTap = data?['on_tap'] as VoidCallback?;

                  return CheckScreen(
                    appBarTitle: appBarTitle,
                    title: title,
                    info: info,
                    buttonTitle: buttonTitle,
                    onTap: onTap,
                  );
                },
              ),
            ],
          ),

          GoRoute(
            path: "login_with_phone_number",
            builder: (context, state) => const LoginWithPhoneNumberScreen(),
          ),
        ],
      ),
      GoRoute(
        path: "/register",
        builder: (context, state) => const AuthScreen(isLogin: false),
        routes: [
          GoRoute(
            path: "privacy",
            builder: (context, state) => const PrivacyInformationScreen(),
          ),
          GoRoute(
            path: "email_verification",
            builder: (context, state) => const EmailVerificationScreen(),
          ),
          GoRoute(
            path: "login_with_google",
            builder: (context, state) => const LoginWithGooglesScreen(),
          ),
          GoRoute(
            path: "login_with_apple",
            builder: (context, state) => const LoginWithAppleScreen(),
          ),
        ],
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
        path: "/appointment",
        builder: (context, state) => const AppointmentScreen(),
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
