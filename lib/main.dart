import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stride/auth/auth_cubit/auth_cubit.dart';
import 'package:stride/navigator/app_router.dart';
import 'package:stride/repository/auth_repository.dart';
import 'package:stride/repository/route_repository.dart';
import 'package:stride/route/route_cubit/route_cubit.dart';
import 'package:stride/services/dio_client.dart';

void main() {
  // Có tác dụng cầu nối giữa flutter và hệ thống (android, ios)
  // Mặc định sau khi chạy runApp() thì cầu nối này mới được tạo ra
  // Nếu không có cầu nối này mà thực hiện xử lý bất đồng bộ trước runApp() thì
  // sẽ bị lỗi crack
  WidgetsFlutterBinding.ensureInitialized();

  final authRepository = AuthRepository(dio: DioClient.instance);
  final authCubit = AuthCubit(authRepository);

  // Truyền hàm callback xử lý khi bị hết hạn Token
  DioClient.setupInterceptors(() {
    // Khi Token hết hạn hoàn toàn, cập nhật AuthState về Unauthenticated
    authCubit.forceLogout();
  });

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
  late final AuthCubit _authCubit;
  late final RouteCubit _routeCubit;
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    final dio = DioClient.instance;

    _authRepository = AuthRepository(dio: dio);
    _routeRepository = RouteRepository(dio: dio);

    _authCubit = AuthCubit(_authRepository)..checkAuthStatus();
    _routeCubit = RouteCubit(_routeRepository);
    _appRouter = AppRouter(_authCubit);
  }

  @override
  void dispose() {
    _authCubit.close();
    _routeCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _authRepository),
        RepositoryProvider.value(value: _routeRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _authCubit),
          BlocProvider.value(value: _routeCubit),
        ],
        child: MaterialApp.router(
          title: 'Stride App',
          debugShowCheckedModeBanner: false,
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
