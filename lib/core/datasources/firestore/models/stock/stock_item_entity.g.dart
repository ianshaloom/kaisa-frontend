// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_item_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockItemEntity _$StockItemEntityFromJson(Map<String, dynamic> json) =>
    StockItemEntity(
      imei: json['imei'] as String,
      smUuid: json['smUuid'] as String,
      deviceName: json['deviceName'] as String,
      model: json['model'] as String,
      ram: json['ram'] as String,
      storage: json['storage'] as String,
      imgUrl: json['imgUrl'] as String,
      shopId: json['shopId'] as String,
      isSold: json['isSold'] as bool,
      addeOn: DateTime.parse(json['addeOn'] as String),
      receiptId: json['receiptId'] as String,
    );

Map<String, dynamic> _$StockItemEntityToJson(StockItemEntity instance) =>
    <String, dynamic>{
      'imei': instance.imei,
      'smUuid': instance.smUuid,
      'deviceName': instance.deviceName,
      'model': instance.model,
      'ram': instance.ram,
      'storage': instance.storage,
      'imgUrl': instance.imgUrl,
      'shopId': instance.shopId,
      'isSold': instance.isSold,
      'addeOn': instance.addeOn.toIso8601String(),
      'receiptId': instance.receiptId,
    };
