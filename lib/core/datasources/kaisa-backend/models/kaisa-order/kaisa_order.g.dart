// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kaisa_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KOrder _$KOrderFromJson(Map<String, dynamic> json) => KOrder(
      orderId: json['orderId'] as String,
      smartphone: json['smartphone'] as String,
      imei: json['imei'] as String,
      sentBy: json['sentBy'] as String,
      receivedBy: json['receivedBy'] as String,
      sentOn: json['sentOn'] as String,
      receivedOn: json['receivedOn'] as String,
      orderFrom: json['orderFrom'] as String,
      orderTo: json['orderTo'] as String,
      isSold: json['isSold'] as bool,
    );

Map<String, dynamic> _$KOrderToJson(KOrder instance) => <String, dynamic>{
      'orderId': instance.orderId,
      'smartphone': instance.smartphone,
      'imei': instance.imei,
      'sentBy': instance.sentBy,
      'receivedBy': instance.receivedBy,
      'sentOn': instance.sentOn,
      'receivedOn': instance.receivedOn,
      'orderFrom': instance.orderFrom,
      'orderTo': instance.orderTo,
      'isSold': instance.isSold,
    };
