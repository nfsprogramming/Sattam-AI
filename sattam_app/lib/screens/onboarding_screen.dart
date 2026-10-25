import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';
import 'main_screen.dart';
import '../services/supabase_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _floatController;
  late AnimationController _gradientController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _floatController.dispose();
    _gradientController.dispose();
    super.dispose();
  }

  void _onNext() async {
    if (_currentPage == 2) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('has_seen_onboarding', true);

      if (!mounted) return;
      final session = SupabaseService.client.auth.currentSession;
      final nextScreen = session != null ? const MainScreen() : const LoginScreen();

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, _, _) => nextScreen,
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (_, anim, _, child) =>
              FadeTransition(opacity: anim, child: child),
        ),
      );
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  void _onSkip() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);

    if (!mounted) return;
    final session = SupabaseService.client.auth.currentSession;
    final nextScreen = session != null ? const MainScreen() : const LoginScreen();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, _, _) => nextScreen,
        transitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (_, anim, _, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000), // AMOLED Black
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // Top Navigation Area
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: context.colors.primary,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: context.colors.primary.withValues(alpha: 0.4),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.gavel, color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'SattamAI',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                              color: context.colors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      if (_currentPage != 2)
                        TextButton(
                          onPressed: _onSkip,
                          style: TextButton.styleFrom(
                            foregroundColor: context.colors.textMuted,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                          child: Text(
                            'Skip',
                            style: GoogleFonts.playfairDisplay(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                
                // Main Carousel Canvas
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const BouncingScrollPhysics(),
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: [
                      _buildSlide(
                        icon: Icons.forum_rounded,
                        accentColor: context.colors.primary,
                        titleEng: 'Legal Help in Your Language',
                        titleTam: 'உங்கள் மொழியில் சட்ட உதவி',
                        description: 'Access AI-driven legal assistance in both Tamil and English, bridging the gap between complexity and clarity.',
                      ),
                      _buildSlide(
                        icon: Icons.admin_panel_settings_rounded,
                        accentColor: context.colors.secondary,
                        titleEng: 'Digital Evidence Locker',
                        titleTam: 'டிஜிட்டல் ஆவண பெட்டகம்',
                        description: 'Securely store, organize, and timestamp your documents and media in a high-security vault.',
                      ),
                      _buildSlide(
                        icon: Icons.verified_user_rounded,
                        accentColor: context.colors.tertiary,
                        titleEng: 'Connect with Experts',
                        titleTam: 'வழக்கறிஞர்களுடன் இணைப்பு',
                        description: 'Direct access to vetted legal professionals specialized in Tamil Nadu state laws.',
                      ),
                    ],
                  ),
                ),
                
                // Bottom Action Area
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 50),
                  child: Column(
                    children: [
                      // Smooth Page Indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          3,
                          (index) {
                            final isSelected = _currentPage == index;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeOutCubic,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              height: 6,
                              width: isSelected ? 32 : 12,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? context.colors.primary
                                    : context.colors.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 40),
                      
                      // Next / Get Started Button
                      GestureDetector(
                        onTap: _onNext,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: 60,
                          decoration: BoxDecoration(
                            color: context.colors.primary,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: context.colors.primary.withValues(alpha: 0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              )
                            ],
                          ),
                          child: Stack(
                            children: [
                              // Subtle shine effect
                              Positioned(
                                top: 0, left: 20, right: 20,
                                child: Container(
                                  height: 2,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _currentPage == 2 ? 'Get Started' : 'Next Step',
                                      style: GoogleFonts.playfairDisplay(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Icon(
                                      _currentPage == 2 ? Icons.rocket_launch_rounded : Icons.arrow_forward_rounded,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Terms and Conditions
                      Text.rich(
                        TextSpan(
                          text: 'By continuing, you agree to our ',
                          children: [
                            TextSpan(
                              text: 'Legal Terms',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationColor: context.colors.primary,
                                color: context.colors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        style: GoogleFonts.playfairDisplay(
                          color: context.colors.textMuted,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlide({
    required IconData icon,
    required Color accentColor,
    required String titleEng,
    required String titleTam,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Elegant Floating Icon Display
          SizedBox(
            height: 280,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Soft glow background behind icon
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        accentColor.withValues(alpha: 0.2),
                        Colors.transparent
                      ],
                      radius: 0.7,
                    ),
                  ),
                ),
                AnimatedBuilder(
                  animation: _floatController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, -12 * (1 - _floatController.value)),
                      child: child,
                    );
                  },
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      color: context.colors.surface,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: accentColor.withValues(alpha: 0.3), 
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        icon, 
                        color: accentColor, 
                        size: 72,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // Modern Typography Layout
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              titleTam,
              style: GoogleFonts.notoSansTamil(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: accentColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          
          Text(
            titleEng,
            style: GoogleFonts.playfairDisplay(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: context.colors.textPrimary,
              height: 1.2,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          
          Text(
            description,
            style: GoogleFonts.playfairDisplay(
              fontSize: 16,
              color: context.colors.textMuted,
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
