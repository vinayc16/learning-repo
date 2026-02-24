import 'package:flutter/material.dart';
import 'package:learning_statemanejment/ai_power_app/widget/custom_text.dart';
import 'package:learning_statemanejment/study_buddy_ai_power/utils/apploader.dart';
import 'dart:async';
import '../services/auth_service.dart';
import 'auth/login_screen.dart';
import 'main_navigation_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  final _authService = AuthService();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Setup animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _animationController.forward();

    // Navigate after splash duration
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    // Wait for animation to complete
    await Future.delayed(const Duration(milliseconds: 2500));

    // Check authentication status
    final isLoggedIn = await _authService.isLoggedIn();

    if (!mounted) return;

    // Navigate to appropriate screen
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
        isLoggedIn ? const MainNavigationScreen() : const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667EEA),
              Color(0xFF764BA2),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 4),

                // Animated Logo
                // ScaleTransition(
                //   scale: _scaleAnimation,
                //   child: FadeTransition(
                //     opacity: _fadeAnimation,
                //     child: Container(
                //       padding: const EdgeInsets.all(30),
                //       decoration: BoxDecoration(
                //         color: Colors.white.withOpacity(0.2),
                //         shape: BoxShape.circle,
                //         boxShadow: [
                //           BoxShadow(
                //             color: Colors.black.withOpacity(0.2),
                //             blurRadius: 20,
                //             offset: const Offset(0, 10),
                //           ),
                //         ],
                //       ),
                //       child: const Icon(
                //         Icons.school_rounded,
                //         size: 100,
                //         color: Colors.white,
                //       ),
                //     ),
                //   ),
                // ),
                //
                // const SizedBox(height: 30),

                // App Title
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: const CustomText(
                    text: 'Study Buddy',
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                  ),
                ),

                const SizedBox(height: 12),

                // Subtitle
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: CustomText(
                    text: 'Your AI-Powered Study Assistant',
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4,),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: CustomText(
                    text: 'Unlock Your Learning Potential with AI-Powered Study Assistance!',
                    fontSize: 12,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    color: Colors.white.withOpacity(0.9),
                    //fontWeight: FontWeight.w500,
                  ),
                ),

                const Spacer(flex: 2),

                // Loading Indicator
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      const SizedBox(
                        width: 40,
                        height: 40,
                        child: AppLoader(color: Colors.white)
                      ),
                      const SizedBox(height: 20),
                      CustomText(
                        text: 'Preparing your learning experience...',
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                // Powered by text
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: CustomText(
                    text: 'POWERED BY GOOGLE GEMINI',
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.6),
                      fontWeight: FontWeight.bold,
                  ),
                ),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: CustomText(
                    text: 'Developed By Vinay Chauhan',
                    fontSize: 10,
                    color: Colors.white.withOpacity(0.6),
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
