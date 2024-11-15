import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../shared/shared_ctrl.dart';

const String kBaseUrlImages =
    'https://ianshaloom.fugitechnologies.com/assets/img/kaisa/';

// end points
const String activCode = '/kcode';
const String order = '/korder';
const String orderTrans = '/korderTrans';
const String receipt = '/kreceipt';

// shop1 dio
final dio = Dio(options);

final options = BaseOptions(
  baseUrl: NetworkConst.kBaseUrlBackend,
  connectTimeout: const Duration(seconds: 30),
  receiveTimeout: const Duration(seconds: 30),
  contentType: 'application/json',
);

const String kBaseUrlProfileImgs =
    'https://firebasestorage.googleapis.com/v0/b/kaisa-341a6.appspot.com/o/avatar.png?alt=media&token=a7852af7-fb22-42e7-84f8-6978a627e487';

class NetworkConst {
  static String get kBaseUrlBackend => url();

  static String url() {
    final svr = Get.find<SharedCtrl>().userData.srv;

    if (svr.isEmpty) {
      // ignore: avoid_print
      print(' 🚩 No server 🚩');

      return 'https://kaisa-backend-vslzx7k-moolsha-nai.globeapp.dev';
    } else {
      // ignore: avoid_print
      print(' 🏁 Yes server 🏁');

      return 'https://kaisa-backend-$svr-moolsha-nai.globeapp.dev';
      // return 'http://192.168.0.102:8080';
    }
  }

  // const String kBaseUrlBackend = 'http://192.168.0.114:8080';
//http://192.168.0.102:8080/
}
