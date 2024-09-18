import 'package:cloud_firestore/cloud_firestore.dart';

class StockItemEntity {
  final String imei;
  final String deviceName;
  final String model;
  final String ram;
  final String storage;
  final String imgUrl;
  final String shopId;
  final bool isSold;
  final DateTime addeOn;

  StockItemEntity({
      required this.imei,
      required this.deviceName,
      required this.model,
      required this.ram,
      required this.storage,
      required this.imgUrl,
      required this.shopId,
      required this.isSold,
      required this.addeOn,
    });

  String get phoneDetails => '$model($ram/$storage)';
  static StockItemEntity get empty => StockItemEntity(
        imei: '',
        deviceName: '',
        model: '',
        ram: '',
        storage: '',
        imgUrl: '',
        shopId: '',
        isSold: false,
        addeOn: DateTime.now(),
      );

  StockItemEntity.fromQuerySnapshot(
      {required QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot})
      : imei = documentSnapshot['imei'],
        deviceName = documentSnapshot['deviceName'],
        model = documentSnapshot['model'],
        ram = documentSnapshot['ram'],
        storage = documentSnapshot['storage'],
        imgUrl = documentSnapshot['imgUrl'],
        shopId = documentSnapshot['shopId'],
        isSold = documentSnapshot['isSold'],
        addeOn = documentSnapshot['addeOn'].toDate();
}
