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
      address: json['address'] as String,
      isEmailVerified: json['isEmailVerified'] as bool,
      role: json['role'] as String,
    );

Map<String, dynamic> _$KaisaUserToJson(KaisaUser instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'fullName': instance.fullName,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'address': instance.address,
      'isEmailVerified': instance.isEmailVerified,
      'role': instance.role,
    };
