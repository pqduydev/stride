import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stride/navigator/app_router.dart';
import 'package:stride/route/route_cubit/route_cubit.dart';
import 'package:stride/repository/route_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => RouteRepository(),
      child: BlocProvider(
        create: (context) =>
            RouteCubit(RepositoryProvider.of<RouteRepository>(context))
              ..loadRoutes(), // Tải danh sách lộ trình khi khởi tạo
        child: MaterialApp.router(
          title: 'Stride App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFF7F8FA)),
            fontFamily: 'Inter',
          ),
          routerConfig: AppRouter().router,
        ),
      ),
    );
  }
}
