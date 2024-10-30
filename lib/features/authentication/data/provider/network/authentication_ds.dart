import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../../../../core/constants/network_const.dart';
import '../../../../../core/datasources/firestore/crud/kaisa_users_ds.dart';
import '../../../../../core/datasources/firestore/models/kaisa-user/kaisa_user.dart';
import '../../../../../core/datasources/kaisa-backend/crud/kaisa_backend_ds.dart';
import '../../../core/errors/exception.dart';
import '../../../domain/entity/auth_user.dart';
import '../../../../../core/datasources/hive/hive-crud/hive_user_crud.dart';

class FirebaseAuthentification {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final hiveUserDataCrud = HiveUserDataCrud();
  final KaisaBackendDS kbUsers = KaisaBackendDS();

  // ckeck if user is qualified
  Future<bool> checkQualification(int code) async {
    return await kbUsers.fetchKActivCode(code);
  }

  AuthUser get currentUser {
    final user = firebase_auth.FirebaseAuth.instance.currentUser;

    if (user != null) {
      user.reload();
      return AuthUser.fromFirebase(user);
    }

    return AuthUser.empty;
  }

  Stream<AuthUser> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      if (firebaseUser != null) {
        firebaseUser.reload();
        return AuthUser.fromFirebase(firebaseUser);
      } else {
        return AuthUser.empty;
      }
    });
  }

  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final firebase_auth.UserCredential credential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw Exception('Sign in failed: The user is null after sign in.');
      }

      return AuthUser.fromFirebase(credential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthenticationException(message: e.code);
    } catch (e) {
      throw AuthenticationException(message: e.toString());
    }
  }

  Future<AuthUser> signUp({
    required String fullName,
    required String address,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final firebase_auth.UserCredential credential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw Exception('Sign up failed: The user is null after sign up.');
      }

      // add user data to firestore and device
      final userData = KaisaUser(
        uuid: credential.user!.uid,
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        shop: address,
        active: false,
        imgUrl: kBaseUrlProfileImgs,
        role: 'user',
        empDate: DateTime.now(),
        srv: 'vslzx7k',
      );

      await FirestoreUsersDs.createUser(user: userData);

      return AuthUser.fromFirebase(credential.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthenticationException(message: e.code);
    } catch (e) {
      throw AuthenticationException(message: e.toString());
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      final firebase_auth.User? user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception(
            'Failed to send email verification, User cannot be null');
      }
      await user.sendEmailVerification();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthenticationException(message: e.code);
    } catch (e) {
      throw AuthenticationException(message: e.toString());
    }
  }

  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(
        email: email,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthenticationException(message: e.code);
    } catch (e) {
      throw AuthenticationException(message: e.toString());
    }
  }

  // delete account
  Future<void> deleteAccount() async {
    try {
      final firebase_auth.User? user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('Failed to delete account, User was found to be null');
      }

      await user.delete();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthenticationException(message: e.code);
    } catch (e) {
      throw AuthenticationException(message: e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();

    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthenticationException(message: e.code);
    } catch (e) {
      throw AuthenticationException(message: e.toString());
    }
  }

  // stream user
  Stream<KaisaUser> userStream({required String userId}) {
    return FirestoreUsersDs.userStream(userId: userId);
  }

  // factory constructor
  FirebaseAuthentification._({
    required firebase_auth.FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;
  static final FirebaseAuthentification _instance = FirebaseAuthentification._(
    firebaseAuth: firebase_auth.FirebaseAuth.instance,
  );
  factory FirebaseAuthentification() => _instance;
}
