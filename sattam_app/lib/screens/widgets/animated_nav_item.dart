import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';

class AnimatedNavBarItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const AnimatedNavBarItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<AnimatedNavBarItem> createState() => _AnimatedNavBarItemState();
}

class _AnimatedNavBarItemState extends State<AnimatedNavBarItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _liftAnimation;
  late Animation<double> _labelSlideAnimation;
  late Animation<double> _labelOpacityAnimation;

  @override
  void initState() {
    super.initState();
    // Use 280ms duration for the main icon pop animation sequence
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );

    // Scale: 1.0 -> 1.18 -> 1.0
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.18).chain(CurveTween(curve: Curves.easeOutCubic)), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.18, end: 1.0).chain(CurveTween(curve: Curves.easeInCubic)), weight: 60),
    ]).animate(_controller);

    // Rotate: 0 -> 8deg (0.139 rad) -> 0
    _rotateAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.139).chain(CurveTween(curve: Curves.easeOutCubic)), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 0.139, end: 0.0).chain(CurveTween(curve: Curves.easeInCubic)), weight: 60),
    ]).animate(_controller);

    // Lift: 0 -> -6px -> 0
    _liftAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -6.0).chain(CurveTween(curve: Curves.easeOutCubic)), weight: 40),
      TweenSequenceItem(tween: Tween(begin: -6.0, end: 0.0).chain(CurveTween(curve: Curves.easeInCubic)), weight: 60),
    ]).animate(_controller);

    // Label slide up: 4px -> 0px
    _labelSlideAnimation = Tween<double>(begin: 4.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.9, curve: Curves.easeOutCubic))
    );
    
    _labelOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.9, curve: Curves.easeOut))
    );

    if (widget.isActive) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(AnimatedNavBarItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller.forward(from: 0.0);
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    HapticFeedback.lightImpact();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final bool isActive = widget.isActive;
    
    return InkWell(
      onTap: _handleTap,
      splashColor: Colors.white.withValues(alpha: 0.1),
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        // 420ms duration, pseudo spring curve
        duration: const Duration(milliseconds: 420),
        curve: Curves.fastOutSlowIn,
        padding: EdgeInsets.symmetric(horizontal: isActive ? 10 : 6, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? context.colors.surfaceContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(isActive ? 20 : 16),
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // Icon states
            final currentScale = isActive ? _scaleAnimation.value : 0.95;
            final currentRotate = isActive ? _rotateAnimation.value : 0.0;
            final currentLift = isActive ? _liftAnimation.value : 0.0;
            final iconOpacity = isActive ? 1.0 : 0.7;

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.translate(
                  offset: Offset(0, currentLift),
                  child: Transform.rotate(
                    angle: currentRotate,
                    child: Transform.scale(
                      scale: currentScale,
                      child: Icon(
                        widget.icon,
                        color: context.colors.textPrimary.withValues(alpha: iconOpacity),
                        size: 24,
                      ),
                    ),
                  ),
                ),
                if (isActive) ...[
                  const SizedBox(width: 4),
                  Transform.translate(
                    offset: Offset(0, _labelSlideAnimation.value),
                    child: Opacity(
                      opacity: _labelOpacityAnimation.value,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 55),
                        child: Text(
                          widget.label,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            color: context.colors.textPrimary,
                            fontWeight: FontWeight.w700, 
                            fontSize: 12,
                            letterSpacing: -0.2,
                          )
                        ),
                      ),
                    ),
                  )
                ]
              ],
            );
          },
        ),
      ),
    );
  }
}
