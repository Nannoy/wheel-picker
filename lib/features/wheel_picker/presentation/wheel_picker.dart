import 'dart:math';
import 'package:flutter/material.dart';

class WheelPicker extends StatefulWidget {
  final int minValue;
  final int maxValue;
  final int initialValue;
  final String unit;
  final ValueChanged<int>? onChanged;

  const WheelPicker({
    Key? key,
    this.minValue = 0,
    this.maxValue = 100,
    this.initialValue = 0,
    this.unit = 'KG',
    this.onChanged,
  }) : super(key: key);

  @override
  State<WheelPicker> createState() => _WheelPickerState();
}

class _WheelPickerState extends State<WheelPicker> {
  late int value;
  double dragAccumulator = 0;

  @override
  void initState() {
    super.initState();
    value = widget.initialValue;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    // Accumulate drag and change value when threshold is crossed
    dragAccumulator += details.delta.dx;
    const dragThreshold = 8.0; // pixels per value change
    if (dragAccumulator.abs() >= dragThreshold) {
      int delta = dragAccumulator ~/ dragThreshold;
      dragAccumulator -= delta * dragThreshold;
      setState(() {
        // Reverse direction: left swipe (anti-clockwise) increases, right swipe (clockwise) decreases
        value = (value - delta).clamp(widget.minValue, widget.maxValue);
        widget.onChanged?.call(value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 300,
          height: 180,
          child: GestureDetector(
            onPanUpdate: _onPanUpdate,
            child: CustomPaint(
              painter: _WheelPickerPainter(
                value: value,
                minValue: widget.minValue,
                maxValue: widget.maxValue,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value.toString(),
          style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Text(
          widget.unit,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 24),
        const Text(
          'WHEEL PICKER BY\nNannoy',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ],
    );
  }
}

class _WheelPickerPainter extends CustomPainter {
  final int value;
  final int minValue;
  final int maxValue;

  _WheelPickerPainter({
    required this.value,
    required this.minValue,
    required this.maxValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2 - 20;
    final arcRect = Rect.fromCircle(center: center, radius: radius);
    final startAngle = pi;
    final sweepAngle = pi;

    // Draw semi-circle background (subtle gray) - make it thicker to cover all tick marks
    final bgPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 50; // Increased from 32 to 48 to cover all tick marks
    canvas.drawArc(arcRect, startAngle, sweepAngle, false, bgPaint);

    // Draw fixed pointer (black needle) positioned inside the arc thickness
    final pointerAngle = -pi / 2;
    final pointerPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;
    final pointerEnd = Offset(
      center.dx + radius * cos(pointerAngle),
      center.dy + radius * sin(pointerAngle),
    );
    final pointerStart = Offset(
      center.dx + (radius - 49) * cos(pointerAngle),
      center.dy + (radius - 49) * sin(pointerAngle),
    );
    canvas.drawLine(pointerEnd, pointerStart, pointerPaint);
    canvas.drawCircle(pointerStart, 8, Paint()..color = Colors.black);

    // Draw ticks directly on the arc curve
    final visibleTicks = 31; // more ticks for smoothness
    final halfVisible = visibleTicks ~/ 2;
    final tickSpacing = 1; // 1 unit per tick
    final arcStrokeWidth = 50.0; // Match the arc stroke width
    for (int i = -halfVisible; i <= halfVisible; i++) {
      int tickValue = value + i * tickSpacing;
      if (tickValue < minValue || tickValue > maxValue) continue;
      double angle = -pi / 2 + (i * pi / (visibleTicks - 1));
      bool isMajor = tickValue % 10 == 0;
      double tickLength = isMajor ? arcStrokeWidth * 0.85 : arcStrokeWidth * 0.5;
      Paint tickPaint = Paint()
        ..color = isMajor ? Colors.grey.shade700 : Colors.grey.shade500
        ..strokeWidth = isMajor ? 3.5 : 1.5;
      // Start from the outer edge of the arc, extend inward
      Offset start = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      Offset end = Offset(
        center.dx + (radius - tickLength) * cos(angle),
        center.dy + (radius - tickLength) * sin(angle),
      );
      canvas.drawLine(start, end, tickPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
