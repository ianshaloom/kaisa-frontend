import 'package:dartz/dartz.dart';

import '../../../../core/connection/network_info.dart';
import '../../../../core/datasources/firestore/models/kaisa-user/kaisa_user.dart';
import '../../../../core/errors/failure_n_success.dart';
import '../../core/errors/exception.dart';
import '../../core/errors/failures.dart';
import '../../core/success/success.dart';
import '../../domain/entity/auth_user.dart';
import '../../domain/repository/auth_repo.dart';
import '../provider/network/authentication_ds.dart';

class AuthRepoImpl implements AuthRepository {
  AuthRepoImpl(this._firebaseAuthentification);
  final FirebaseAuthentification _firebaseAuthentification;

  @override
  Future<Either<Failure, bool>> checkQualification(int code) async {
    try {
      final isQualified =
          await _firebaseAuthentification.checkQualification(code);

      return Future.value(Right(isQualified));
    } on AuthenticationException catch (e) {
      return Future.value(Left(AuthFailure(errorMessage: e.message)));
    }
  }

  @override
  AuthUser get currentUser => _firebaseAuthentification.currentUser;

  @override
  Stream<AuthUser> get user => _firebaseAuthentification.user;

  @override
  Future<Either<Failure, AuthUser>> createUser({
    required String fullName,
    required String address,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {

     final bool isConnected = await NetworkInfo.connectionChecker.hasConnection;

    if (!isConnected) {
      return Left(
        AuthFailure(errorMessage: 'You have no internet connection 🚩'),
      );
    }
    
    try {
      final user = await _firebaseAuthentification.signUp(
        fullName: fullName,
        address: address,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
      );

      return Future.value(Right(user));
    } on AuthenticationException catch (e) {
      return Future.value(Left(AuthFailure(errorMessage: e.message)));
    }
  }

  @override
  Future<Either<Failure, AuthUser>> logIn(
      {required String email, required String password}) async {

        final bool isConnected = await NetworkInfo.connectionChecker.hasConnection;

    if (!isConnected) {
      return Left(
        AuthFailure(errorMessage: 'You have no internet connection 🚩'),
      );
    }

    try {
      final user = await _firebaseAuthentification.signIn(
        email: email,
        password: password,
      );

      return Future.value(Right(user));
    } on AuthenticationException catch (e) {
      return Future.value(Left(AuthFailure(errorMessage: e.message)));
    }
  }

  @override
  Future<Either<Failure, Success>> verifyEmail() async {

    final bool isConnected = await NetworkInfo.connectionChecker.hasConnection;

    if (!isConnected) {
      return Left(
        AuthFailure(errorMessage: 'You have no internet connection 🚩'),
      );
    }

    try {
      String message = '';

      await _firebaseAuthentification
          .sendEmailVerification()
          .then((value) => message = 'Email verification sent')
          .onError(
              (error, stackTrace) => message = 'Email verification failed');

      return Future.value(Right(AuthSuccess(successContent: message)));
    } on AuthenticationException catch (e) {
      return Future.value(Left(AuthFailure(errorMessage: e.message)));
    }
  }

  @override
  Future<Either<Failure, Success>> resetPassword(
      {required String email}) async {

        final bool isConnected = await NetworkInfo.connectionChecker.hasConnection;

    if (!isConnected) {
      return Left(
        AuthFailure(errorMessage: 'You have no internet connection 🚩'),
      );
    }

    try {
      String message = '';

      await _firebaseAuthentification
          .sendPasswordResetEmail(email: email)
          .then((value) => message = 'Password reset email sent')
          .onError(
              (error, stackTrace) => message = 'Password reset email failed');

      return Future.value(Right(AuthSuccess(successContent: message)));
    } on AuthenticationException catch (e) {
      return Future.value(Left(AuthFailure(errorMessage: e.message)));
    }
  }

  @override
  Future<Either<Failure, Success>> signOut() async {
    final bool isConnected = await NetworkInfo.connectionChecker.hasConnection;

    if (!isConnected) {
      return Left(
        AuthFailure(errorMessage: 'You have no internet connection 🚩'),
      );
    }

    try {
      String message = '';

      await _firebaseAuthentification
          .signOut()
          .then((value) => message = 'Sign out successful')
          .onError((error, stackTrace) => message = 'Sign out failed');

      return Future.value(Right(AuthSuccess(successContent: message)));
    } on AuthenticationException catch (e) {
      return Future.value(Left(AuthFailure(errorMessage: e.message)));
    }
  }

   @override
  Future<Either<Failure, Success>> deleteAccount() async {
    final bool isConnected = await NetworkInfo.connectionChecker.hasConnection;

    if (!isConnected) {
      return Left(
        AuthFailure(errorMessage: 'You have no internet connection 🚩'),
      );
    }

    try {
      String message = '';

      await _firebaseAuthentification
          .deleteAccount()
          .then((value) => message = 'Account deletion successful')
          .onError((error, stackTrace) => message = 'Account deletion failed');

      return Future.value(Right(AuthSuccess(successContent: message)));
    } on AuthenticationException catch (e) {
      return Future.value(Left(AuthFailure(errorMessage: e.message)));
    }
  }

  @override
  Stream<KaisaUser> userStream({required String userId}) {
    return _firebaseAuthentification.userStream(userId: userId);
  }
}
