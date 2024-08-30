import 'package:hive_flutter/hive_flutter.dart';

import '../../../firestore/models/kaisa-user/kaisa_user.dart';

part 'hive_user_data_model.g.dart';

@HiveType(typeId: 1)
class UserDataHive extends HiveObject {
  UserDataHive({
    required this.uuid,
    required this.fullName,
    required this.email,
    required this.address,
    required this.isEmailVerified,
    required this.role,
  });

  @HiveField(0)
  final String uuid;
  @HiveField(1)
  final String fullName;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String address;
  @HiveField(4)
  final bool isEmailVerified;
  @HiveField(5)
  final String role;

  static UserDataHive get empty => UserDataHive(
        uuid: '',
        fullName: 'Stranger',
        email: '',
        address: '',
        role: '',
        isEmailVerified: true,
      );

  static UserDataHive copyWithUserData(KaisaUser userData) {
    return UserDataHive(
      uuid: userData.uuid,
      fullName: userData.fullName,
      email: userData.email,
      address: userData.address,
      role: userData.role,
      isEmailVerified: userData.isEmailVerified,
    );
  }


  UserDataHive copyWith({
    String? uuid,
    String? fullName,
    String? email,
    String? address,
    String? role,
    bool? isEmailVerified,
    String? profileImgUrl,
  }) {
    return UserDataHive(
      uuid: uuid ?? this.uuid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      address: address ?? this.address,
      role: role ?? this.role,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }
  }

