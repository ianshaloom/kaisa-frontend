import 'package:flutter/material.dart';

import '../core/datasources/firestore/models/kaisa-user/kaisa_user.dart';
import '../core/utils/utility_methods.dart';
import '../features/feature-receipts/f_receipt.dart';

class DailySales {
  const DailySales({
    required this.sales,
    required this.dayOfTheWeek,
  });

  /// The primary amount or value of this entity.

  /// The full displayable day of the week.
  final DateTime dayOfTheWeek;

  // sales
  final  List<ReceiptEntity> sales;

  // getters
  int get salesCount => sales.length;
  String get fullDayOfTheWeek {
    switch (dayOfTheWeek.weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:

        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return 'Unknown';
    }
  }

  

  Color get color {
    switch (dayOfTheWeek.weekday) {
      case 1:
        return ChartColors.salesColor(0);
      case 2:
        return ChartColors.salesColor(1);
      case 3:
        return ChartColors.salesColor(2);
      case 4:
        return ChartColors.salesColor(3);
      case 5:
        return ChartColors.salesColor(4);
      case 6:
        return ChartColors.salesColor(5);
      case 7:
        return ChartColors.salesColor(6);
      default:
        return Colors.black;
    }
  }
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
  final List<ReceiptEntity> sales;


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

class KaisaShopA {
  final String shopName;
  final List<KaisaUser> attendants;

  KaisaShopA({
    required this.shopName,
    required this.attendants,
  });

  // getters
  String get shopId => genShopId(shopName);
  List<String> get attendantIds => attendants.map((e) => e.uuid).toList();
  static KaisaShopA get empty => KaisaShopA(shopName: '', attendants: []);
}

class MdPieChart {
  final double value;
  final String name;

  MdPieChart({required this.value, required this.name});

  // double get percentage =>
}

// this is used to pass data about chart values to the widget
class DonutData {
  DonutData(this.color, this.percent);

  final Color color;
  double percent;
}
