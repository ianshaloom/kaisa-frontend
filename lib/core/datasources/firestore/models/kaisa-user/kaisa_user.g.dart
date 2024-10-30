// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kaisa_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KaisaUser _$KaisaUserFromJson(Map<String, dynamic> json) => KaisaUser(
      uuid: json['uuid'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      shop: json['shop'] as String,
      active: json['active'] as bool,
      empDate: DateTime.parse(json['empDate'] as String),
      role: json['role'] as String,
      imgUrl: json['imgUrl'] as String,
      srv: json['srv'] as String,
    );

Map<String, dynamic> _$KaisaUserToJson(KaisaUser instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'fullName': instance.fullName,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'shop': instance.shop,
      'imgUrl': instance.imgUrl,
      'empDate': instance.empDate.toIso8601String(),
      'role': instance.role,
      'srv': instance.srv,
      'active': instance.active,
    };
