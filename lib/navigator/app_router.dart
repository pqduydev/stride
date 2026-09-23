import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stride/features/appointment/screens/appointment_screen.dart';
import 'package:stride/features/auth/auth_cubit/auth_cubit.dart';
import 'package:stride/features/auth/auth_cubit/auth_state.dart';
import 'package:stride/features/auth/screens/auth_screen.dart';
import 'package:stride/model/route_model.dart';
import 'package:stride/features/route/screens/my_route_screen.dart';
import 'package:stride/features/common_screens/add_image_screen.dart';
import 'package:stride/features/common_screens/check_screen.dart';
import 'package:stride/features/auth/screens/email_verification_screen.dart';
import 'package:stride/features/auth/screens/forget_password_screen.dart';
import 'package:stride/features/auth/screens/login_with_google_screen.dart';
import 'package:stride/features/auth/screens/login_with_phone_number_screen.dart';
import 'package:stride/features/common_screens/main_navigation_bar_screen.dart';
import 'package:stride/features/auth/screens/privacy_information_screen.dart';
import 'package:stride/features/user/screens/change_password.dart';
import 'package:stride/features/user/screens/personal_information_screen.dart';
import 'package:stride/features/user/screens/profile_screen.dart';
import 'package:stride/features/route/screens/route_create_screen.dart';
import 'package:stride/features/route/screens/route_details_screen.dart';
import 'package:stride/features/common_screens/splash_screen.dart';
import 'package:stride/features/common_screens/welcome_screen.dart';
import 'package:stride/widgets/login_with_apple_screen.dart';

class AppRouter {
  final AuthCubit authCubit;

  AppRouter(this.authCubit);

  late final router = GoRouter(
    // Màn hình khởi tạo
    initialLocation: '/splash',
    refreshListenable: GoRouterRefreshStream(authCubit.stream),
    redirect: (context, state) {
      final authStatus = authCubit.state.status;
      final location = state.matchedLocation;

      // Khi đang ở trạng thái ban đầu -> Giữ ở Splash
      if (authStatus == AuthStatus.initial && location == '/splash') {
        return '/splash';
      }

      final isAuthRoute =
          location == '/login' ||
          location == '/register' ||
          location == '/welcome';

      /** ĐÃ ĐĂNG NHẬP */
      if (authStatus == AuthStatus.authenticated) {
        // Nếu đang ở các trang auth/welcome/splash thì đẩy vào main_navigation_bar
        if (isAuthRoute || location == '/splash') {
          return '/main_navigation_bar';
        }
        return null;
      }

      /** CHƯA ĐĂNG NHẬP */
      // Danh sách các màn hình KHÔNG bắt buộc đăng nhập
      final publicRoutes = ['/welcome', '/login', '/register', '/splash'];
      final isPublicRoute = publicRoutes.any(
        (route) => location.startsWith(route),
      );

      // Nếu cố tình truy cập màn hình yêu cầu đăng nhập -> Đá về Welcome
      if (!isPublicRoute) {
        return '/welcome';
      }

      // Nếu đang ở Splash mà xác thực thất bại/chưa đăng nhập -> Đá về Welcome
      if (location == '/splash' &&
          (authStatus == AuthStatus.unauthenticated ||
              authStatus == AuthStatus.failure)) {
        return '/welcome';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: "/splash",
        builder: (context, state) => const SplashScreen(),
      ),
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
                  final title = data['title'] as String?;
                  final info = data['info'] as String?;
                  final buttonTitle = data['button_title'] as String?;
                  final onTap = data['on_tap'] as VoidCallback?;

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
      GoRoute(
        path: "/profile",
        builder: (context, state) => const ProfileScreen(),
        routes: [
          GoRoute(
            path: "personal_information",
            builder: (context, state) => const PersonalInformationScreen(),
          ),
          GoRoute(
            path: "change_password",
            builder: (context, state) => const ChangePassword(),
          ),
        ],
      ),
    ],
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<AuthState> _subscription;

  GoRouterRefreshStream(Stream<AuthState> stream) {
    notifyListeners();
    AuthStatus? lastStatus;

    _subscription = stream.listen((state) {
      // Chỉ thông báo cho GoRouter khi trạng thái xác thực (AuthStatus) thực sự thay đổi
      // So sánh trạng thái cũ với trạng thái mới
      if (state.status != lastStatus) {
        lastStatus = state.status;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
