import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stride/features/auth/auth_cubit/auth_cubit.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Logic checkAuthStatus đã có sẵn 1 giây delay,
    // vừa đủ để xem hết hiệu ứng animate bên dưới.
    context.read<AuthCubit>().checkAuthStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Center(
        child: SvgPicture.asset('assets/branding/splash_icon.svg')
            .animate()
            .fade(duration: 800.ms, curve: Curves.easeOut)
            .slideY(
              begin: 0.3, // Trượt từ dưới lên (30% so với vị trí gốc)
              end: 0.0,
              duration: 800.ms,
              curve: Curves.easeOutCubic,
            )
            .scale(
              begin: const Offset(0.7, 0.7), // Hơi phóng to nhẹ tạo chiều sâu
              end: const Offset(1.0, 1.0),
              duration: 800.ms,
              curve: Curves.easeOutCubic,
            ),
      ),
    );
  }
}
