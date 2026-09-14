import 'package:go_router/go_router.dart';
import 'package:stride/model/route_model.dart';
import 'package:stride/screens/add_image_screen.dart';
import 'package:stride/screens/main_navigation_bar_screen.dart';
import 'package:stride/route/screen/my_route_screen.dart';
import 'package:stride/screens/route_create_screen.dart';
import 'package:stride/screens/route_details_screen.dart';
import 'package:stride/auth/screen/auth_screen.dart';

class AppRouter {
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
      GoRoute(
        path: "/login",
        builder: (context, state) => AuthScreen(isLogin: true),
      ),
    ],
  );
}
