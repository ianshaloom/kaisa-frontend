import 'package:dio/dio.dart';

const String kBaseUrlImages =
    'https://ianshaloom.fugitechnologies.com/assets/img/kaisa/';
const String kBaseUrlUsers =
    'https://kaisa-backend-yhgjlvo-moolsha-nai.globeapp.dev';

// end points
const String kUsers = '/users';
const String korders = '/orders';

// shop1 dio
final dio = Dio(options);

final options = BaseOptions(
  baseUrl: kBaseUrlUsers,
  connectTimeout: const Duration(seconds: 30),
  receiveTimeout: const Duration(seconds: 30),
  contentType: 'application/json',
);

const String kBaseUrlProfileImgs =
    'https://ianshaloom.github.io';

List<String> profilePictures = [
  '$kBaseUrlProfileImgs/assets/img/avatar-1-female.png',
  '$kBaseUrlProfileImgs/assets/img/avatar-2-female.png',
  '$kBaseUrlProfileImgs/assets/img/avatar-male-1.png',
  '$kBaseUrlProfileImgs/assets/img/avatar-male-2.png',
  '$kBaseUrlProfileImgs/assets/img/avatar-male-3.png',
];
