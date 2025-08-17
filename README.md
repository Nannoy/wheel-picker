# Wheel Picker

A sophisticated Flutter wheel picker with smooth scrolling, momentum effects, and elastic boundaries.

## Features

- **Momentum Scrolling**: Natural momentum-based scrolling that continues after user interaction
- **Elastic Boundaries**: Smooth bounce-back animations when reaching limits
- **Customizable Sensitivity**: Adjustable touch sensitivity for different use cases
- **Smooth Number Transitions**: Animated number display with fade and slide effects
- **Responsive Design**: Works seamlessly across different screen sizes
- **Customizable Appearance**: Configurable dial size, colors, and styling

## Usage

### Basic Implementation

```dart
import 'package:flutter/material.dart';
import 'features/wheel_picker/presentation/wheel_picker.dart';

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  double _selectedValue = 0;

  @override
  Widget build(BuildContext context) {
    return WheelPicker(
      lowerBound: 0,
      upperBound: 100,
      onValueSelected: (value) {
        setState(() {
          _selectedValue = value;
        });
      },
      centerWidget: Text(
        _selectedValue.toInt().toString(),
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
```

### Advanced Configuration

```dart
WheelPicker(
  dialSize: 150,
  lowerBound: 0,
  upperBound: 200,
  touchSensitivity: 0.12,        // How responsive to touch
  boundaryResistance: 0.035,     // Elastic boundary factor
  momentumDecay: 0.94,           // How quickly momentum slows
  momentumThreshold: 4.5,        // Minimum speed for momentum
  onValueSelected: (value) {
    // Handle value changes
  },
  centerWidget: YourCustomWidget(),
)
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `lowerBound` | `double` | `0` | Minimum selectable value |
| `upperBound` | `double` | `100` | Maximum selectable value |
| `touchSensitivity` | `double` | `0.12` | Touch responsiveness (higher = more sensitive) |
| `boundaryResistance` | `double` | `0.035` | Elastic boundary resistance |
| `momentumDecay` | `double` | `0.94` | Momentum slowdown factor |
| `momentumThreshold` | `double` | `4.5` | Minimum speed for momentum |
| `dialSize` | `double` | `200.0` | Size of the wheel in pixels |
| `centerWidget` | `Widget?` | `null` | Widget displayed in center |
| `onValueSelected` | `Function(double)?` | `null` | Value change callback |

## Examples

### Weight Selection
```dart
WheelPicker(
  dialSize: 120,
  lowerBound: 0,
  upperBound: 200,
  onValueSelected: (value) => setState(() => _weight = value),
  centerWidget: Column(
    children: [
      SmoothNumberDisplay(displayValue: _weight.toInt()),
      Text("KG", style: TextStyle(fontSize: 14)),
    ],
  ),
)
```

### Age Selection
```dart
WheelPicker(
  dialSize: 100,
  lowerBound: 0,
  upperBound: 120,
  touchSensitivity: 0.15,
  onValueSelected: (value) => setState(() => _age = value),
  centerWidget: Column(
    children: [
      SmoothNumberDisplay(displayValue: _age.toInt()),
      Text("Years", style: TextStyle(fontSize: 12)),
    ],
  ),
)
```

## Smooth Number Display

The `SmoothNumberDisplay` widget provides elegant transitions between values:

```dart
SmoothNumberDisplay(
  displayValue: currentValue.toInt(),
  textStyle: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
  transitionDuration: Duration(milliseconds: 350),
)
```

## Getting Started

1. Clone this repository
2. Run `flutter pub get`
3. Run `flutter run` to see the demo

## Demo Screens

- **WheelPickerDemo**: Main demo with adjustable wheel size
- **WheelPickerExamples**: Multiple wheel pickers with different configurations

## Customization

You can customize the appearance by modifying the `WheelPainter` class or creating your own custom painter that extends `CustomPainter`.

## License

This project is licensed under the MIT License.
