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
    required this.address,
    required this.isEmailVerified,
    required this.role,
  });

  final String uuid;
  final String fullName;
  final String email;
  final String address;
  final bool isEmailVerified;
  final String role;

  static KaisaUser get empty => const KaisaUser(
        uuid: '',
        fullName: 'Stranger',
        email: '',
        address: '',
        role: '',
        isEmailVerified: true,
      );

  KaisaUser copyWith({
    String? uuid,
    String? fullName,
    String? email,
    String? address,
    String? role,
    bool? isEmailVerified,
    String? profileImgUrl,
  }) {
    return KaisaUser(
      uuid: uuid ?? this.uuid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      address: address ?? this.address,
      role: role ?? this.role,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }

  KaisaUser.fromUserHiveData({required UserDataHive userDataHive})
      : uuid = userDataHive.uuid,
        fullName = userDataHive.fullName,
        email = userDataHive.email,
        address = userDataHive.address,
        role = userDataHive.role,
        isEmailVerified = userDataHive.isEmailVerified;

  KaisaUser.fromQuerySnapshot(
      {required QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot})
      : uuid = documentSnapshot.id,
        fullName = documentSnapshot['fullName'],
        email = documentSnapshot['email'],
        address = documentSnapshot['address'],
        role = documentSnapshot['role'],
        isEmailVerified = documentSnapshot['isEmailVerified'];

  KaisaUser.fromDocSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> documentSnapshot})
      : uuid = documentSnapshot.id,
        fullName = documentSnapshot['fullName'],
        email = documentSnapshot['email'],
        address = documentSnapshot['address'],
        role = documentSnapshot['role'],
        isEmailVerified = documentSnapshot['isEmailVerified'];

  factory KaisaUser.fromJson(Map<String, dynamic> json) =>
      _$KaisaUserFromJson(json);
  Map<String, dynamic> toJson() => _$KaisaUserToJson(this);
}
