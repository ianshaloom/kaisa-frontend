import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kaisa/features/phonetransaction/domain/entity/smartphone_entity.dart';

import '../../../../../core/constants/constants.dart';

class FirestoreSmartPhoneDs {
  final smartphones =
      FirebaseFirestore.instance.collection(smartPhonesCollection);

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
