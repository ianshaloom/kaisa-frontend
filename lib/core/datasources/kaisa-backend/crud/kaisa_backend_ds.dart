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
      final statusCode = e.response?.statusCode;

      // print('💡 ------------ ${statusCode.toString()}');

      if (statusCode == 400) {
        final message = e.response?.data['error'] as String;

        throw FetchDataException(message);
      }

      throw FetchDataException(e.message);
    }
  }

  // Post Phone Transaction
  Future<void> receiveKOrderTransc(Map<String, dynamic> data) async {
    try {
      Response response = await dio.post(order, data: data);

      if (response.statusCode != 200) {
        throw PostDataException(response.data['message']);
      }
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;

      // print('💡 ------------ ${statusCode.toString()}');

      if (statusCode == 400) {
        final message = e.response?.data['error'] as String;

        throw PostDataException(message);
      }

      throw PostDataException(e.message);
    }
  }

  // Post Receipt
  Future<void> postReceipt(Map<String, dynamic> data) async {
    try {
      Response response = await dio.post(receipt, data: data);

      if (response.statusCode != 200) {
        throw PostDataException(response.data['message']);
      }
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;

      // print('💡 ------------ ${statusCode.toString()}');

      if (statusCode == 400) {
        final message = e.response?.data['error'] as String;

        throw PostDataException(message);
      }

      throw PostDataException(e.message);
    }
  }

  // sEND oRDER
  Future<void> sendOrder(Map<String, dynamic> data) async {
    try {
      Response response = await dio.post(orderTrans, data: data);

      if (response.statusCode != 200) {
        throw PostDataException(response.data['message']);
      }
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;

      // print('💡 ------------ ${statusCode.toString()}');

      if (statusCode == 400) {
        final message = e.response?.data['error'] as String;

        throw PostDataException(message);
      }

      throw PostDataException(e.message);
    }
  }

// cANCEL oRDER
  Future<void> cancelOrder(Map<String, dynamic> data) async {
    try {
      Response response = await dio.patch(orderTrans, data: data);

      if (response.statusCode != 200) {
        throw PatchDataException(response.data['message']);
      }
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;

      // print('💡 ------------ ${statusCode.toString()}');

      if (statusCode == 400) {
        final message = e.response?.data['error'] as String;

        throw PatchDataException(message);
      }
      throw PatchDataException(e.message);
    }
  }

  // fETCH wEEKLY sALES
  Future<List<Map<String, dynamic>>> fetchWeeklySales() async {
    try {
      List<Map<String, dynamic>> sales;

      final startDate = getFirstDayOfTheWeek();

      final response = await dio.get(
        receipt,
        queryParameters: {
          'date': startDate,
        },
      );

      if (response.statusCode != 200) {
        throw FetchDataException(response.data['message']);
      }

      var salesList = response.data as List;

      sales = salesList.map((e) => e as Map<String, dynamic>).toList();

      return sales;
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;

      // print('💡 ------------ ${statusCode.toString()}');

      if (statusCode == 400) {
        final message = e.response?.data['error'] as String;

        throw FetchDataException(message);
      }

      throw FetchDataException(e.message);
    }
  }
}

String getFirstDayOfTheWeek() {
  final now = DateTime.now();
  final firstDayOfTheWeek = now.subtract(Duration(days: now.weekday - 1));
  return firstDayOfTheWeek.toString().substring(0, 10);
}
