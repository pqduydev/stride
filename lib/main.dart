import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stride/screens/my_route_screen.dart';
import 'package:stride/screens/route_details_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: "/my_route",
  routes: [
    GoRoute(
      path: "/my_route",
      builder: (context, state) => const MyRouteScreen(),
    ),
    GoRoute(
      path: "/route_details",
      builder: (context, state) => const RouteDetailsScreen(),
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
      // home: const RouteDetailsScreen(),
      routerConfig: router,
    );
  }
}
