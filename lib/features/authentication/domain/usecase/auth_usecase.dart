import 'package:dartz/dartz.dart';


import '../../../../core/errors/failure_n_success.dart';
import '../entity/auth_user.dart';
import '../repository/auth_repo.dart';

class AuthUC {
  final AuthRepository _authRepository;

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
    required String password,
  }) async {
    return await _authRepository.createUser(
      fullName: fullName,
      address: address,
      email: email,
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
}
