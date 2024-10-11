import 'package:cloud_firestore/cloud_firestore.dart';

class ReceiptEntity {
  final int imei;
  final int receiptNo;
  final String customerName;
  final String customerPhoneNo;
  final String deviceDatails;
  final int cashPrice;
  final List<String> receiptImgUrl;
  final String shopId;
  final DateTime receiptDate;
  final DateTime addeOn;
  final String smUuid;
  final String org;

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
    required this.smUuid,
    required this.org,
  });

  // getters
  String get getReceiptNo => '#$receiptNo';

  static ReceiptEntity get empty => ReceiptEntity(
        imei: 0,
        receiptNo: 0,
        customerName: '',
        customerPhoneNo: '',
        deviceDatails: '',
        cashPrice: 0,
        receiptImgUrl: [],
        shopId: '',
        receiptDate: DateTime.now(),
        addeOn: DateTime.now(),
        smUuid: '',
        org: '',
      );

  ReceiptEntity.fromQuerySnapshot(
      {required QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot})
      : imei = documentSnapshot['imei'],
        receiptNo = documentSnapshot['receiptNo'],
        customerName = documentSnapshot['customerName'],
        customerPhoneNo = documentSnapshot['customerPhoneNo'],
        deviceDatails = documentSnapshot['deviceDatails'],
        cashPrice = documentSnapshot['cashPrice'],
        receiptImgUrl = documentSnapshot['receiptImgUrl'].cast<String>(),
        shopId = documentSnapshot['shopId'],
        receiptDate = DateTime.parse(documentSnapshot['receiptDate']),
        addeOn = DateTime.parse(documentSnapshot['addeOn']),
        smUuid = documentSnapshot['smUuid'],
        org = documentSnapshot['org'];

  ReceiptEntity.fromDocSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> documentSnapshot})
      : imei = documentSnapshot['imei'],
        receiptNo = documentSnapshot['receiptNo'],
        customerName = documentSnapshot['customerName'],
        customerPhoneNo = documentSnapshot['customerPhoneNo'],
        deviceDatails = documentSnapshot['deviceDatails'],
        cashPrice = documentSnapshot['cashPrice'],
        receiptImgUrl = documentSnapshot['receiptImgUrl'].cast<String>(),
        shopId = documentSnapshot['shopId'],
        receiptDate = DateTime.parse(documentSnapshot['receiptDate']),
        addeOn = DateTime.parse(documentSnapshot['addeOn']),
        smUuid = documentSnapshot['smUuid'],
        org = documentSnapshot['org'];

  Map<String, dynamic> toJson() => {
        'imei': imei,
        'receiptNo': receiptNo,
        'customerName': customerName,
        'customerPhoneNo': customerPhoneNo,
        'deviceDatails': deviceDatails,
        'cashPrice': cashPrice,
        'receiptImgUrl': receiptImgUrl,
        'shopId': shopId,
        'receiptDate': receiptDate.toIso8601String(),
        'addeOn': addeOn.toIso8601String(),
        'smUuid': smUuid,
        'org': org,
      };

  ReceiptEntity.fromJsonKBackend(Map<String, dynamic> json)
      : imei = json['imei'],
        receiptNo = json['receiptNo'],
        customerName = json['customerName'],
        customerPhoneNo = json['customerPhoneNo'],
        deviceDatails = json['deviceDatails'],
        cashPrice = json['cashPrice'],
        receiptImgUrl = stringToList(json['receiptImgUrl']).cast<String>(),
        shopId = json['shopId'],
        receiptDate = DateTime.parse(json['receiptDate']),
        addeOn = DateTime.parse(json['addeOn']),
        smUuid = json['smUuid'],
        org = json['org'];

  ReceiptEntity.fromJson(Map<String, dynamic> json)
      : imei = json['imei'],
        receiptNo = json['receiptNo'],
        customerName = json['customerName'],
        customerPhoneNo = json['customerPhoneNo'],
        deviceDatails = json['deviceDatails'],
        cashPrice = json['cashPrice'],
        receiptImgUrl = json['receiptImgUrl'].cast<String>(),
        shopId = json['shopId'],
        receiptDate = DateTime.parse(json['receiptDate']),
        addeOn = DateTime.parse(json['addeOn']),
        smUuid = json['smUuid'],
        org = json['org'];

  static List<ReceiptEntity> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => ReceiptEntity.fromJsonKBackend(json))
        .toList();
  }

  //  copywith method
  ReceiptEntity copyWith({
    int? imei,
    int? receiptNo,
    String? customerName,
    String? customerPhoneNo,
    String? deviceDatails,
    int? cashPrice,
    List<String>? receiptImgUrl,
    String? shopId,
    DateTime? receiptDate,
    DateTime? addeOn,
    String? smUuid,
    String? org,
  }) {
    return ReceiptEntity(
      imei: imei ?? this.imei,
      receiptNo: receiptNo ?? this.receiptNo,
      customerName: customerName ?? this.customerName,
      customerPhoneNo: customerPhoneNo ?? this.customerPhoneNo,
      deviceDatails: deviceDatails ?? this.deviceDatails,
      cashPrice: cashPrice ?? this.cashPrice,
      receiptImgUrl: receiptImgUrl ?? this.receiptImgUrl,
      shopId: shopId ?? this.shopId,
      receiptDate: receiptDate ?? this.receiptDate,
      addeOn: addeOn ?? this.addeOn,
      smUuid: smUuid ?? this.smUuid,
      org: org ?? this.org,
    );
  }
}

List<String> stringToList(String str) {
  return str.split('---');
}
