import 'package:intl/intl.dart';
import 'package:kaisa/core/constants/constants.dart';
import 'package:kaisa/core/constants/network_const.dart';

String elapsedTime(DateTime pdate) {
  final now = DateTime.now();
  final difference = now.difference(pdate);

  if (difference.inDays > 0) {
    return '${difference.inDays}d ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours}h ago';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes}m ago';
  } else {
    return '${difference.inSeconds}s ago';
  }
}

//

// custom time format from DateTime object - e.g. 12:00:00
String customTime(DateTime date) {
  return DateFormat.Hms().format(date);
}

String customDate(DateTime date) {
  String day = DateFormat.d().format(date);
  String month = DateFormat.MMM().format(date);
  return '$day $month';
}

String customDateFromString(String date) {
  final DateTime dateTime = DateTime.parse(date);
  String day = DateFormat.d().format(dateTime);
  String month = DateFormat.MMM().format(dateTime);
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

String todayDateFormatted() {
  return DateFormat('yyyy-MM-dd').format(DateTime.now());
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

String genShopId(String id) {
  final splits = id.split(' ');
  var formatted = '';
  for (var split in splits) {
    formatted += split[0].toUpperCase() + split.substring(1);
  }

  return formatted;
}



String getShopName(String shopId) {
  // shopId has no spaces, so split it by uppercase letters
  final shopName = shopId.splitMapJoin(
    RegExp(r'(?=[A-Z])'),
    onMatch: (m) => ' ',
    onNonMatch: (m) => m,
  );

  return shopName;
}
