import 'package:attendance_cnn_app/core/domain/models/users_model.dart';
import 'package:attendance_cnn_app/features/authentication/presentation/providers/auth_notifier.dart';
import 'package:attendance_cnn_app/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  Future<void> _startSplashScreen() async {
    try {
      final result = await Future.wait([
        Future.delayed(const Duration(seconds: 3)),

        ref.read(authNotifierProvider.future),
      ]);

      final user = result[1] as Users?;

      if (!mounted) return;

      if (user != null) {
        if (user.role == 'admin') {
          context.go('/home/admin');
        } else {
          context.go('/home');
        }
      } else {
        context.go('/login');
      }
    } catch (e) {
      if (mounted) context.go('/login');
    }
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();

    _startSplashScreen();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Center(
        child: FadeTransition(
          opacity: _controller,
          child: Image.asset('assets/logo_app.png', width: 150),
        ),
      ),
    );
  }
}
