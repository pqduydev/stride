import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stride/features/appointment/screens/appointment_screen.dart';
import 'package:stride/features/auth/auth_cubit/auth_cubit.dart';
import 'package:stride/features/auth/auth_cubit/auth_state.dart';
import 'package:stride/features/auth/screens/auth_screen.dart';
import 'package:stride/features/common_screens/onboarding_permission_screen.dart';
import 'package:stride/features/diary/screen/diary_screen.dart';
import 'package:stride/features/reminder/screens/reminder_saved_screen.dart';
import 'package:stride/features/reminder/screens/reminder_settings_screen.dart';
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
      final hasSeenPermission = authCubit.state.hasSeenPermission;
      final location = state.matchedLocation;

      // 1. Khi app đang khởi chạy ở Splash
      if (authStatus == AuthStatus.initial) {
        // Nếu đã ở /splash rồi thì giữ nguyên (null), chưa ở /splash mới chuyển về /splash
        return location == '/splash' ? null : '/splash';
      }

      // Khai báo danh sách đường dẫn public / auth
      final authRoutes = ['/login', '/register', '/welcome', '/splash'];
      final isAuthRoute = authRoutes.any((route) => location.startsWith(route));
      final isPermissionRoute = location.startsWith('/onboarding_permission');

      // 2. TRƯỜNG HỢP ĐÃ ĐĂNG NHẬP
      if (authStatus == AuthStatus.authenticated) {
        // Nếu chưa xem màn xin quyền -> Đẩy tới permission (nếu chưa ở đó)
        if (!hasSeenPermission) {
          return location == '/onboarding_permission'
              ? null
              : '/onboarding_permission';
        }

        // Nếu đã xem quyền và đang ở các trang Auth/Splash/Permission -> Đẩy về Main
        if (isAuthRoute || location == '/splash' || isPermissionRoute) {
          return '/main_navigation_bar';
        }

        // Nếu đang vào các màn hình protected (/profile, /my_route...) -> Cho phép đi tiếp
        return null;
      }

      // 3. TRƯỜNG HỢP CHƯA ĐĂNG NHẬP HOẶC THẤT BẠI (unauthenticated / failure)
      if (authStatus == AuthStatus.unauthenticated ||
          authStatus == AuthStatus.failure) {
        // Nếu đang ở Splash HOẶC cố truy cập màn hình bắt buộc đăng nhập -> Đẩy về Welcome
        if (location == '/splash' || (!isAuthRoute && !isPermissionRoute)) {
          return '/welcome';
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: "/splash",
        pageBuilder: (context, state) {
          return buildPageWithSlideTransition(
            context: context,
            state: state,
            child: const SplashScreen(),
          );
        },
      ),
      GoRoute(
        path: "/welcome",
        pageBuilder: (context, state) {
          return buildPageWithSlideTransition(
            context: context,
            state: state,
            child: const WelcomeScreen(),
          );
        },
      ),
      GoRoute(
        path: "/login",
        pageBuilder: (context, state) {
          return buildPageWithSlideTransition(
            context: context,
            state: state,
            child: const AuthScreen(isLogin: true),
          );
        },
        routes: [
          GoRoute(
            path: "forget_password",
            pageBuilder: (context, state) {
              return buildPageWithSlideTransition(
                context: context,
                state: state,
                child: const ForgetPasswordScreen(),
              );
            },
            routes: [
              GoRoute(
                path: "check_email",
                pageBuilder: (context, state) {
                  final data = state.extra as Map<String, dynamic>;

                  final appBarTitle = data['app_bar_title'] as String?;
                  final title = data['title'] as String?;
                  final info = data['info'] as String?;
                  final buttonTitle = data['button_title'] as String?;
                  final onTap = data['on_tap'] as VoidCallback?;

                  return buildPageWithSlideTransition(
                    context: context,
                    state: state,
                    child: CheckScreen(
                      appBarTitle: appBarTitle,
                      title: title,
                      info: info,
                      buttonTitle: buttonTitle,
                      onTap: onTap,
                    ),
                  );
                },
              ),
            ],
          ),

          GoRoute(
            path: "login_with_phone_number",
            pageBuilder: (context, state) {
              return buildPageWithSlideTransition(
                context: context,
                state: state,
                child: const LoginWithPhoneNumberScreen(),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: "/register",
        pageBuilder: (context, state) {
          return buildPageWithSlideTransition(
            context: context,
            state: state,
            child: const AuthScreen(isLogin: false),
          );
        },
        routes: [
          GoRoute(
            path: "privacy",
            pageBuilder: (context, state) {
              return buildPageWithSlideTransition(
                context: context,
                state: state,
                child: const PrivacyInformationScreen(),
              );
            },
          ),
          GoRoute(
            path: "email_verification",
            pageBuilder: (context, state) {
              return buildPageWithSlideTransition(
                context: context,
                state: state,
                child: const EmailVerificationScreen(),
              );
            },
          ),
          GoRoute(
            path: "login_with_google",
            pageBuilder: (context, state) {
              return buildPageWithSlideTransition(
                context: context,
                state: state,
                child: const LoginWithGooglesScreen(),
              );
            },
          ),
          GoRoute(
            path: "login_with_apple",
            pageBuilder: (context, state) {
              return buildPageWithSlideTransition(
                context: context,
                state: state,
                child: const LoginWithAppleScreen(),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: "/main_navigation_bar",
        pageBuilder: (context, state) {
          return buildPageWithSlideTransition(
            context: context,
            state: state,
            child: const MainNavigationBarScreen(),
          );
        },
      ),
      GoRoute(
        path: "/my_route",
        pageBuilder: (context, state) {
          return buildPageWithSlideTransition(
            context: context,
            state: state,
            child: const MyRouteScreen(),
          );
        },
      ),
      GoRoute(
        path: "/route_details",
        pageBuilder: (context, state) {
          return buildPageWithSlideTransition(
            context: context,
            state: state,
            child: const RouteDetailsScreen(),
          );
        },
      ),
      GoRoute(
        path: "/route_create",
        pageBuilder: (context, state) {
          return buildPageWithSlideTransition(
            context: context,
            state: state,
            child: const RouteCreateScreen(),
          );
        },
      ),
      GoRoute(
        path: "/route_edit",
        pageBuilder: (context, state) {
          final routeToEdit = state.extra as RouteModel?;

          return buildPageWithSlideTransition(
            context: context,
            state: state,
            child: RouteCreateScreen(routeToEdit: routeToEdit),
          );
        },
      ),
      GoRoute(
        path: "/add_image",
        pageBuilder: (context, state) {
          return buildPageWithSlideTransition(
            context: context,
            state: state,
            child: const AddImageScreen(),
          );
        },
      ),
      GoRoute(
        path: "/appointment",
        pageBuilder: (context, state) {
          return buildPageWithSlideTransition(
            context: context,
            state: state,
            child: const AppointmentScreen(),
          );
        },
      ),
      GoRoute(
        path: "/profile",
        pageBuilder: (context, state) {
          return buildPageWithSlideTransition(
            context: context,
            state: state,
            child: const ProfileScreen(),
          );
        },
        routes: [
          GoRoute(
            path: "personal_information",
            pageBuilder: (context, state) {
              return buildPageWithSlideTransition(
                context: context,
                state: state,
                child: const PersonalInformationScreen(),
              );
            },
          ),
          GoRoute(
            path: "change_password",
            pageBuilder: (context, state) {
              return buildPageWithSlideTransition(
                context: context,
                state: state,
                child: const ChangePassword(),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: "/reminder_settings",
        pageBuilder: (context, state) {
          return buildPageWithSlideTransition(
            context: context,
            state: state,
            child: const ReminderSettingsScreen(),
          );
        },
      ),
      GoRoute(
        path: "/reminder_saved",
        pageBuilder: (context, state) {
          return buildPageWithSlideTransition(
            context: context,
            state: state,
            child: const ReminderSavedScreen(),
          );
        },
      ),
      GoRoute(
        path: "/onboarding_permission",
        pageBuilder: (context, state) {
          return buildPageWithSlideTransition(
            context: context,
            state: state,
            child: const OnboardingPermissionScreen(),
          );
        },
      ),
      GoRoute(
        path: "/diary",
        pageBuilder: (context, state) {
          return buildPageWithSlideTransition(
            context: context,
            state: state,
            child: const DiaryScreen(),
          );
        },
      ),
    ],
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<AuthState> _subscription;

  GoRouterRefreshStream(Stream<AuthState> stream) {
    notifyListeners();
    AuthStatus? lastStatus;
    bool? lastHasSeenPermission;

    _subscription = stream.listen((state) {
      // Báo cho GoRouter khi AuthStatus hoặc hasSeenPermission thay đổi
      if (state.status != lastStatus ||
          state.hasSeenPermission != lastHasSeenPermission) {
        lastStatus = state.status;
        lastHasSeenPermission = state.hasSeenPermission;
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

CustomTransitionPage buildPageWithSlideTransition({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 100),

    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.1, 0.0);
      const end = Offset.zero;

      var positionTween = Tween(
        begin: begin,
        end: end,
      ).chain(CurveTween(curve: Curves.easeOutCubic));

      var opacityTween = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).chain(CurveTween(curve: Curves.easeOut));

      return FadeTransition(
        opacity: animation.drive(opacityTween),
        child: SlideTransition(
          position: animation.drive(positionTween),
          child: child,
        ),
      );
    },
  );
}
