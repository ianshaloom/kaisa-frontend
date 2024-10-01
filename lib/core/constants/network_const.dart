import 'package:dio/dio.dart';

const String kBaseUrlImages =
    'https://ianshaloom.fugitechnologies.com/assets/img/kaisa/';
const String kBaseUrlBackend =
    'https://kaisa-backend-vslzx7k-moolsha-nai.globeapp.dev';
// const String kBaseUrlBackend = 'http://192.168.0.101:8080';
// http://192.168.0.114:8080

// end points
const String activCode = '/kcode';
const String order = '/korder';
const String orderTrans = '/korderTrans';
const String receipt = '/kreceipt';
const String stock = '/kstock';

// shop1 dio
final dio = Dio(options);

final options = BaseOptions(
  baseUrl: kBaseUrlBackend,
  connectTimeout: const Duration(seconds: 60),
  receiveTimeout: const Duration(seconds: 60),
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
