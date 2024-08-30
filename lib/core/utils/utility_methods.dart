import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kaisa/core/constants/constants.dart';
import 'package:kaisa/core/constants/network_const.dart';

String elapsedTime(DateTime pdate, String time) {
  // here is the time format from the server 07:38:58
  //  here is the date format from the server 2024-03-07 00:00:00.000

  // first lets make a date time object from pdate and time
  final date = DateFormat('yyyy-MM-dd').format(pdate);
  final finalDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(
    DateTime.parse('$date $time'),
  );

  // elapsed time
  final now = DateTime.now();
  final difference = now.difference(DateTime.parse(finalDate));

  if (difference.inDays > 0) {
    return _customDate(pdate);
  } else if (difference.inHours > 0) {
    return '${difference.inHours}h ago';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes}m ago';
  } else {
    return 'Just now';
  }
}

// custom time format from DateTime object - e.g. 12:00:00
String customTime(DateTime date) {
  return DateFormat.Hms().format(date);
}

String _customDate(DateTime date) {
  String day = DateFormat.d().format(date);
  String month = DateFormat.MMM().format(date);
  return '$day $month';
}

String newDate(DateTime date) {
  String day = DateFormat.d().format(date);
  String month = DateFormat.MMM().format(date);
  String year = DateFormat.y().format(date);
  return '$day $month $year';
}

Color getTitileColor(String title) {
  switch (title) {
    case 'Pending':
      return Colors.blue;
    case 'Received':
      return Colors.green;
    case 'Cancelled':
      return Colors.black;
    default:
      return Colors.black;
  }
}

bool fromHome(String page) {
  return page == 'home';
}

bool fromDynamicList(String page) {
  return page == 'dynamicList';
}

bool fromPurchaseList(String page) {
  return page == 'purchase-list';
}



String extractNameFromEmail(String email) {
  // Split the email address at the '@' symbol
  List<String> parts = email.split('@');

  // Check if there are exactly two parts (name and domain)
  if (parts.length == 2) {
    // Return the first part (name)
    return parts[0];
  } else {
    // Return empty string if the email format is invalid
    return email;
  }
}

// return a string of date in this format 2024-05-27
String formatDate(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}

// return a string of greeting message depending on the time of the day
String greetingMessage() {
  final hour = DateTime.now().hour;
  if (hour < 12) {
    return 'Good Morning $waveIcon';
  } else if (hour < 17) {
    return 'Good Afternoon $waveIcon';
  } else {
    return 'Good Evening $waveIcon';
  }
}

// return a string of url for the image
String imageUrl(String imageUrl) {
  return '$kBaseUrlShop$imageUrl';
}