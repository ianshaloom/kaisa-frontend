import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../../../../core/datasources/firestore/crud/kaisa_users_ds.dart';
import '../../../../../core/datasources/firestore/models/kaisa-user/kaisa_user.dart';
import '../../../../../core/datasources/hive/hive-models/user-data-model/hive_user_data_model.dart';
import '../../../../../core/datasources/kaisa-backend/crud/kaisa_backend_users_ds.dart';
import '../../../core/errors/exception.dart';
import '../../../domain/entity/auth_user.dart';
import '../../../../../core/datasources/hive/hive-crud/hive_user_crud.dart';

class FirebaseAuthentification {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final hiveUserDataCrud = HiveUserDataCrud();
  final KBUsers kbUsers = KBUsers();

  // ckeck if user is qualified
  Future<bool> checkQualification(int code) async {
    return await kbUsers.checkQualification(code);
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

      // fetch user data from firestore
      final userData =
          await FirestoreUsersDs.fetchUser(userId: credential.user!.uid);

      // then store user data in device
      await hiveUserDataCrud.saveUser(UserDataHive.copyWithUserData(userData));

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
        address: address,
        isEmailVerified: false,
        role: 'user',
      );

      await FirestoreUsersDs.createUser(user: userData);
      await hiveUserDataCrud.saveUser(UserDataHive.copyWithUserData(userData));

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

  Future<AuthUser> changePassword({
    required String password,
  }) async {
    try {
      final firebase_auth.User? user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('Failed to change password, User was found to be null');
      }
      await user.updatePassword(password);

      /// ToDo

      return AuthUser.fromFirebase(user);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthenticationException(message: e.code);
    } catch (e) {
      throw AuthenticationException(message: e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();

      // delete user info from device
      await hiveUserDataCrud.clearUserData();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthenticationException(message: e.code);
    } catch (e) {
      throw AuthenticationException(message: e.toString());
    }
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
