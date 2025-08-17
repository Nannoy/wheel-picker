import 'package:flutter/material.dart';
import '../wheel_picker.dart';
import '../widgets/animated_number_text.dart';

class WheelPickerDemo extends StatefulWidget {
  const WheelPickerDemo({super.key});

  @override
  State<WheelPickerDemo> createState() => _WheelPickerDemoState();
}

class _WheelPickerDemoState extends State<WheelPickerDemo> {
  double _dialPadding = 10;
  double _selectedValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Text(
              'Wheel Picker',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),
            const Text(
              "WHEEL SIZE",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade200,
              ),
              child: Slider(
                value: _dialPadding,
                thumbColor: Colors.blue,
                activeColor: Colors.blue,
                inactiveColor: Colors.grey,
                max: 40,
                onChanged: (value) {
                  setState(() {
                    _dialPadding = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 100),
            Center(
              child: SizedBox(
                child: WheelPicker(
                  dialSize: 180 - _dialPadding,
                  upperBound: 150,
                  onValueSelected: (value) {
                    setState(() {
                      _selectedValue = value;
                    });
                  },
                  centerWidget: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            SmoothNumberDisplay(displayValue: _selectedValue.toInt()),
                            const Text(
                              "KG",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: const Center(
                          child: Text(
                            "WHEEL PICKER\n BY NANNOY",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
