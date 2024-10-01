import 'package:dio/dio.dart';

import '../../../constants/network_const.dart';
import '../../../errors/app_exception.dart';
import '../../hive/hive-crud/data_cache_crud.dart';
import '../../hive/hive-models/datacache/data_cache_model.dart';

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

  // fETCH wEEKLY sALES
  Future<List<Map<String, dynamic>>> fetchWeeklySales(String startDate) async {
    try {
      List<Map<String, dynamic>> sales;

      // check if data is cached
      final cachedData = await DataCacheCRUD.getCachedData('weeklySales');

      if (cachedData.id.isNotEmpty &&
          DateTime.now().isBefore(cachedData.expiryDate)) {
        //
        sales = cachedData.value;
      } else {
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

        // cache data
        await DataCacheCRUD.cacheData(
          DataCacheModel(
            id: 'weeklySales',
            value: sales,
            expiryDate: DateTime.now().add(const Duration(minutes: 5)),
          ),
        );
      }

      return sales;
    } on DioException catch (e) {
      throw FetchDataException(e.message);
    }
  }

  // fETCH aLL sTOCK iTEMS
  Future<List<Map<String, dynamic>>> fetchUnSoldStock() async {
    try {
      List<Map<String, dynamic>> stockItems;

      // check if data is cached
      final cachedData = await DataCacheCRUD.getCachedData('stockItems');

      if (cachedData.id.isNotEmpty &&
          DateTime.now().isBefore(cachedData.expiryDate)) {
        //
        stockItems = cachedData.value;
      } else {
        final response = await dio.get(
          stock,
          queryParameters: {
            'not-sold': true,
          },
        );

        if (response.statusCode != 200) {
          throw FetchDataException(response.data['message']);
        }

        var stockList = response.data as List;

        stockItems = stockList.map((e) => e as Map<String, dynamic>).toList();

        // cache data
        await DataCacheCRUD.cacheData(
          DataCacheModel(
            id: 'stockItems',
            value: stockItems,
            expiryDate: DateTime.now().add(const Duration(minutes: 30)),
          ),
        );
      }

      return stockItems;
    } on DioException catch (e) {
      throw FetchDataException(e.message);
    }
  }
}
