import 'package:flutter/material.dart';

class DailySales {
  const DailySales({
    required this.totalSales,
    required this.dayOfTheWeek,
  });

  /// The primary amount or value of this entity.
  final int totalSales;

  /// The full displayable account number.
  final String dayOfTheWeek;
}

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

/* {
        'Shop Name': shopName,
        'Total Sales': shopReceipts.length,
        'Watu Sales': 0,
        'M-Kopa Sales': 0,
        'Onfon Sales': 0,
        'Other Sales': 0,
        'Sales': [],
      }; */

// shop analysis model from above map
class ShopAnalysis {
  ShopAnalysis({
    required this.shopName,
    this.totalSales = 0,
    this.watuSales = 0,
    this.mKopaSales = 0,
    this.onfonSales = 0,
    this.otherSales = 0,
    required this.sales,
  });

  final String shopName;
  final int totalSales;
  int watuSales;
  int mKopaSales;
  int onfonSales;
  int otherSales;
  final List<Map<String, dynamic>> sales;

  // string getters
  String get totalSalesString => totalSales.toString();
  String get watuSalesString => watuSales.toString();
  String get mKopaSalesString => mKopaSales.toString();
  String get onfonSalesString => onfonSales.toString();
  String get otherSalesString => otherSales.toString();

  // from map
  factory ShopAnalysis.fromMap(Map<String, dynamic> map) {
    return ShopAnalysis(
      shopName: map['Shop Name'],
      totalSales: map['Total Sales'],
      watuSales: map['Watu Sales'],
      mKopaSales: map['M-Kopa Sales'],
      onfonSales: map['Onfon Sales'],
      otherSales: map['Other Sales'],
      sales: map['Sales'],
    );
  }
}
