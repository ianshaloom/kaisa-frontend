import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/constants/constants.dart';
import '../../../../../core/datasources/hive/hive-crud/hive_user_crud.dart';
import '../../../../../core/datasources/kaisa-backend/crud/kaisa_backend_ds.dart';
import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/errors/cloud_storage_exceptions.dart';
import '../../../../../core/utils/utility_methods.dart';
import '../../../domain/entity/stock_item_entity.dart';
import '../../core/constants.dart';

class FirestoreStockDs {
  static final shop =
      FirebaseFirestore.instance.collection(kaisaShopsCollection);
  final HiveUserDataCrud hiveUser = HiveUserDataCrud();
  final KaisaBackendDS kbDS = KaisaBackendDS();

  // get all stock items
  Future<List<StockItemEntity>> fetchStock() async {
    try {
      final user = await hiveUser.getUser();
      final id = genShopId(user.address);

      // doc reference
      final docRef = shop.doc(id).collection(stockSubCollection);
      final snapshot = await docRef.get();
      List<StockItemEntity> toList = snapshot.docs
          .map(
              (doc) => StockItemEntity.fromQuerySnapshot(documentSnapshot: doc))
          .toList();
      return toList;
    } on FirebaseException catch (e) {
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
