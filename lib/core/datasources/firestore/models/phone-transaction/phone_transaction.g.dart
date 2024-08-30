// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phone_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhoneTransaction _$PhoneTransactionFromJson(Map<String, dynamic> json) =>
    PhoneTransaction(
      transferId: json['transferId'] as String,
      exchangesId: json['exchangesId'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      senderAddress: json['senderAddress'] as String,
      receiverId: json['receiverId'] as String,
      receiverName: json['receiverName'] as String,
      receiverAddress: json['receiverAddress'] as String,
      phoneName: json['phoneName'] as String,
      imgUrl: json['imgUrl'] as String,
      ram: json['ram'] as String,
      storage: json['storage'] as String,
      imeis: json['imeis'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      receivedAt: DateTime.parse(json['receivedAt'] as String),
      processedBy: json['processedBy'] as String,
      participants: (json['participants'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$PhoneTransactionToJson(PhoneTransaction instance) =>
    <String, dynamic>{
      'transferId': instance.transferId,
      'exchangesId': instance.exchangesId,
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'senderAddress': instance.senderAddress,
      'receiverId': instance.receiverId,
      'receiverName': instance.receiverName,
      'receiverAddress': instance.receiverAddress,
      'phoneName': instance.phoneName,
      'imgUrl': instance.imgUrl,
      'ram': instance.ram,
      'storage': instance.storage,
      'imeis': instance.imeis,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'receivedAt': instance.receivedAt.toIso8601String(),
      'processedBy': instance.processedBy,
      'participants': instance.participants,
    };
