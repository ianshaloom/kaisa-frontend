import 'package:flutter/material.dart';

class ChartColors {
  static const List<Color> salesColors = <Color>[
    Color.fromARGB(220, 51, 152, 0),
    Color.fromARGB(220, 0, 121, 191),
    Color.fromARGB(220, 255, 109, 0),
    Color.fromARGB(220, 255, 204, 0),
    Color.fromARGB(220, 170, 0, 255),
    Color.fromARGB(220, 244, 67, 54),
    Color.fromARGB(220, 0, 150, 136),
  ];

  /// Convenience method to get a single bill color with position i.
  static Color salesColor(int i) {
    return cycledColor(salesColors, i);
  }

  /// Gets a color from a list that is considered to be infinitely repeating.
  static Color cycledColor(List<Color> colors, int i) {
    return colors[i % colors.length];
  }
}
