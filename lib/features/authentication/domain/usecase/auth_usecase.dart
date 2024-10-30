import 'package:dartz/dartz.dart';


import '../../../../core/datasources/firestore/models/kaisa-user/kaisa_user.dart';
import '../../../../core/errors/failure_n_success.dart';
import '../entity/auth_user.dart';
import '../repository/auth_repo.dart';

class AuthUC {
  final AuthRepository _authRepository;

  Future<Either<Failure, bool>> checkQualification(int code) async {
    return await _authRepository.checkQualification(code);
  }

  AuthUC(this._authRepository);

  AuthUser get currentUser => _authRepository.currentUser;

  Stream<AuthUser> get user => _authRepository.user;

  Future<Either<Failure, AuthUser>> logIn(
      {required String email, required String password}) async {
    return await _authRepository.logIn(email: email, password: password);
  }

  Future<Either<Failure, AuthUser>> createUser(
      {
    required String fullName,
    required String address,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    return await _authRepository.createUser(
      fullName: fullName,
      address: address,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
    );
  }

  Future<Either<Failure, Success>> verifyEmail() async {
    return await _authRepository.verifyEmail();
  }

  Future<Either<Failure, Success>> resetPassword({required String email}) async {
    return await _authRepository.resetPassword(email: email);
  }

  Future<Either<Failure, Success>> signOut() async {
    return await _authRepository.signOut();
  }

  Stream<KaisaUser> userStream({required String userId}) {
    return _authRepository.userStream(userId: userId);
  }

  Future<Either<Failure, Success>> deleteAccount() {
    return _authRepository.deleteAccount();
  }
}
