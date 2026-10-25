import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimatedBottomNavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const AnimatedBottomNavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<AnimatedBottomNavItem> createState() => _AnimatedBottomNavItemState();
}

class _AnimatedBottomNavItemState extends State<AnimatedBottomNavItem> with TickerProviderStateMixin {
  late AnimationController _iconController;
  late AnimationController _labelController;

  late Animation<double> _iconScaleAnim;
  late Animation<double> _iconRotateAnim;
  late Animation<double> _iconLiftAnim;

  late Animation<double> _labelSlideAnim;
  late Animation<double> _labelFadeAnim;

  @override
  void initState() {
    super.initState();

    // Icon Animation Controller (280ms)
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );

    // Multi-stage Icon Scale: 1.0 -> 1.18 -> 1.0
    _iconScaleAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.18).chain(CurveTween(curve: Curves.easeOut)), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.18, end: 1.0).chain(CurveTween(curve: Curves.easeIn)), weight: 60),
    ]).animate(_iconController);

    // Multi-stage Icon Rotate: 0 -> 8 deg -> 0
    // 8 degrees = 8 * pi / 180 = 0.1396 rad
    _iconRotateAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.1396).chain(CurveTween(curve: Curves.easeOut)), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 0.1396, end: 0.0).chain(CurveTween(curve: Curves.easeIn)), weight: 60),
    ]).animate(_iconController);

    // Icon Lift: 0 -> -6px
    _iconLiftAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -6.0).chain(CurveTween(curve: Curves.easeOut)), weight: 40),
      TweenSequenceItem(tween: Tween(begin: -6.0, end: 0.0).chain(CurveTween(curve: Curves.easeIn)), weight: 60),
    ]).animate(_iconController);

    // Label Animation Controller (250ms)
    _labelController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _labelSlideAnim = Tween<double>(begin: 4.0, end: 0.0).animate(CurvedAnimation(
      parent: _labelController,
      curve: Curves.easeOutCubic,
    ));

    _labelFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _labelController,
      curve: Curves.easeIn,
    ));

    if (widget.isActive) {
      _iconController.value = 1.0;
      _labelController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(AnimatedBottomNavItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _iconController.forward(from: 0.0);
        _labelController.forward();
      } else {
        _labelController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _iconController.dispose();
    _labelController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!widget.isActive) {
      HapticFeedback.lightImpact();
      widget.onTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 420),
        curve: const SpringCurve(), // Custom spring curve defined below
        padding: EdgeInsets.symmetric(horizontal: widget.isActive ? 14 : 10, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.isActive ? 32 : 16),
          color: widget.isActive 
              ? Colors.white.withValues(alpha: 0.12)
              : Colors.transparent,
        ),
        // Add subtle scale and opacity to the pill itself
        child: AnimatedScale(
          scale: widget.isActive ? 1.0 : 0.96,
          duration: const Duration(milliseconds: 420),
          curve: const SpringCurve(),
          child: AnimatedOpacity(
            opacity: widget.isActive ? 1.0 : 0.85,
            duration: const Duration(milliseconds: 420),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon wrapper
                AnimatedBuilder(
                  animation: _iconController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _iconLiftAnim.value),
                      child: Transform.rotate(
                        angle: _iconRotateAnim.value,
                        child: Transform.scale(
                          scale: widget.isActive ? _iconScaleAnim.value : 0.95,
                          child: Icon(
                            widget.icon,
                            color: widget.isActive ? Colors.white : Colors.white.withValues(alpha: 0.7),
                            size: 24,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                // Label
                AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  child: widget.isActive
                      ? Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: AnimatedBuilder(
                            animation: _labelController,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(0, _labelSlideAnim.value),
                                child: Opacity(
                                  opacity: _labelFadeAnim.value,
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(maxWidth: 70),
                                    child: Text(
                                      widget.label,
                                      style: GoogleFonts.plusJakartaSans(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                        letterSpacing: -0.2, // slight decrease in letter spacing
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Custom spring curve for 420ms duration targeting high damping, medium stiffness
class SpringCurve extends Curve {
  const SpringCurve();

  @override
  double transformInternal(double t) {
    // A standard dampened harmonic oscillator approximation
    final double s = 1.0 - t;
    return 1.0 - (pow(e, -6.0 * t) * cos(t * 8.0) * s);
  }
}
