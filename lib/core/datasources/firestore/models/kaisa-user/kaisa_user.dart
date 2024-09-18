import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../hive/hive-models/user-data-model/hive_user_data_model.dart';

part 'kaisa_user.g.dart';

@JsonSerializable()
class KaisaUser {
  const KaisaUser({
    required this.uuid,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.isEmailVerified,
    required this.role,
  });

  final String uuid;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String address;
  final bool isEmailVerified;
  final String role;

  static KaisaUser get empty => const KaisaUser(
        uuid: '',
        fullName: 'Stranger',
        email: '',
        phoneNumber: '',
        address: '',
        role: '',
        isEmailVerified: true,
      );

  KaisaUser.fromUserHiveData({required UserDataHive userDataHive})
      : uuid = userDataHive.uuid,
        fullName = userDataHive.fullName,
        email = userDataHive.email,
        phoneNumber = userDataHive.phoneNumber,
        address = userDataHive.address,
        role = userDataHive.role,
        isEmailVerified = userDataHive.isEmailVerified;

  KaisaUser.fromQuerySnapshot(
      {required QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot})
      : uuid = documentSnapshot.id,
        fullName = documentSnapshot['fullName'],
        email = documentSnapshot['email'],
        phoneNumber = documentSnapshot['phoneNumber'],
        address = documentSnapshot['address'],
        role = documentSnapshot['role'],
        isEmailVerified = documentSnapshot['isEmailVerified'];

  factory KaisaUser.fromJson(Map<String, dynamic> json) =>
      _$KaisaUserFromJson(json);
  Map<String, dynamic> toJson() => _$KaisaUserToJson(this);
}
