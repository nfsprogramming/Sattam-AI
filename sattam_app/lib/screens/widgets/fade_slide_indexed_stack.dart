import 'package:flutter/material.dart';

class FadeSlideIndexedStack extends StatefulWidget {
  final int index;
  final List<Widget> children;
  final Duration duration;

  const FadeSlideIndexedStack({
    super.key,
    required this.index,
    required this.children,
    this.duration = const Duration(milliseconds: 350),
  });

  @override
  State<FadeSlideIndexedStack> createState() => _FadeSlideIndexedStackState();
}

class _FadeSlideIndexedStackState extends State<FadeSlideIndexedStack> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _previousIndex = 0;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index;
    _previousIndex = widget.index;
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      value: 1.0,
    );
  }

  @override
  void didUpdateWidget(FadeSlideIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.index != oldWidget.index) {
      _previousIndex = oldWidget.index;
      _currentIndex = widget.index;
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(widget.children.length, (i) {
        final isCurrent = i == _currentIndex;
        final isPrevious = i == _previousIndex;
        
        if (!isCurrent && !isPrevious) {
          // Keep it in the tree to preserve state, just make it Offstage
          return Offstage(
            offstage: true,
            child: widget.children[i],
          );
        }

        // We use a builder to avoid rebuilding children unnecessarily
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            double opacity = 0.0;
            double offsetX = 0.0;
            final t = Curves.easeOutCubic.transform(_controller.value);

            if (isCurrent && isPrevious) {
              // First load or no change
              opacity = 1.0;
              offsetX = 0.0;
            } else if (isCurrent) {
              // Animating IN
              opacity = t;
              offsetX = 20.0 * (1.0 - t);
            } else if (isPrevious) {
              // Animating OUT
              opacity = 1.0 - t;
              offsetX = -20.0 * t;
            }

            final bool isOffstage = !isCurrent && _controller.value == 1.0;
            
            return Offstage(
              offstage: isOffstage,
              child: Opacity(
                opacity: opacity,
                child: Transform.translate(
                  offset: Offset(offsetX, 0),
                  child: child,
                ),
              ),
            );
          },
          child: widget.children[i],
        );
      }),
    );
  }
}
