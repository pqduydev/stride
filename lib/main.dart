import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:stride/features/auth/auth_cubit/auth_cubit.dart';
import 'package:stride/features/auth/auth_cubit/auth_state.dart';
import 'package:stride/features/reminder/reminder_cubit/reminder_cubit.dart';
import 'package:stride/features/reminder/reminder_scheduler.dart';
import 'package:stride/firebase_options.dart';
import 'package:stride/navigator/app_router.dart';
import 'package:stride/repository/auth_repository.dart';
import 'package:stride/repository/device_token_repository.dart';
import 'package:stride/repository/reminder_settings_repository.dart';
import 'package:stride/repository/route_repository.dart';
import 'package:stride/repository/user_repository.dart';
import 'package:stride/features/route/route_cubit/route_cubit.dart';
import 'package:stride/services/dio_client.dart';
import 'package:stride/features/user/user_cubit/user_cubit.dart';
import 'package:stride/services/notification_router.dart';
import 'package:stride/services/notification_service.dart';
import 'package:stride/services/push_service.dart';
import 'package:toastification/toastification.dart';

Future<void> main() async {
  // Bắt buộc khi cần gọi plugin trước runApp
  WidgetsFlutterBinding.ensureInitialized();

  // Xin các quyền về thông báo
  await NotificationService.instance.init();

  // Kết nối Firebase bằng file firebase_options.dart
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Xử lý thông báo khi tắt/chạy nền
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthRepository _authRepository;
  late final RouteRepository _routeRepository;
  late final UserRepository _userRepository;

  late final AuthCubit _authCubit;
  late final RouteCubit _routeCubit;
  late final UserCubit _userCubit;
  late final AppRouter _appRouter;
  late final ReminderCubit _reminderCubit;
  late final PushService _pushService;

  StreamSubscription<Map<String, dynamic>>? _tapSub;

  StreamSubscription<AuthState>? _authSub;
  AuthStatus? _lastAuthStatus;

  @override
  void initState() {
    super.initState();
    final dio = DioClient.instance;

    _authRepository = AuthRepository(dio: dio);
    _routeRepository = RouteRepository(dio: dio);
    _userRepository = UserRepository(dio: dio);
    _pushService = PushService(DeviceTokenRepository(dio: dio));
    _pushService.init();

    // Khi Token hết hạn hoàn toàn
    DioClient.setupInterceptors(() {
      // Xóa FCM Token ở local (nếu có) để tránh gửi lên Backend khi đã logout
      _pushService.deleteLocalToken();
      // cập nhật AuthState về Unauthenticated
      _authCubit.forceLogout();
    });

    _authCubit = AuthCubit(
      _authRepository,
      beforeLogout: _pushService.unregisterToken,
    )..checkAuthStatus();
    _routeCubit = RouteCubit(_routeRepository);
    _userCubit = UserCubit(_userRepository);
    _appRouter = AppRouter(_authCubit);

    _reminderCubit = ReminderCubit(
      ReminderSettingsRepository(),
      ReminderScheduler(NotificationService.instance),
    )..load();

    // Bấm thông báo khi ứng dụng chạy nền
    _tapSub = NotificationService.instance.onTap.listen((data) {
      // Chưa đăng nhập thì không mở màn nào (router sẽ đá về Welcome)
      if (_authCubit.state.status == AuthStatus.authenticated) {
        openFromNotification(_appRouter.router, data);
      }
    });

    _authSub = _authCubit.stream.listen(_onAuthChanged);
  }

  @override
  void dispose() {
    _authCubit.close();
    _routeCubit.close();
    _userCubit.close();
    _reminderCubit.close();
    _tapSub?.cancel();
    _authSub?.cancel();
    super.dispose();
  }

  void _onAuthChanged(AuthState state) {
    // AuthCubit emit cả khi chỉ đổi user (updateUserInMemory) → chỉ xử lý khi status đổi
    if (state.status == _lastAuthStatus) return;
    _lastAuthStatus = state.status;

    if (state.status == AuthStatus.authenticated) {
      _reminderCubit.load(); // prefs có thể vừa đổi do đổi tài khoản
      _pushService.syncToken(); // Đăng ký FCM Token với Backend khi đăng nhập/đăng nhập sẵn
    } else if (state.status == AuthStatus.unauthenticated) {
      NotificationService.instance.cancelAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _authRepository),
        RepositoryProvider.value(value: _routeRepository),
        RepositoryProvider.value(value: _userRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _authCubit),
          BlocProvider.value(value: _routeCubit),
          BlocProvider.value(value: _userCubit),
          BlocProvider.value(value: _reminderCubit),
        ],
        child: ToastificationWrapper(
          config: const ToastificationConfig(
            // Nếu user spam 10 lần, nó cũng chỉ hiện 3 cái.
            maxToastLimit: 3,

            itemWidth: 300, // Chiều rộng tối đa của toast
          ),
          child: MaterialApp.router(
            title: 'Stride App',
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('vi', 'VN'), Locale('en', 'US')],
            locale: const Locale('vi', 'VN'),
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFFF7F8FA),
              ),
              fontFamily: 'Inter',
            ),
            routerConfig: _appRouter.router,
          ),
        ),
      ),
    );
  }
}
