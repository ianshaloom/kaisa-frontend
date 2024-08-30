import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../core/constants/constants.dart';

class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    required this.isEmailVerified,
    this.name = 'Stranger',
    this.profileImgUrl = imgUrl,
  });
  final String id;
  final String? name;
  final String email;
  final String? profileImgUrl;
  final bool isEmailVerified;

  static const AuthUser empty = AuthUser(
    id: '',
    email: '',
    isEmailVerified: false,
    name: '',
    profileImgUrl: '',
  );

  bool get isEmpty => this == AuthUser.empty;

  factory AuthUser.fromFirebase(User user) => AuthUser(
        id: user.uid,
        email: user.email!,
        isEmailVerified: user.emailVerified,
        name: user.displayName,
        profileImgUrl: user.photoURL,
      );
}
