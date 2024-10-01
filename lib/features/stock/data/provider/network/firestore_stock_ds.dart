import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/constants/constants.dart';
import '../../../../../core/datasources/hive/hive-crud/hive_user_crud.dart';
import '../../../../../core/datasources/kaisa-backend/crud/kaisa_backend_ds.dart';
import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/errors/cloud_storage_exceptions.dart';

class FirestoreStockDs {
  static final shop =
      FirebaseFirestore.instance.collection(kaisaShopsCollection);
  final HiveUserDataCrud hiveUser = HiveUserDataCrud();
  final KaisaBackendDS kbDS = KaisaBackendDS();

  // get all stock items
  Future<List<Map<String, dynamic>>> fetchStock() async {
    try {
      final stockItems = await kbDS.fetchUnSoldStock();

      return stockItems;
    } on FetchDataException catch (e) {
      throw CouldNotFetchException(eMessage: e.message ?? 'Could not fetch');
    }
  }

  // send order
  Future<void> sendOrder(Map<String, dynamic> data) async {
    try {
      await kbDS.sendOrder(data);
    } on PostDataException catch (e) {
      throw CouldNotCreateException(eMessage: e.message);
    } catch (e) {
      throw GenericException(e.toString());
    }
  }
}
