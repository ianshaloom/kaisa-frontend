import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kaisa/features/phonetransaction/domain/entity/smartphone_entity.dart';
import 'package:uuid/uuid.dart';

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

  // create
  Future<void> createSmartPhone(SmartphoneEntity smartphone) async {
    await smartphones.doc(smartphone.id).set(smartphone.toMap());
  }

  FirestoreSmartPhoneDs._sharedInstance();

  static final FirestoreSmartPhoneDs _shared =
      FirestoreSmartPhoneDs._sharedInstance();
  factory FirestoreSmartPhoneDs() => _shared;
}

List smartps = [
  SmartphoneEntity(
    id: const Uuid().v4(),
    name: 'Samsung Galaxy A04e',
    brand: 'Samsung',
    model: 'A04e',
    ram: '3GB',
    storage: '32GB',
    display: '6.5 inches',
    mainCamera: '13MP + 2MP',
    frontCamera: '5MP',
    battery: '5000 mAh',
    imageUrl: 'Samsung-Galaxy-A04e-3-32.png',
  ),
];


/* 
Samsung Galaxy A04e

RAM: 3GB
Internal Storage:32/ 64GB
Battery:  5000 mAh
Main camera: 13 MP + 2 MP
Front camera: 5 MP
Display: 6.5 inch
Samsung-Galaxy-A04e-3-32.png
*/