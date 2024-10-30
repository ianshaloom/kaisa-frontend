import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../utils/utility_methods.dart';

part 'kaisa_user.g.dart';

@JsonSerializable()
class KaisaUser {
  const KaisaUser({
    required this.uuid,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.shop,
    required this.active,
    required this.empDate,
    required this.role,
    required this.imgUrl,
    required this.srv,
  });

  final String uuid;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String shop;
  final String imgUrl;
  final DateTime empDate;
  final String role;
  final String srv;
  final bool active;

  bool get isAdmin => role == 'admin';
  String get shopId => genShopId(shop);

  static KaisaUser get empty => KaisaUser(
        uuid: '',
        fullName: '',
        email: '',
        phoneNumber: '',
        shop: '',
        imgUrl: '',
        empDate: DateTime.now(),
        role: 'user',
        srv: '',
        active: true,
      );

  KaisaUser.fromQuerySnapshot(
      {required QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot})
      : uuid = documentSnapshot.id,
        fullName = documentSnapshot['fullName'],
        email = documentSnapshot['email'],
        phoneNumber = documentSnapshot['phoneNumber'],
        shop = documentSnapshot['shop'],
        imgUrl = documentSnapshot['imgUrl'],
        empDate = DateTime.parse(documentSnapshot['empDate']),
        role = documentSnapshot['role'],
        srv = documentSnapshot['srv'],
        active = documentSnapshot['active'];

  KaisaUser.fromDocSnapshot(
      {required DocumentSnapshot<Map<String, dynamic>> documentSnapshot})
      : uuid = documentSnapshot.id,
        fullName = documentSnapshot['fullName'],
        email = documentSnapshot['email'],
        phoneNumber = documentSnapshot['phoneNumber'],
        shop = documentSnapshot['shop'],
        imgUrl = documentSnapshot['imgUrl'],
        empDate = DateTime.parse(documentSnapshot['empDate']),
        role = documentSnapshot['role'],
        srv = documentSnapshot['srv'],
        active = documentSnapshot['active'];

  factory KaisaUser.fromJson(Map<String, dynamic> json) =>
      _$KaisaUserFromJson(json);
  Map<String, dynamic> toJson() => _$KaisaUserToJson(this);
}
