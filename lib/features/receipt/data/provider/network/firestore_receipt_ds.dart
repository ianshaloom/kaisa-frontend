import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/constants/constants.dart';
import '../../../../../core/datasources/hive/hive-crud/hive_user_crud.dart';
import '../../../../../core/errors/cloud_storage_exceptions.dart';
import '../../../../../core/utils/utility_methods.dart';
import '../../../domain/entity/receipt_entity.dart';
import '../../core/constants.dart';

class FirestoreReceiptDs {
  static final shop =
      FirebaseFirestore.instance.collection(kaisaShopsCollection);
  final HiveUserDataCrud hiveUser = HiveUserDataCrud();

  // get all receipts
  Future<List<ReceiptEntity>> fetchReceipts() async {
    try {
      final user = await hiveUser.getUser();
      final id = genShopId(user.address);

      // reference to the shop
      final docRef = shop.doc(id).collection(receiptsSubCollection);

      final fetchedReceipts = await docRef.get();

      return fetchedReceipts.docs
          .map((doc) => ReceiptEntity.fromQuerySnapshot(documentSnapshot: doc))
          .toList();
    } on FirebaseException catch (e) {
      throw CouldNotFetchException(eMessage: e.message ?? 'Unable to fetch receipts');
    }
  }

  // Fetch a single receipt
  Future<ReceiptEntity> fetchReceipt(String imei, String shopId) async {
    try {
      // reference to the shop
      final docRef = shop.doc(shopId).collection(receiptsSubCollection);

      final fetchedReceipt = await docRef.doc(imei).get();

      return ReceiptEntity.fromDocSnapshot(documentSnapshot: fetchedReceipt);
    } on FirebaseException catch (e) {
      throw CouldNotFetchException(eMessage: e.message ?? 'Unable to fetch receipt');
    }
  }

  // create receipt
  Future<void> createReceipt(Map<String, dynamic> document) async {
    try {
      final docId = document['imei'].toString();
      final shopId = document['shopId'];

      // reference to the shop
      final docRef = shop.doc(shopId).collection(receiptsSubCollection);

      await docRef.doc(docId).set(document);
    } on FirebaseException catch (e) {
      throw CouldNotCreateException(
          eMessage: e.message ?? 'Unable to post receipt');
    }
  }

  // update receipt
  Future<void> updateReceipt(Map<String, dynamic> document) async {
    try {
      final docId = document['imei'];
      final shopId = document['shopId'];

      // reference to the shop
      final docRef = shop.doc(shopId).collection(receiptsSubCollection);

      await docRef.doc(docId).update(document);
    } on FirebaseException catch (e) {
      throw CouldNotUpdateException(eMessage: e.message ?? 'Unable to update receipt');
    }
  }
}
