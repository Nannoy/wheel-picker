import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A wheel picker with smooth scrolling and bounce effects
/// 
/// This widget creates an interactive wheel that allows users
/// to select values by dragging. It features momentum scrolling,
/// boundary bouncing, and customizable appearance.
class WheelPicker extends StatefulWidget {
  /// The lowest selectable value on the dial
  final double lowerBound;
  
  /// The highest selectable value on the dial
  final double upperBound;
  
  /// How responsive the dial is to touch movements
  /// Higher values make it more sensitive to small movements
  final double touchSensitivity;
  
  /// How much the dial can extend beyond boundaries during overscroll
  /// Lower values create more resistance when reaching limits
  final double boundaryResistance;
  
  /// How quickly momentum scrolling slows down
  /// Values closer to 1.0 make it spin longer
  final double momentumDecay;
  
  /// Minimum speed required to start momentum scrolling
  final double momentumThreshold;
  
  /// Size of the wheel in pixels
  final double dialSize;
  
  /// Widget displayed in the center of the wheel
  final Widget? centerWidget;
  
  /// Called whenever the selected value changes
  final Function(double selectedValue)? onValueSelected;

  const WheelPicker({
    super.key,
    this.lowerBound = 0,
    this.upperBound = 100,
    this.touchSensitivity = 0.12,
    this.boundaryResistance = 0.035,
    this.momentumDecay = 0.94,
    this.momentumThreshold = 4.5,
    this.dialSize = 200.0,
    this.centerWidget,
    this.onValueSelected,
  });

  @override
  State<WheelPicker> createState() => _WheelPickerState();
}

class _WheelPickerState extends State<WheelPicker>
    with TickerProviderStateMixin {
  double _currentSelection = 0;
  double _scrollSpeed = 0;
  late AnimationController _momentumController;
  late AnimationController _bounceController;
  Animation<double>? _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _momentumController = AnimationController.unbounded(vsync: this)
      ..addListener(_handleMomentumFrame);
    _bounceController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _momentumController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  /// Initiates momentum scrolling if speed is sufficient
  void _beginMomentumScroll() {
    if (_currentSelection < widget.lowerBound || _currentSelection > widget.upperBound) {
      _animateToValidRange();
      return;
    }
    
    if (_scrollSpeed.abs() < widget.momentumThreshold) return;

    _momentumController.stop();
    _momentumController.value = 0;
    _momentumController.animateTo(
      1,
      duration: const Duration(seconds: 4),
      curve: Curves.linear,
    );
  }

  /// Handles each frame of momentum scrolling
  void _handleMomentumFrame() {
    _scrollSpeed *= widget.momentumDecay;
    
    if (_scrollSpeed.abs() < 0.01) {
      _momentumController.stop();
      return;
    }

    final newValue = _currentSelection + _scrollSpeed * 0.016;

    if (newValue < widget.lowerBound || newValue > widget.upperBound) {
      _momentumController.stop();
      _animateToValidRange();
    } else {
      setState(() {
        _currentSelection = newValue;
        _notifyValueChange();
      });
    }
  }

  /// Animates the selection back to valid range with bounce effect
  void _animateToValidRange() {
    double targetValue = _currentSelection;
    
    if (_currentSelection < widget.lowerBound) {
      targetValue = widget.lowerBound;
    } else if (_currentSelection > widget.upperBound) {
      targetValue = widget.upperBound;
    }

    _bounceAnimation = Tween<double>(
      begin: _currentSelection,
      end: targetValue,
    ).animate(CurvedAnimation(
      parent: _bounceController, 
      curve: Curves.elasticOut
    ));

    _bounceAnimation!.removeListener(_handleBounceFrame);
    _bounceAnimation!.addListener(_handleBounceFrame);

    _bounceController
      ..stop()
      ..duration = const Duration(milliseconds: 800)
      ..reset()
      ..forward();
  }

  void _handleBounceFrame() {
    setState(() {
      _currentSelection = _bounceAnimation!.value;
      _notifyValueChange();
    });
  }

  void _notifyValueChange() {
    if (_currentSelection < widget.lowerBound || _currentSelection > widget.upperBound) {
      return;
    }
    widget.onValueSelected?.call(_currentSelection);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (_) {
        _momentumController.stop();
        _bounceController.stop();
        _scrollSpeed = 0;
      },
      onPanUpdate: (details) {
        final renderBox = context.findRenderObject() as RenderBox;
        final touchPosition = renderBox.globalToLocal(details.globalPosition);
        final centerX = renderBox.size.width / 2;

        final deltaX = details.delta.dx;
        final deltaY = details.delta.dy;
        final isLeftSide = touchPosition.dx < centerX;

        final horizontalChange = -deltaX * widget.touchSensitivity;

        double verticalChange = 0.0;
        if (deltaY != 0) {
          if (isLeftSide) {
            // Left side: upward decreases, downward increases
            verticalChange = deltaY * widget.touchSensitivity;
          } else {
            // Right side: upward increases, downward decreases
            verticalChange = -deltaY * widget.touchSensitivity;
          }
        }

        final totalChange = (deltaX != 0 && deltaY != 0)
            ? (horizontalChange + verticalChange) / 2
            : horizontalChange + verticalChange;

        final newValue = _currentSelection + totalChange;

        if (newValue <= widget.lowerBound) {
          _currentSelection = (_currentSelection - widget.boundaryResistance).clamp(
            widget.lowerBound - 5.0,
            widget.upperBound,
          );
        } else if (newValue >= widget.upperBound) {
          _currentSelection = (_currentSelection + widget.boundaryResistance).clamp(
            widget.lowerBound,
            widget.upperBound + 5.0,
          );
        } else {
          _currentSelection = newValue.clamp(
            widget.lowerBound - 5.0,
            widget.upperBound + 5.0,
          );
        }

        _scrollSpeed = totalChange * 60;
        _notifyValueChange();
        setState(() {});
      },
      onPanEnd: (_) => _beginMomentumScroll(),
              child: CustomPaint(
          painter: WheelPainter(
            lowerBound: widget.lowerBound,
            upperBound: widget.upperBound,
            selectedValue: _currentSelection,
            dialRadius: widget.dialSize,
          ),
        child: ClipOval(
          child: SizedBox(
            height: (widget.dialSize + 32) * 2,
            width: (widget.dialSize + 32) * 2,
            child: Center(
              child: SizedBox(
                height: (widget.dialSize - 32) * 2,
                width: (widget.dialSize - 32) * 2,
                child: widget.centerWidget,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WheelPainter extends CustomPainter {
  final double lowerBound;
  final double upperBound;
  final double selectedValue;
  final double dialRadius;

  WheelPainter({
    required this.lowerBound,
    required this.upperBound,
    required this.selectedValue,
    required this.dialRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final center = Offset(centerX, centerY);
    final radius = dialRadius;

    // Draw the main wheel arc
    final arcPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 50;

    const startAngle = -math.pi;
    const sweepAngle = math.pi;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      arcPaint,
    );

    // Draw tick marks
    _drawTickMarks(canvas, center, radius);

    // Draw selection indicator
    _drawSelectionIndicator(canvas, center, radius);
  }

  void _drawTickMarks(Canvas canvas, Offset center, double radius) {
    final tickPaint = Paint()
      ..color = Colors.grey.shade500
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3;

    final visibleRange = 25;
    final currentValueRounded = selectedValue.round();

    if (selectedValue >= 0) {
      final startValue = math.max(lowerBound, currentValueRounded - visibleRange);
      final endValue = math.min(upperBound, currentValueRounded + visibleRange);

      for (int i = startValue.toInt(); i <= endValue; i++) {
        final valueOffset = i - selectedValue;
        final tickSpacing = 0.1;
        final angle = -math.pi / 2 + (valueOffset * tickSpacing);

        if (angle >= (-math.pi - 0.15) && angle <= 0.15) {
          final tickLength = (i % 10 == 0) ? 30 : 15;

          final innerPoint = Offset(
            center.dx + (radius - 23) * math.cos(angle),
            center.dy + (radius - 23) * math.sin(angle),
          );
          final outerPoint = Offset(
            center.dx + (radius - 23 + tickLength) * math.cos(angle),
            center.dy + (radius - 23 + tickLength) * math.sin(angle),
          );

          canvas.drawLine(innerPoint, outerPoint, tickPaint);
        }
      }
    } else {
      final startValue = lowerBound;
      final endValue = math.min(upperBound, lowerBound + visibleRange * 2);

      for (int i = startValue.toInt(); i <= endValue; i++) {
        final valueOffset = i - lowerBound + selectedValue.abs();
        final tickSpacing = 0.1;
        final angle = -math.pi / 2 + (valueOffset * tickSpacing);

        if (angle >= (-math.pi - 0.15) && angle <= 0.15) {
          final tickLength = (i % 10 == 0) ? 30 : 15;

          final innerPoint = Offset(
            center.dx + (radius - 23) * math.cos(angle),
            center.dy + (radius - 23) * math.sin(angle),
          );
          final outerPoint = Offset(
            center.dx + (radius - 23 + tickLength) * math.cos(angle),
            center.dy + (radius - 23 + tickLength) * math.sin(angle),
          );

          canvas.drawLine(innerPoint, outerPoint, tickPaint);
        }
      }
    }
  }

  void _drawSelectionIndicator(Canvas canvas, Offset center, double radius) {
    final indicatorPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final thumbPaint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round;

    final indicatorStart = Offset(center.dx, center.dy - radius - 23);
    final indicatorEnd = Offset(center.dx, center.dy - radius + 20);
    final thumbPosition = Offset(center.dx, center.dy - radius + 25);

    canvas.drawCircle(thumbPosition, 5, thumbPaint);
    canvas.drawLine(indicatorStart, indicatorEnd, indicatorPaint);
  }

  @override
  bool shouldRepaint(covariant WheelPainter oldDelegate) {
    return oldDelegate.selectedValue != selectedValue;
  }
}
