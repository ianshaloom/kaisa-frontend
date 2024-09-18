import 'package:cloud_firestore/cloud_firestore.dart';

class ReceiptEntity {
  final int imei;
  final int receiptNo;
  final String customerName;
  final String customerPhoneNo;
  final String deviceDatails;
  final int cashPrice;
  final String receiptImgUrl;
  final String shopId;
  final DateTime receiptDate;
  final DateTime addeOn;

  ReceiptEntity({
    required this.imei,
    required this.receiptNo,
    required this.customerName,
    required this.customerPhoneNo,
    required this.deviceDatails,
    required this.cashPrice,
    required this.receiptImgUrl,
    required this.shopId,
    required this.receiptDate,
    required this.addeOn,
  });

  static ReceiptEntity get empty => ReceiptEntity(
        imei: 0,
        receiptNo: 0,
        customerName: '',
        customerPhoneNo: '',
        deviceDatails: '',
        cashPrice: 0,
        receiptImgUrl: '',
        shopId: '',
        receiptDate: DateTime.now(),
        addeOn: DateTime.now(),
      );

  ReceiptEntity.fromQuerySnapshot(
      {required QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot})
      : imei = documentSnapshot['imei'],
        receiptNo = documentSnapshot['receiptNo'],
        customerName = documentSnapshot['customerName'],
        customerPhoneNo = documentSnapshot['customerPhoneNo'],
        deviceDatails = documentSnapshot['deviceDatails'],
        cashPrice = documentSnapshot['cashPrice'],
        receiptImgUrl = documentSnapshot['receiptImgUrl'],
        shopId = documentSnapshot['shopId'],
        receiptDate = (documentSnapshot['receiptDate'] as Timestamp).toDate(),
        addeOn = (documentSnapshot['addeOn'] as Timestamp).toDate();

  Map<String, dynamic> toJson() => {
        'imei': imei,
        'receiptNo': receiptNo,
        'customerName': customerName,
        'customerPhoneNo': customerPhoneNo,
        'deviceDatails': deviceDatails,
        'cashPrice': cashPrice,
        'receiptImgUrl': receiptImgUrl,
        'shopId': shopId,
        'receiptDate': receiptDate,
        'addeOn': addeOn,
      };
}