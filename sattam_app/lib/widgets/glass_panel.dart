import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Reusable glassmorphism container matching the Stitch UI "glass-panel" class
class GlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final double? borderWidth;
  final Color? backgroundColor;
  final List<BoxShadow>? boxShadow;

  const GlassPanel({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.borderColor,
    this.borderWidth,
    this.backgroundColor,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? context.colors.glassPanel,
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        border: Border.all(
          color: borderColor ?? context.colors.borderSubtle,
          width: borderWidth ?? 1.5,
        ),
        boxShadow: boxShadow,
      ),
      child: child,
    );
  }
}

/// Glassmorphism with blur effect (more expensive, use sparingly)
class BlurGlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final double blurAmount;

  const BlurGlassPanel({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.blurAmount = 20,
  });

  @override
  Widget build(BuildContext context) {
    final br = borderRadius ?? BorderRadius.circular(16);
    return ClipRRect(
      borderRadius: br,
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.glassPanel,
          borderRadius: br,
          border: Border.all(color: context.colors.borderSubtle, width: 1.5),
        ),
        padding: padding,
        child: child,
      ),
    );
  }
}
