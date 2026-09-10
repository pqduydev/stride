import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stride/screens/main_navigation_bar_screen.dart';
import 'package:stride/screens/my_route_screen.dart';
import 'package:stride/screens/route_create_screen.dart';
import 'package:stride/screens/route_details_screen.dart';

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
  ],
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Stride App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFF7F8FA)),
        fontFamily: 'Inter',
      ),
      routerConfig: router,
    );
  }
}
