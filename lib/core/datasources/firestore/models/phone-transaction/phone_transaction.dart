import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../../features/phonetransaction/presentation/controller/phone_transaction_ctrl.dart';

part 'phone_transaction.g.dart';

@JsonSerializable()
class PhoneTransaction {
  PhoneTransaction({
    required this.uuid,
    required this.smUuid,
    required this.senderId,
    required this.senderName,
    required this.senderAddress,
    required this.receiverId,
    required this.receiverName,
    required this.receiverAddress,
    required this.deviceName,
    required this.model,
    required this.imgUrl,
    required this.ram,
    required this.storage,
    required this.imei,
    required this.status,
    required this.createdAt,
    required this.receivedAt,
    required this.dateTime,
    required this.participants,
  });

  final String uuid;
  final String smUuid;

  // sender details
  final String senderId;
  final String senderName;
  final String senderAddress;

  //  receiver details
  final String receiverId;
  final String receiverName;
  final String receiverAddress;

  //  phone details
  final String deviceName;
  final String model;
  final String imgUrl;
  final String ram;
  final String storage;
  final String imei;

  //  order status - pending, processing, received, cancelled
  final String status;

  //  order dates
  final String createdAt;
  final String receivedAt;
  final DateTime dateTime;
  final List<String> participants;

  // getters
  bool get isPending => status == 'Pending';
  bool get isCancelled => status == 'Cancelled';
  bool get isDelivered => status == 'Delivered';
  bool get isSender {
    final controller = Get.find<PhoneTransactionCtrl>();
    return senderId == controller.userData.uuid;
  }

  static PhoneTransaction empty = PhoneTransaction(
    uuid: '',
    smUuid: '',
    senderId: '',
    senderName: '',
    senderAddress: '',
    receiverId: '',
    receiverName: '',
    receiverAddress: '',
    deviceName: '',
    model: '',
    imgUrl: '',
    ram: '',
    storage: '',
    imei: '',
    status: '',
    createdAt: '',
    receivedAt: '',
    dateTime: DateTime.now(),
    participants: [],
  );

  PhoneTransaction.fromQuerySnapshot(
      {required QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot})
      : uuid = documentSnapshot.id,
        smUuid = documentSnapshot['smUuid'],
        senderId = documentSnapshot['senderId'],
        senderName = documentSnapshot['senderName'],
        senderAddress = documentSnapshot['senderAddress'],
        receiverId = documentSnapshot['receiverId'],
        receiverName = documentSnapshot['receiverName'],
        receiverAddress = documentSnapshot['receiverAddress'],
        deviceName = documentSnapshot['deviceName'],
        model = documentSnapshot['model'],
        imgUrl = documentSnapshot['imgUrl'],
        ram = documentSnapshot['ram'],
        storage = documentSnapshot['storage'],
        imei = documentSnapshot['imei'],
        status = documentSnapshot['status'],
        createdAt = documentSnapshot['createdAt'],
        receivedAt = documentSnapshot['receivedAt'],
        dateTime = DateTime.parse(documentSnapshot['dateTime']),
        participants = documentSnapshot['participants'].cast<String>();

  PhoneTransaction.fromDocSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> documentSnapshot})
      : uuid = documentSnapshot.id,
        smUuid = documentSnapshot['smUuid'],
        senderId = documentSnapshot['senderId'],
        senderName = documentSnapshot['senderName'],
        senderAddress = documentSnapshot['senderAddress'],
        receiverId = documentSnapshot['receiverId'],
        receiverName = documentSnapshot['receiverName'],
        receiverAddress = documentSnapshot['receiverAddress'],
        deviceName = documentSnapshot['deviceName'],
        model = documentSnapshot['model'],
        imgUrl = documentSnapshot['imgUrl'],
        ram = documentSnapshot['ram'],
        storage = documentSnapshot['storage'],
        imei = documentSnapshot['imei'],
        status = documentSnapshot['status'],
        createdAt = documentSnapshot['createdAt'],
        receivedAt = documentSnapshot['receivedAt'],
        dateTime = DateTime.parse(documentSnapshot['dateTime']),
        participants = documentSnapshot['participants'].cast<String>();

  factory PhoneTransaction.fromJson(Map<String, dynamic> json) =>
      _$PhoneTransactionFromJson(json);

  Map<String, dynamic> toJson() => _$PhoneTransactionToJson(this);

  // this is a copy with method
  PhoneTransaction copyWith({
    String? uuid,
    String? smUuid,
    String? senderId,
    String? senderName,
    String? senderAddress,
    String? receiverId,
    String? receiverName,
    String? receiverAddress,
    String? deviceName,
    String? model,
    String? imgUrl,
    String? ram,
    String? storage,
    String? imei,
    String? status,
    String? createdAt,
    String? receivedAt,
    DateTime? dateTime,
    List<String>? participants,
  }) {
    return PhoneTransaction(
      uuid: uuid ?? this.uuid,
      smUuid: smUuid ?? this.smUuid,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderAddress: senderAddress ?? this.senderAddress,
      receiverId: receiverId ?? this.receiverId,
      receiverName: receiverName ?? this.receiverName,
      receiverAddress: receiverAddress ?? this.receiverAddress,
      deviceName: deviceName ?? this.deviceName,
      model: model ?? this.model,
      imgUrl: imgUrl ?? this.imgUrl,
      ram: ram ?? this.ram,
      storage: storage ?? this.storage,
      imei: imei ?? this.imei,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      receivedAt: receivedAt ?? this.receivedAt,
      dateTime: dateTime ?? this.dateTime,
      participants: participants ?? this.participants,
    );
  }
}
