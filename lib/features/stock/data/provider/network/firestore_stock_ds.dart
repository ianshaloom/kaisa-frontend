import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/constants/constants.dart';
import '../../../../../core/datasources/hive/hive-crud/hive_user_crud.dart';
import '../../../../../core/errors/cloud_storage_exceptions.dart';
import '../../../domain/entity/stock_item_entity.dart';

class FirestoreStockDs {
  static final shop =
      FirebaseFirestore.instance.collection(kaisaShopsCollection);
  final HiveUserDataCrud hiveUser = HiveUserDataCrud();

  // get all stock items
  Future<List<StockItemEntity>> fetchStock() async {
    try {
      final user = await hiveUser.getUser();
      final id = user.address;

      final snapshot = await shop.doc(id).collection(id).get();
      return snapshot.docs
          .map(
              (doc) => StockItemEntity.fromQuerySnapshot(documentSnapshot: doc))
          .toList();
    } catch (e) {
      throw CouldNotFetchException();
    }
  }
}
