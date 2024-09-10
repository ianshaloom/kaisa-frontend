import 'package:dio/dio.dart';

import '../../../constants/network_const.dart';
import '../../../errors/app_exception.dart';

class KBUsers {
  Future<bool> checkQualification(int code) async {
    try {
      Response response = await dio.get(
        kUsers,
        options: Options(
          headers: {
            'code': code,
          },
        ),
      );

      if (response.statusCode != 200) {
        throw FetchDataException(response.data['message']);
      }

      // if map is empty, user is not qualified
      if (response.data.isEmpty) {
        return false;
      }

      return true;
    } on DioException catch (e) {
      throw FetchDataException(e.message);
    }
  }
}
