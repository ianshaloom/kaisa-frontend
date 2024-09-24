import 'package:dio/dio.dart';

const String kBaseUrlImages =
    'https://ianshaloom.fugitechnologies.com/assets/img/kaisa/';
// const String kBaseUrlBackend = 'https://kaisa-backend-mey1hq9-moolsha-nai.globeapp.dev';
const String kBaseUrlBackend =
    'http://192.168.0.114:8080';
// http://192.168.0.114:8080


// end points
const String activCode = '/kcode';
const String order = '/korder';
const String orderTrans = '/korderTrans';
const String receipt = '/kreceipt';

// shop1 dio
final dio = Dio(options);

final options = BaseOptions(
  baseUrl: kBaseUrlBackend,
  connectTimeout: const Duration(seconds: 30),
  receiveTimeout: const Duration(seconds: 30),
  contentType: 'application/json',
);

const String kBaseUrlProfileImgs = 'https://ianshaloom.github.io';

List<String> profilePictures = [
  '$kBaseUrlProfileImgs/assets/img/avatar-1-female.png',
  '$kBaseUrlProfileImgs/assets/img/avatar-2-female.png',
  '$kBaseUrlProfileImgs/assets/img/avatar-male-1.png',
  '$kBaseUrlProfileImgs/assets/img/avatar-male-2.png',
  '$kBaseUrlProfileImgs/assets/img/avatar-male-3.png',
];
