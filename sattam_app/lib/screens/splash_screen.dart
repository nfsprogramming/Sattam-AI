import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/supabase_service.dart';
import 'main_screen.dart';
import 'login_screen.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _logoEntranceController;
  late AnimationController _textEntranceController;
  late AnimationController _breathingController;
  late AnimationController _loadingController;
  
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoScaleAnimation;
  
  late Animation<double> _titleSlideAnimation;
  late Animation<double> _titleFadeAnimation;
  late Animation<double> _taglineFadeAnimation;

  late Animation<double> _orbBreathingAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Logo Entrance Animation (800ms)
    _logoEntranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoEntranceController, curve: Curves.easeOut),
    );

    _logoScaleAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _logoEntranceController, curve: Curves.easeOutCubic),
    );

    // 2. Text Entrance Animation (700ms)
    _textEntranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _titleFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textEntranceController, curve: Curves.easeOut),
    );

    _titleSlideAnimation = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(parent: _textEntranceController, curve: Curves.easeOutCubic),
    );

    // Taglines fade in with delay
    _taglineFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textEntranceController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOut), // 200ms delay approximation
      ),
    );

    // 3. Glass Orb Breathing Animation (4 seconds)
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _orbBreathingAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOutSine),
    );

    // 4. Loading Bar Animation
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    // Start entrance animations
    _logoEntranceController.forward().then((_) {
      _breathingController.repeat(reverse: true);
    });
    
    // Start text entrance shortly after logo
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _textEntranceController.forward();
    });

    // Navigation logic
    Future.delayed(const Duration(seconds: 4), () async {
      if (mounted) {
        final prefs = await SharedPreferences.getInstance();
        final hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;
        final session = SupabaseService.client.auth.currentSession;
        
        Widget nextScreen;
        if (!hasSeenOnboarding) {
          nextScreen = const OnboardingScreen();
        } else {
          nextScreen = session != null ? const MainScreen() : const LoginScreen();
        }
        
        if (mounted) {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (_, _, _) => nextScreen,
              transitionDuration: const Duration(milliseconds: 800),
              transitionsBuilder: (_, anim, _, child) =>
                  FadeTransition(opacity: anim, child: child),
            ),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _logoEntranceController.dispose();
    _textEntranceController.dispose();
    _breathingController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000), // AMOLED Black
      body: Stack(
        children: [
          // 1. Solid Premium Dark Background to prevent banding
          Positioned.fill(
            child: Container(
              color: const Color(0xFF000000), // AMOLED Black
            ),
          ),
          
          // 2. Extremely subtle radial light behind the logo
          Align(
            alignment: Alignment.center,
            child: Transform.translate(
              offset: const Offset(0, -120), // Offset slightly to align behind the logo
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.06),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo Container with Entrance Animation
                  AnimatedBuilder(
                    animation: _logoEntranceController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _logoFadeAnimation,
                        child: Transform.scale(
                          scale: _logoScaleAnimation.value,
                          child: child,
                        ),
                      );
                    },
                    child: AnimatedBuilder(
                      animation: _breathingController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _orbBreathingAnimation.value,
                          child: child,
                        );
                      },
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 30,
                              offset: const Offset(0, 15), // Very soft ambient shadow
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.02),
                                border: Border.all(
                                  color: const Color.fromRGBO(255, 255, 255, 0.12),
                                  width: 1,
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.white.withValues(alpha: 0.12), // Soft reflection top only
                                    Colors.transparent,
                                  ],
                                  stops: const [0.0, 0.4],
                                ),
                              ),
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(41), // Half of 82px
                                  child: Image.asset(
                                    'assets/images/app_icon.jpeg',
                                    width: 82,
                                    height: 82,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Text Content with Entrance Animation
                  AnimatedBuilder(
                    animation: _textEntranceController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _titleSlideAnimation.value),
                        child: child,
                      );
                    },
                    child: Column(
                      children: [
                        FadeTransition(
                          opacity: _titleFadeAnimation,
                          child: Text(
                            'SattamAI',
                            style: GoogleFonts.playfairDisplay(
                              color: Colors.white,
                              fontSize: 36, // Reduced from 52
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        FadeTransition(
                          opacity: _taglineFadeAnimation,
                          child: Column(
                            children: [
                              Text(
                                'சட்டம்AI • நீதியின் குரல்',
                                style: GoogleFonts.notoSansTamil(
                                  color: const Color(0xFFD6E4FF),
                                  fontSize: 14, // Reduced from 18
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'EMPOWERING JUSTICE',
                                style: GoogleFonts.playfairDisplay(
                                  color: const Color(0xFF8B9BB5),
                                  fontSize: 11, // Reduced from 13
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 4, // Reduced from 6
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // Loading Indicator
                  FadeTransition(
                    opacity: _taglineFadeAnimation, // Reuse fade animation for the loading bar
                    child: SizedBox(
                      width: 160,
                      height: 4,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                          AnimatedBuilder(
                            animation: _loadingController,
                            builder: (context, child) {
                              return Align(
                                alignment: Alignment(-1.0 + (_loadingController.value * 2), 0),
                                child: Container(
                                  width: 80, // Size of the moving gradient block
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        Color(0xFF1D5FFF), // Blue
                                        Color(0xFF0D40CC), // Royal Blue
                                        Color(0xFFFFC24E), // Gold
                                        Colors.transparent,
                                      ],
                                      stops: [0.0, 0.3, 0.6, 0.8, 1.0],
                                    ),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
