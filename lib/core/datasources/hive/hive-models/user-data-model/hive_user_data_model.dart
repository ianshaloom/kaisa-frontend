import 'package:hive_flutter/hive_flutter.dart';

import '../../../../constants/network_const.dart';
import '../../../firestore/models/kaisa-user/kaisa_user.dart';

part 'hive_user_data_model.g.dart';

@HiveType(typeId: 1)
class UserDataHive extends HiveObject {
  UserDataHive({
    required this.uuid,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.isEmailVerified,
    required this.role,
  });

  @HiveField(0)
   String uuid;
  @HiveField(1)
   String fullName;
  @HiveField(2)
   String email;
  @HiveField(6)
   String phoneNumber;
  @HiveField(3)
   String address;
  @HiveField(4)
   bool isEmailVerified;
  @HiveField(5)
   String role;
   @HiveField(7)
    String profileImgUrl = profilePictures[3];

  static UserDataHive get empty => UserDataHive(
        uuid: '',
        fullName: 'Stranger',
        email: '',
        phoneNumber: '',
        address: '',
        role: '',
        isEmailVerified: true,
      );

  static UserDataHive copyWithUserData(KaisaUser userData) {
    return UserDataHive(
      uuid: userData.uuid,
      fullName: userData.fullName,
      email: userData.email,
      phoneNumber: userData.phoneNumber,
      address: userData.address,
      role: userData.role,
      isEmailVerified: userData.isEmailVerified,
    );
  }


  UserDataHive copyWith({
    String? uuid,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? address,
    String? role,
    bool? isEmailVerified,
    String? profileImgUrl,
  }) {
    return UserDataHive(
      uuid: uuid ?? this.uuid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      role: role ?? this.role,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }
  }

