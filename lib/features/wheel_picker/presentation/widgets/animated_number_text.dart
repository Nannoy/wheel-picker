import 'package:flutter/material.dart';
import 'dart:ui';

/// A text widget that smoothly animates between number values
/// with a fade and slide transition effect
class SmoothNumberDisplay extends StatefulWidget {
  /// The current number value to display
  final int displayValue;
  
  /// Custom text styling for the number
  final TextStyle? textStyle;
  
  /// Duration of the transition animation
  final Duration transitionDuration;

  const SmoothNumberDisplay({
    super.key,
    required this.displayValue,
    this.textStyle,
    this.transitionDuration = const Duration(milliseconds: 350),
  });

  @override
  State<SmoothNumberDisplay> createState() => _SmoothNumberDisplayState();
}

class _SmoothNumberDisplayState extends State<SmoothNumberDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _transitionController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  int _previousValue = 0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _transitionController = AnimationController(
      duration: widget.transitionDuration,
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _transitionController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _transitionController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void didUpdateWidget(SmoothNumberDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.displayValue != widget.displayValue) {
      _previousValue = oldWidget.displayValue;
      _transitionController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _transitionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _transitionController,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Fading out previous value
            if (_transitionController.value < 1.0)
              Transform.translate(
                offset: Offset(0, -15 * (1 - _transitionController.value)),
                child: Opacity(
                  opacity: 1 - _transitionController.value,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(
                      sigmaX: 1.5, 
                      sigmaY: 1.5
                    ),
                    child: Text(
                      _previousValue.toString(),
                      style: widget.textStyle ?? const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            // Sliding in new value
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  widget.displayValue.toString(),
                  style: widget.textStyle ?? const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
