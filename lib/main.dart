import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stride/model/route_model.dart';
import 'package:stride/route/route_cubit/route_cubit.dart';
import 'package:stride/repository/route_repository.dart';
import 'package:stride/screens/add_image_screen.dart';
import 'package:stride/screens/main_navigation_bar_screen.dart';
import 'package:stride/route/screen/my_route_screen.dart';
import 'package:stride/screens/route_create_screen.dart';
import 'package:stride/screens/route_details_screen.dart';
import 'package:stride/user/screen/auth_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: "/main_navigation_bar",
  routes: [
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
      path: "/register",
      builder: (context, state) => AuthScreen(isLogin: false),
    ),
  ],
);

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
          routerConfig: router,
        ),
      ),
    );
  }
}
