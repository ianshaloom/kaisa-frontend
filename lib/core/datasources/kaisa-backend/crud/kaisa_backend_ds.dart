import 'package:dio/dio.dart';

import '../../../constants/network_const.dart';
import '../../../errors/app_exception.dart';

class KaisaBackendDS {
  // fetch kaisa user activ code
  Future<bool> fetchKActivCode(int code) async {
    try {
      Response response = await dio.get(activCode,
          options: Options(headers: {
            "code": code,
          }));

      if (response.statusCode != 200) {
        throw FetchDataException(response.data['message']);
      }

      // if map is empty, user is not qualified
      if (response.data == 0) {
        return false;
      }

      return true;
    } on DioException catch (e) {
      throw FetchDataException(e.message);
    }
  }

  // Post Phone Transaction
  Future<void> receiveKOrderTransc(Map<String, dynamic> data) async {
    try {
      Response response = await dio.post(order, data: data);

      if (response.statusCode != 200) {
        throw FetchDataException(response.data['message']);
      }
    } on DioException catch (e) {
      throw PostDataException(e.message);
    }
  }

  // Post Receipt
  Future<void> postReceipt(Map<String, dynamic> data) async {
    try {
      Response response = await dio.post(receipt, data: data);

      if (response.statusCode != 200) {
        throw FetchDataException(response.data['message']);
      }
    } on DioException catch (e) {
      throw PostDataException(e.message);
    }
  }

  // sEND oRDER
  Future<void> sendOrder(Map<String, dynamic> data) async {
    try {
      Response response = await dio.post(orderTrans, data: data);

      if (response.statusCode != 200) {
        throw FetchDataException(response.data['message']);
      }
    } on DioException catch (e) {
      throw PostDataException(e.message);
    }
  }

// cANCEL oRDER
  Future<void> cancelOrder(Map<String, dynamic> data) async {
    try {
      Response response = await dio.patch(orderTrans, data: data);

      if (response.statusCode != 200) {
        throw FetchDataException(response.data['message']);
      }
    } on DioException catch (e) {
      throw PatchDataException(e.message);
    }
  }
}
