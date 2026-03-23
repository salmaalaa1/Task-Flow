import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_colors.dart';
import '../theme/theme_utils.dart';
import 'sign_in_screen.dart';
import 'main_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _scale = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Cubic(0.34, 1.56, 0.64, 1)),
    );
    _controller.forward();

    // Check session after animation
    Future.delayed(const Duration(milliseconds: 2000), _checkSession);
  }

  Future<void> _checkSession() async {
    if (!mounted) return;
    final auth = context.read<AuthProvider>();
    final isLoggedIn = await auth.tryAutoLogin();

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) =>
            isLoggedIn ? const MainShell() : const SignInScreen(),
        transitionsBuilder: (_, a, __, child) =>
            FadeTransition(opacity: a, child: child),
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: context.isDark
                ? [const Color(0xFF121218), const Color(0xFF1A1A28), const Color(0xFF121218)]
                : [AppColors.surface, AppColors.primaryFixed.withValues(alpha: 0.3), AppColors.surface],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -100, right: -80,
              child: Container(
                width: 300, height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    AppColors.primary.withValues(alpha: 0.08),
                    AppColors.primary.withValues(alpha: 0.0),
                  ]),
                ),
              ),
            ),
            Positioned(
              bottom: -60, left: -100,
              child: Container(
                width: 350, height: 350,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    AppColors.tertiary.withValues(alpha: 0.06),
                    AppColors.tertiary.withValues(alpha: 0.0),
                  ]),
                ),
              ),
            ),
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (_, child) => Opacity(
                  opacity: _fadeIn.value,
                  child: Transform.scale(scale: _scale.value, child: child),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 30, offset: const Offset(0, 10))],
                      ),
                      child: const Icon(Icons.check_rounded, color: Colors.white, size: 40),
                    ),
                    const SizedBox(height: 24),
                    Text('TaskFlow.',
                        style: GoogleFonts.manrope(fontSize: 40, fontWeight: FontWeight.w800, color: AppColors.onSurface, letterSpacing: -1.5)),
                    const SizedBox(height: 8),
                    Text('The Ethereal Workspace',
                        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.onSurfaceVariant, letterSpacing: 2)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
