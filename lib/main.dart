import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stride/auth/auth_cubit/auth_cubit.dart';
import 'package:stride/navigator/app_router.dart';
import 'package:stride/repository/auth_repository.dart';
import 'package:stride/repository/route_repository.dart';
import 'package:stride/route/route_cubit/route_cubit.dart';

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
  late final AuthCubit _authCubit;
  late final RouteCubit _routeCubit;
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _authRepository = AuthRepository();
    _routeRepository = RouteRepository();
    _authCubit = AuthCubit(_authRepository)..checkAuthStatus();
    _routeCubit = RouteCubit(_routeRepository)..loadRoutes();
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
