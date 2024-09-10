import 'package:dio/dio.dart';

import '../../../constants/network_const.dart';
import '../../../errors/app_exception.dart';
import '../models/kaisa-order/kaisa_order.dart';

class KBOrders {
  Future<void> postOrder(KOrder korder) async {
    final data = korder.toJson();

    try {
      final Response response = await dio.post(korders, data: data);

      if (response.statusCode != 200) {
        throw FetchDataException(response.data['message']);
      }
    } on DioException catch (e) {
      throw PostDataException(e.message);
    }
  }
}
