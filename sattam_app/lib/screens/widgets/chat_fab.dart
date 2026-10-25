import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class ChatFloatingActionButton extends StatefulWidget {
  final bool isActive;
  final VoidCallback onTap;

  const ChatFloatingActionButton({
    super.key,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<ChatFloatingActionButton> createState() => _ChatFloatingActionButtonState();
}

class _ChatFloatingActionButtonState extends State<ChatFloatingActionButton> with TickerProviderStateMixin {
  late AnimationController _breathingController;
  late Animation<double> _breathingScale;

  late AnimationController _pressController;
  late Animation<double> _pressScale;

  @override
  void initState() {
    super.initState();

    // Breathing Animation
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _breathingScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.03).chain(CurveTween(curve: Curves.easeInOutSine)), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.03, end: 1.0).chain(CurveTween(curve: Curves.easeInOutSine)), weight: 50),
    ]).animate(_breathingController);
    _breathingController.repeat();

    // Press Animation (220ms)
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _pressScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.93).chain(CurveTween(curve: Curves.easeOut)), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 0.93, end: 1.05).chain(CurveTween(curve: Curves.easeInOut)), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.05, end: 1.0).chain(CurveTween(curve: Curves.easeIn)), weight: 30),
    ]).animate(_pressController);
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _pressController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _pressController.forward(from: 0.0);
  }

  void _handleTap() {
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.isActive ? context.colors.tertiary : context.colors.primary;
    final iconColor = widget.isActive ? Colors.black : Colors.white;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([_breathingController, _pressController]),
        builder: (context, child) {
          final currentScale = _breathingScale.value * _pressScale.value;
          
          return Transform.scale(
            scale: currentScale,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: baseColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chat_bubble_rounded,
                color: iconColor,
                size: 28,
              ),
            ),
          );
        },
      ),
    );
  }
}
