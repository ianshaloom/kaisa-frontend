import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kaisa/features/phonetransaction/domain/entity/smartphone_entity.dart';
import 'package:uuid/uuid.dart';

import '../../../../../../core/errors/cloud_storage_exceptions.dart';
import '../../../../../core/constants/constants.dart';

class FirestoreSmartPhoneDs {
  final smartphones =
      FirebaseFirestore.instance.collection(smartPhonesCollection);

  Future<void> createSmartPhone({
    required SmartphoneEntity smartphone,
  }) async {
    try {
      final docId = const Uuid().v4();
      final document = smartphone.toMap();
      await smartphones.doc(docId).set(document);
    } catch (e) {
      throw CouldNotCreateException();
    }
  }

  // update a smartphone
  Future<void> updateSmartPhone({
    required SmartphoneEntity smartphone,
  }) async {
    final document = smartphone.toMap();

    try {
      await smartphones.doc(smartphone.id).update(document);
    } catch (e) {
      throw CouldNotUpdateException();
    }
  }

  // delete a smartphone
  Future<void> deleteSmartPhone({
    required String id,
  }) async {
    try {
      await smartphones.doc(id).delete();
    } catch (e) {
      throw CouldNotDeleteException();
    }
  }

  // get all smartphones
  Future<List<SmartphoneEntity>> fetchSmartPhones() async {
    final snapshot = await smartphones.get();

    return snapshot.docs
        .map((doc) => SmartphoneEntity.fromQuerySnapshot(documentSnapshot: doc))
        .toList();
  }

  FirestoreSmartPhoneDs._sharedInstance();

  static final FirestoreSmartPhoneDs _shared =
      FirestoreSmartPhoneDs._sharedInstance();
  factory FirestoreSmartPhoneDs() => _shared;
}
