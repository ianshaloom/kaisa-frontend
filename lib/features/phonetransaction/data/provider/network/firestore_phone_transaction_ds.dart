import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kaisa/core/utils/extension_methods.dart';

import '../../../../../core/datasources/firestore/models/phone-transaction/phone_transaction.dart';
import '../../../../../core/datasources/hive/hive-crud/hive_user_crud.dart';
import '../../../../../core/datasources/kaisa-backend/crud/kaisa_backend_orders_ds.dart';
import '../../../../../core/datasources/kaisa-backend/models/kaisa-order/kaisa_order.dart';
import '../../../../../core/errors/app_exception.dart';
import '../../core/constants/phone_transaction_const.dart';
import '../../core/errors/phone_transactions_exception.dart';

class FirestorePhoneTransactionDs {
  static final trans = FirebaseFirestore.instance.collection(transaction);
  final HiveUserDataCrud hiveUser = HiveUserDataCrud();
  final KBOrders kbOrders = KBOrders();

  Future<void> newPhoneTransaction(
      {required PhoneTransaction phoneTransaction}) async {
    // final document = phoneTransaction.toJson();
    final documentId = phoneTransaction.transferId;

    try {
      // check if transaction exists, but with reversed transaction id
      final reversedId =
          '${phoneTransaction.receiverId}-${phoneTransaction.senderId}';

      final existingDoc = await trans.doc(reversedId).get();

      if (existingDoc.exists) {

        final DocumentReference transactionDocRef = trans
            .doc(existingDoc.id)
            .collection(phoneTransactions)
            .doc(documentId);

        final document = phoneTransaction.swap(existingDoc.id).toJson();

        await transactionDocRef.set(document);
      } else {
        final exchangesId = phoneTransaction.exchangesId;

        // check if transaction exists
        final docExists = await trans.doc(exchangesId).get();

        if (!docExists.exists) {
          // create doc with participants if it doesn't exist
          await trans.doc(exchangesId).set(
            {
              'participants': phoneTransaction.participants,
            },
          );
        }

        final DocumentReference transactionDocRef = trans
            .doc(exchangesId)
            .collection(phoneTransactions)
            .doc(documentId);

        final document = phoneTransaction.toJson();

       
        await transactionDocRef.set(document);
      }
    } catch (e) {
      throw CouldNotCreateTrans(e.toString());
    }
  }

  Future<void> completePhoneTransaction(
      {required PhoneTransaction phoneTransaction}) async {
    try {
      final documentId = phoneTransaction.transferId;
      final exchangesId = phoneTransaction.exchangesId;

      // add transaction to completed transactions in kaisa backend
      await kbOrders.postOrder(KOrder.fromPhoneTransaction(
        phoneTransaction: phoneTransaction,
      ));

      // persist transaction in firestore
      final DocumentReference transactionDocRef =
          trans.doc(exchangesId).collection(phoneTransactions).doc(documentId);

      final document = phoneTransaction.toJson();
      await transactionDocRef.update(document);
    } on PostDataException catch (e) {
     throw CouldNotUpdateTrans(e.toString());
    } catch (e) {
      throw CouldNotUpdateTrans(e.toString());
    }
  }

  Future<void> cancelPhoneTransaction(
      {required PhoneTransaction phoneTransaction}) async {
    try {
      final documentId = phoneTransaction.transferId;
      final exchangesId = phoneTransaction.exchangesId;

      final DocumentReference transactionDocRef =
          trans.doc(exchangesId).collection(phoneTransactions).doc(documentId);

      final document = phoneTransaction.toJson();
      await transactionDocRef.update(document);
    } catch (e) {
      throw CouldNotUpdateTrans(e.toString());
    }
  }

  // get all phone transactions by id
  Future<List<PhoneTransaction>> getPhoneTransactionsById() async {
    try {
      final user = await hiveUser.getUser();
      final userId = user.uuid;

      final snapshot =
          await trans.where('participants', arrayContains: userId).get();

      final phoneTrans = <PhoneTransaction>[];

      for (final doc in snapshot.docs) {
        final transactionId = doc.id;
        final subCollectionSnapshot =
            await trans.doc(transactionId).collection(phoneTransactions).get();

        final transactions = subCollectionSnapshot.docs
            .map((subDoc) => PhoneTransaction.fromJson(subDoc.data()))
            .toList();

        phoneTrans.addAll(transactions);
      }

      return phoneTrans;
    } catch (e) {
      throw CouldNotFetchTrans(e.toString());
    }
  }
}