import 'package:flutter/material.dart';
import 'package:stride/screens/my_route_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stride App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFF7F8FA)),
        fontFamily: 'Inter',
      ),
      home: const MyRouteScreen(),
    );
  }
}
