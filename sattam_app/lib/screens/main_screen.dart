import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'chat_screen.dart';
import 'cases_screen.dart';
import 'lawyers_screen.dart';
import 'profile_screen.dart';
import 'package:sattam_app/l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';

import 'widgets/animated_nav_item.dart';
import 'widgets/chat_fab.dart';
import 'widgets/fade_slide_indexed_stack.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  final _chatKey = GlobalKey<ChatScreenState>();

  late AnimationController _navAppearController;
  late Animation<double> _navSlideAnimation;
  late Animation<double> _navFadeAnimation;

  final _icons = [
    Icons.home_rounded,
    Icons.smart_toy_rounded,
    Icons.gavel_rounded,
    Icons.account_balance_rounded,
    Icons.person_rounded,
  ];

  @override
  void initState() {
    super.initState();
    _navAppearController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    
    _navSlideAnimation = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _navAppearController, 
        curve: const SpringCurve(damping: 15, stiffness: 100),
      )
    );
    
    _navFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _navAppearController, 
        curve: Curves.easeOut,
      )
    );

    _navAppearController.forward();
    _requestNotificationPermissions();
  }

  Future<void> _requestNotificationPermissions() async {
    final status = await Permission.notification.status;
    if (!status.isGranted) {
      await Permission.notification.request();
    }
  }

  @override
  void dispose() {
    _navAppearController.dispose();
    super.dispose();
  }

  void _switchTab(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);
  }

  void _goToChat(String? query) {
    _switchTab(1);
    if (query != null && query.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _chatKey.currentState?.sendExternalQuery(query);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PopScope(
      canPop: _currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_currentIndex != 0) {
          _switchTab(0);
        }
      },
      child: Scaffold(
        backgroundColor: context.colors.bgBase,
        extendBody: true,
        body: Stack(
        children: [
          FadeSlideIndexedStack(
            index: _currentIndex,
            duration: const Duration(milliseconds: 350),
            children: [
              HomeScreen(onChatTap: _goToChat),
              ChatScreen(key: _chatKey, onBackTap: () => _switchTab(0)),
              const CasesScreen(),
              const LawyersScreen(),
              const ProfileScreen(),
            ],
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.fastOutSlowIn,
            left: 0,
            right: 0,
            bottom: _currentIndex == 1 ? -120 : 0,
            child: AnimatedBuilder(
              animation: _navAppearController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _navSlideAnimation.value),
                  child: Opacity(
                    opacity: _navFadeAnimation.value,
                    child: child,
                  ),
                );
              },
              child: _buildBottomNav(context, l10n),
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildBottomNav(BuildContext context, AppLocalizations l10n) {
    final labels = [l10n.home, l10n.aiChat, l10n.cases, l10n.lawyers, l10n.profile];
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                height: 64,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: context.colors.borderSubtle, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ]
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [0, 2, 3, 4].map((i) {
                    return AnimatedNavBarItem(
                      icon: _icons[i],
                      label: labels[i],
                      isActive: _currentIndex == i,
                      onTap: () => _switchTab(i),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // The FAB for AI Chat
            ChatFloatingActionButton(
              isActive: _currentIndex == 1,
              onTap: () => _switchTab(1),
            ),
          ],
        ),
      ),
    );
  }
}

class SpringCurve extends Curve {
  final double damping;
  final double stiffness;

  const SpringCurve({this.damping = 15, this.stiffness = 100});

  @override
  double transformInternal(double t) {
    // A simple damped harmonic oscillator approximation without bouncing past 1.0 (critically damped-ish)
    // Actually, if we want no bouncing, we just use a fastOutSlowIn curve, or we can use the formula:
    // f(t) = 1 - e^(-damping * t) * cos(stiffness * t) 
    // Wait, the user specifically said "no bouncy animations" in the prompt for other things, but for the nav bar appearance they said "Spring animation".
    // I will use an exponential decay curve that mimics a stiff spring.
    final c = 1.0 - (math.exp(-damping * t) * math.cos(10 * t));
    return c.clamp(0.0, 1.0); // Clamp to avoid any overshoot bouncing if they want it truly bouncy-free.
  }
}
