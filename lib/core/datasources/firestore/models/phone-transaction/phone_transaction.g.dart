// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phone_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhoneTransaction _$PhoneTransactionFromJson(Map<String, dynamic> json) =>
    PhoneTransaction(
      uuid: json['uuid'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      senderAddress: json['senderAddress'] as String,
      receiverId: json['receiverId'] as String,
      receiverName: json['receiverName'] as String,
      receiverAddress: json['receiverAddress'] as String,
      deviceName: json['deviceName'] as String,
      model: json['model'] as String,
      imgUrl: json['imgUrl'] as String,
      ram: json['ram'] as String,
      storage: json['storage'] as String,
      imei: json['imei'] as String,
      status: json['status'] as String,
      createdAt: json['createdAt'] as String,
      receivedAt: json['receivedAt'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      participants: (json['participants'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$PhoneTransactionToJson(PhoneTransaction instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'senderAddress': instance.senderAddress,
      'receiverId': instance.receiverId,
      'receiverName': instance.receiverName,
      'receiverAddress': instance.receiverAddress,
      'deviceName': instance.deviceName,
      'model': instance.model,
      'imgUrl': instance.imgUrl,
      'ram': instance.ram,
      'storage': instance.storage,
      'imei': instance.imei,
      'status': instance.status,
      'createdAt': instance.createdAt,
      'receivedAt': instance.receivedAt,
      'dateTime': instance.dateTime.toIso8601String(),
      'participants': instance.participants,
    };
