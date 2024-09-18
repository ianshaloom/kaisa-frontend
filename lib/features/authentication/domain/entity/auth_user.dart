import 'package:firebase_auth/firebase_auth.dart';

class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    required this.isEmailVerified,
  });
  final String id;
  final String email;
  final bool isEmailVerified;

  static const AuthUser empty = AuthUser(
    id: '',
    email: '',
    isEmailVerified: false,
  );

  bool get isEmpty => this == AuthUser.empty;

  factory AuthUser.fromFirebase(User user) => AuthUser(
        id: user.uid,
        email: user.email!,
        isEmailVerified: user.emailVerified,
      );
}
