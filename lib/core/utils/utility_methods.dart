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
    return customDate(pdate);
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

String customDate(DateTime date) {
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
String generateImageUrl(String imageUrl) {
  return '$kBaseUrlImages$imageUrl';
}

// return a string of smart phone name, ram and storage
String phoneName(String name, String ram, String storage) {
  return '$name ($ram - $storage)';
}
