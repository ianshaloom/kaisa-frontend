import 'package:cloud_firestore/cloud_firestore.dart';

class StockItemEntity {
  final String imei;
  final String smUuid;
  final String deviceName;
  final String model;
  final String ram;
  final String storage;
  final String imgUrl;
  final String shopId;
  final bool isSold;
  final DateTime addeOn;
  final String receiptId;

  StockItemEntity({
    required this.imei,
    required this.smUuid,
    required this.deviceName,
    required this.model,
    required this.ram,
    required this.storage,
    required this.imgUrl,
    required this.shopId,
    required this.isSold,
    required this.addeOn,
    required this.receiptId,
  });

  String get phoneDetails => '$model($ram/$storage)';
  static StockItemEntity get empty => StockItemEntity(
        imei: '',
        smUuid: '',
        deviceName: '',
        model: '',
        ram: '',
        storage: '',
        imgUrl: '',
        shopId: '',
        isSold: false,
        addeOn: DateTime.now(),
        receiptId: '',
      );

  StockItemEntity.fromQuerySnapshot(
      {required QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot})
      : imei = documentSnapshot['imei'],
        smUuid = documentSnapshot['smUuid'],
        deviceName = documentSnapshot['deviceName'],
        model = documentSnapshot['model'],
        ram = documentSnapshot['ram'],
        storage = documentSnapshot['storage'],
        imgUrl = documentSnapshot['imgUrl'],
        shopId = documentSnapshot['shopId'],
        isSold = documentSnapshot['isSold'],
        addeOn = DateTime.parse(documentSnapshot['addeOn']),
        receiptId = documentSnapshot['receiptId'];
}
