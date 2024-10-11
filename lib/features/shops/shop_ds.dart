import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kaisa/features/phonetransaction/data/core/constants/phone_transaction_const.dart';

import '../../core/constants/constants.dart';
import '../../core/errors/cloud_storage_exceptions.dart';
import '../phonetransaction/data/core/errors/phone_transactions_exception.dart';

class ShopDs {
  static final trans = FirebaseFirestore.instance.collection(transaction);
  static final shop =
      FirebaseFirestore.instance.collection(kaisaShopsCollection);

  // fetch all transactions by participant id
  Future<List<Map<String, dynamic>>>
      fetchKOrderTranscById(List<String> ids) async {

    try {
      List<Map<String, dynamic>> phoneTrans = [];
      
      for (var id in ids) {

      //  get where participants contain id
        final snapshot = await trans.where('participants', arrayContains: id).get();

        final ts = snapshot.docs.map((doc) => doc.data()).toList();

        phoneTrans.addAll(ts);
      }

      return phoneTrans;
    } on FirebaseException catch (e) {
      throw CouldNotFetchTrans(e.message);
    }
  }

  // get receipts by shop id
  Future<List<Map<String, dynamic>>> fetchShopReceipts(
      String shopId) async {
    try {
      // reference to the shop
      final docRef = shop.doc(shopId).collection(receiptsSubCollection);

      final fetchedReceipts = await docRef.get();

      return fetchedReceipts.docs.map((doc) => doc.data()).toList();
    } on FirebaseException catch (e) {
      throw CouldNotFetchException(
          eMessage: e.message ?? 'Unable to fetch receipts');
    }
  }

  // get stock items by shop id
  Future<List<Map<String, dynamic>>> fetchShopStock(
      String shopId) async {
    try {
      // reference to the shop
      final docRef = shop.doc(shopId).collection(stockSubCollection);

      final fetchedStockItems = await docRef.get();

      return fetchedStockItems.docs.map((doc) => doc.data()).toList();
    } on FirebaseException catch (e) {
      throw CouldNotFetchException(
          eMessage: e.message ?? 'Unable to fetch stock items');
    }
  }
}
