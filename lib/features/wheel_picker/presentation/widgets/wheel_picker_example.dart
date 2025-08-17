import 'package:flutter/material.dart';
import '../wheel_picker.dart';
import 'animated_number_text.dart';

class WheelPickerExamples extends StatefulWidget {
  const WheelPickerExamples({super.key});

  @override
  State<WheelPickerExamples> createState() => _WheelPickerExamplesState();
}

class _WheelPickerExamplesState extends State<WheelPickerExamples> {
  double _weightSelection = 50;
  double _ageSelection = 25;
  double _heightSelection = 170;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wheel Picker Examples'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weight Selection',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Center(
                              child: WheelPicker(
                  dialSize: 120,
                  lowerBound: 0,
                  upperBound: 200,
                  onValueSelected: (value) {
                  setState(() {
                    _weightSelection = value;
                  });
                },
                centerWidget: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SmoothNumberDisplay(
                      displayValue: _weightSelection.toInt(),
                      textStyle: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const Text(
                      "KG",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Age Selection',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Center(
                              child: WheelPicker(
                  dialSize: 100,
                  lowerBound: 0,
                  upperBound: 120,
                  touchSensitivity: 0.15,
                  onValueSelected: (value) {
                  setState(() {
                    _ageSelection = value;
                  });
                },
                centerWidget: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SmoothNumberDisplay(
                      displayValue: _ageSelection.toInt(),
                      textStyle: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const Text(
                      "Years",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Height Selection',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Center(
                              child: WheelPicker(
                  dialSize: 140,
                  lowerBound: 100,
                  upperBound: 250,
                  touchSensitivity: 0.08,
                  onValueSelected: (value) {
                  setState(() {
                    _heightSelection = value;
                  });
                },
                centerWidget: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SmoothNumberDisplay(
                      displayValue: _heightSelection.toInt(),
                      textStyle: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const Text(
                      "CM",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Selections:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('Weight: ${_weightSelection.toInt()} KG'),
                  Text('Age: ${_ageSelection.toInt()} Years'),
                  Text('Height: ${_heightSelection.toInt()} CM'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
