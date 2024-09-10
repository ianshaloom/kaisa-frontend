import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../../features/phonetransaction/presentation/controller/phone_transaction_ctrl.dart';

part 'phone_transaction.g.dart';

@JsonSerializable()
class PhoneTransaction {
  final String transferId;
  final String exchangesId;

  // sender details
  final String senderId;
  final String senderName;
  final String senderAddress;

  //  receiver details
  final String receiverId;
  final String receiverName;
  final String receiverAddress;

  //  phone details
  final String phoneName;
  final String imgUrl;
  final String ram;
  final String storage;
  final String imeis;

  //  order status - pending, processing, received, cancelled
  final String status;

  //  order dates
  final DateTime createdAt;
  final DateTime receivedAt;

  // processed by
  final String processedBy;
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
    transferId: '',
    exchangesId: '',
    senderId: '',
    senderName: '',
    senderAddress: '',
    receiverId: '',
    receiverName: '',
    receiverAddress: '',
    phoneName: '',
    imgUrl: '',
    ram: '',
    storage: '',
    imeis: '',
    status: '',
    createdAt: DateTime.now(),
    receivedAt: DateTime.now(),
    processedBy: '',
    participants: [],
  );

  PhoneTransaction({
    required this.transferId,
    required this.exchangesId,
    required this.senderId,
    required this.senderName,
    required this.senderAddress,
    required this.receiverId,
    required this.receiverName,
    required this.receiverAddress,
    required this.phoneName,
    required this.imgUrl,
    required this.ram,
    required this.storage,
    required this.imeis,
    required this.status,
    required this.createdAt,
    required this.receivedAt,
    required this.processedBy,
    required this.participants,
  });

  PhoneTransaction copyWith({
    String? transferId,
    String? exchangesId,
    String? senderId,
    String? senderName,
    String? senderAddress,
    String? receiverId,
    String? receiverName,
    String? receiverAddress,
    String? phoneName,
    String? imgUrl,
    String? ram,
    String? storage,
    String? imeis,
    String? status,
    DateTime? createdAt,
    DateTime? receivedAt,
    String? processedBy,
    List<String>? participants,
  }) {
    return PhoneTransaction(
      transferId: transferId ?? this.transferId,
      exchangesId: exchangesId ?? this.exchangesId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderAddress: senderAddress ?? this.senderAddress,
      receiverId: receiverId ?? this.receiverId,
      receiverName: receiverName ?? this.receiverName,
      receiverAddress: receiverAddress ?? this.receiverAddress,
      phoneName: phoneName ?? this.phoneName,
      imgUrl: imgUrl ?? this.imgUrl,
      ram: ram ?? this.ram,
      storage: storage ?? this.storage,
      imeis: imeis ?? this.imeis,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      receivedAt: receivedAt ?? this.receivedAt,
      processedBy: processedBy ?? this.processedBy,
      participants: participants ?? this.participants,
    );
  }

  PhoneTransaction.fromQuerySnapshot(
      {required QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot})
      : transferId = documentSnapshot.id,
        exchangesId = documentSnapshot['exchangesId'],
        senderId = documentSnapshot['senderId'],
        senderName = documentSnapshot['senderName'],
        senderAddress = documentSnapshot['senderAddress'],
        receiverId = documentSnapshot['receiverId'],
        receiverName = documentSnapshot['receiverName'],
        receiverAddress = documentSnapshot['receiverAddress'],
        phoneName = documentSnapshot['phoneName'],
        imgUrl = documentSnapshot['model'],
        ram = documentSnapshot['ram'],
        storage = documentSnapshot['storage'],
        imeis = documentSnapshot['imeis'],
        status = documentSnapshot['status'],
        createdAt = documentSnapshot['createdAt'],
        receivedAt = documentSnapshot['receivedAt'],
        processedBy = documentSnapshot['processedBy'],
        participants = documentSnapshot['participants'];

  PhoneTransaction.fromDocSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> documentSnapshot})
      : transferId = documentSnapshot.id,
        exchangesId = documentSnapshot['exchangesId'],
        senderId = documentSnapshot['senderId'],
        senderName = documentSnapshot['senderName'],
        senderAddress = documentSnapshot['senderAddress'],
        receiverId = documentSnapshot['receiverId'],
        receiverName = documentSnapshot['receiverName'],
        receiverAddress = documentSnapshot['receiverAddress'],
        phoneName = documentSnapshot['phoneName'],
        imgUrl = documentSnapshot['model'],
        ram = documentSnapshot['ram'],
        storage = documentSnapshot['storage'],
        imeis = documentSnapshot['imeis'],
        status = documentSnapshot['status'],
        createdAt = documentSnapshot['createdAt'],
        receivedAt = documentSnapshot['receivedAt'],
        processedBy = documentSnapshot['processedBy'],
        participants = documentSnapshot['participants'];

  factory PhoneTransaction.fromJson(Map<String, dynamic> json) =>
      _$PhoneTransactionFromJson(json);

  Map<String, dynamic> toJson() => _$PhoneTransactionToJson(this);
}

/* List<PhoneTransaction> orders = [
  PhoneTransaction(
    transferId: '1',
    receiverId: '1',
    receiverName: 'John Doe',
    shopAddress: '123, Main Street, Lagos',
    phoneName: 'Samsung',
    model: 'A057F/DS',
    ram: '8GB',
    storage: '128GB',
    quantity: '1',
    imeis: '123456789012345',
    status: 'pending',
    createdAt: DateTime.now(),
    receivedAt: DateTime.now(),
    processedBy: 'Admin',
  ),
  PhoneTransaction(
    transferId: '2',
    receiverId: '2',
    receiverName: 'Jane Doe',
    shopAddress: '123, Main Street, Lagos',
    phoneName: 'Samsung',
    model: 'A057F/DS',
    ram: '8GB',
    storage: '128GB',
    quantity: '1',
    imeis: '123456789012345',
    status: 'processing',
    createdAt: DateTime.now(),
    receivedAt: DateTime.now(),
    processedBy: 'Admin',
  ),
  PhoneTransaction(
    transferId: '3',
    receiverId: '3',
    receiverName: 'John Doe',
    shopAddress: '123, Main Street, Lagos',
    phoneName: 'Samsung',
    model: 'A057F/DS',
    ram: '8GB',
    storage: '128GB',
    quantity: '1',
    imeis: '123456789012345',
    status: 'received',
    createdAt: DateTime.now(),
    receivedAt: DateTime.now(),
    processedBy: 'Admin',
  ),
  PhoneTransaction(
    transferId: '4',
    receiverId: '4',
    receiverName: 'Jane Doe',
    shopAddress: '123, Main Street, Lagos',
    phoneName: 'Samsung',
    model: 'A057F/DS',
    ram: '8GB',
    storage: '128GB',
    quantity: '1',
    imeis: '123456789012345',
    status: 'cancelled',
    createdAt: DateTime.now(),
    receivedAt: DateTime.now(),
    processedBy: 'Admin',
  ),
];
 */