import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/datasources/firestore/models/phone-transaction/phone_transaction.dart';
import '../../../../../core/datasources/hive/hive-crud/hive_user_crud.dart';
import '../../../../../core/datasources/kaisa-backend/crud/kaisa_backend_ds.dart';
import '../../../../../core/errors/app_exception.dart';
import '../../core/constants/phone_transaction_const.dart';
import '../../core/errors/phone_transactions_exception.dart';

class FirestoreKOrderTransc {
  static final trans = FirebaseFirestore.instance.collection(transaction);
  final HiveUserDataCrud hiveUser = HiveUserDataCrud();
  final KaisaBackendDS kbDS = KaisaBackendDS();

  Future<void> setKOrderTransc(
      {required PhoneTransaction phoneTransaction}) async {
    final document = phoneTransaction.toJson();
    final documentId = phoneTransaction.uuid;

    try {
      await trans.doc(documentId).set(document);
    } on FirebaseException catch (e) {
      throw CouldNotCreateTrans(e.message);
    }
  }

  Future<void> receiveKOrderTransc(
      {required PhoneTransaction phoneTransaction}) async {
    try {
      await kbDS.receiveKOrderTransc(phoneTransaction.toJson());
    } on PostDataException catch (e) {
      throw CouldNotUpdateTrans(e.toString());
    } catch (e) {
      throw GenericCloudException(e.toString());
    }
  }

  Future<void> cancelKOrderTransc(
      {required PhoneTransaction phoneTransaction}) async {
    try {
      final document = phoneTransaction.toJson();
      final documentId = phoneTransaction.uuid;

      await trans.doc(documentId).update(document);
    } on FirebaseException catch (e) {
      throw CouldNotUpdateTrans(e.message);
    }
  }

  // fetch all transactions by participant id
  Future<List<PhoneTransaction>> fetchKOrderTranscById() async {
    try {
           final user = await hiveUser.getUser();
      final userId = user.uuid;

      final snapshot =
          await trans.where('participants', arrayContains: userId).get();

      final transactions = snapshot.docs
          .map((doc) => PhoneTransaction.fromDocSnapshot(documentSnapshot: doc))
          .toList();

      return transactions;
      
    } on FirebaseException catch (e) {
      throw CouldNotFetchTrans(e.message);
    }
  }

  // Stream of all transactions by participant id
  Stream<List<PhoneTransaction>> streamKOrderTranscById(String userId) {
    final snapshot =
        trans.where('participants', arrayContains: userId).snapshots().map(
              (event) => event.docs
                  .map(
                    (doc) =>
                        PhoneTransaction.fromDocSnapshot(documentSnapshot: doc),
                  )
                  .toList(),
            );

    return snapshot;
  }

  // Stream a single transaction by id
  Stream<PhoneTransaction> streamSingleKOrderTransc(String uuid) {
    final snapshot = trans.doc(uuid).snapshots().map(
        (event) => PhoneTransaction.fromDocSnapshot(documentSnapshot: event));

    return snapshot;
  }
}
