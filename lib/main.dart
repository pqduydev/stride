import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:stride/features/auth/auth_cubit/auth_cubit.dart';
import 'package:stride/navigator/app_router.dart';
import 'package:stride/repository/auth_repository.dart';
import 'package:stride/repository/route_repository.dart';
import 'package:stride/repository/user_repository.dart';
import 'package:stride/features/route/route_cubit/route_cubit.dart';
import 'package:stride/services/dio_client.dart';
import 'package:stride/features/user/user_cubit/user_cubit.dart';

void main() {
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

  @override
  void initState() {
    super.initState();
    final dio = DioClient.instance;

    _authRepository = AuthRepository(dio: dio);
    _routeRepository = RouteRepository(dio: dio);
    _userRepository = UserRepository(dio: dio);

    DioClient.setupInterceptors(() {
      // Khi Token hết hạn hoàn toàn, cập nhật AuthState về Unauthenticated
      _authCubit.forceLogout();
    });

    _authCubit = AuthCubit(_authRepository)..checkAuthStatus();
    _routeCubit = RouteCubit(_routeRepository);
    _userCubit = UserCubit(_userRepository);
    _appRouter = AppRouter(_authCubit);
  }

  @override
  void dispose() {
    _authCubit.close();
    _routeCubit.close();
    _userCubit.close();
    super.dispose();
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
        ],
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
    );
  }
}
