import 'package:dartz/dartz.dart';

import 'package:kaisa/core/datasources/firestore/models/kaisa-user/kaisa_user.dart';

import 'package:kaisa/core/datasources/firestore/models/phone-transaction/phone_transaction.dart';

import 'package:kaisa/core/errors/failure_n_success.dart';

import '../../../../core/connection/network_info.dart';
import '../../../../core/datasources/firestore/crud/kaisa_users_ds.dart';
import '../../domain/repository/phone_transaction_repo.dart';
import '../core/errors/phone_transactions_exception.dart';
import '../core/errors/smartphone_success_n_failures.dart';
import '../provider/network/firestore_phone_transaction_ds.dart';

class PhoneTransactionRepoImpl implements PhoneTransactionRepo {
  final FirestorePhoneTransactionDs _firestorePhoneTransactionDs;

  PhoneTransactionRepoImpl(this._firestorePhoneTransactionDs);

  @override
  Future<Either<Failure, void>> cancelPhoneTransaction(
      {required PhoneTransaction phoneTransaction}) async{

        final bool isConnected = await NetworkInfo.connectionChecker.hasConnection;

    if (!isConnected) {
      return Left(
          PhoneTransactionFailure(errorMessage: 'No internet connection'));
    }

    try {
      await _firestorePhoneTransactionDs.cancelPhoneTransaction(
          phoneTransaction: phoneTransaction);

      return const Right(null);
    } on CouldNotUpdateTrans catch (e) {
      return Left(PhoneTransactionFailure(errorMessage: e.message));
    }    
    
  }

  @override
  Future<Either<Failure, List<PhoneTransaction>>> fetchPhoneTransactions() async{

    try {
      final phoneTransactions =
          await _firestorePhoneTransactionDs.getPhoneTransactionsById();

      return Right(phoneTransactions);
    } on CouldNotFetchTrans catch (e) {
      return Left(PhoneTransactionFailure(errorMessage: e.message));
    }
    
  }

  @override
  Future<Either<Failure, List<KaisaUser>>> fetchUsers() async {
    try {
      final users = await FirestoreUsersDs.fetchUsers();

      return Right(users);
    }  catch (e) {
      return Left(PhoneTransactionFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> newPhoneTransaction(
      {required PhoneTransaction phoneTransaction}) async {
    final bool isConnected = await NetworkInfo.connectionChecker.hasConnection;

    if (!isConnected) {
      return Left(
          PhoneTransactionFailure(errorMessage: 'No internet connection'));
    }

    try {
      await _firestorePhoneTransactionDs.newPhoneTransaction(
          phoneTransaction: phoneTransaction);

      return const Right(null);
    } on CouldNotCreateTrans catch (e) {
      return Left(PhoneTransactionFailure(errorMessage: e.message));
    }
  }

  @override
 Future<Either<Failure, void>> completePhoneTransaction(
      {required PhoneTransaction phoneTransaction}) async {
    final bool isConnected = await NetworkInfo.connectionChecker.hasConnection;

    if (!isConnected) {
      return Left(
          PhoneTransactionFailure(errorMessage: 'No internet connection'));
    }

    try {
      await _firestorePhoneTransactionDs.completePhoneTransaction(
          phoneTransaction: phoneTransaction);

      return const Right(null);
    } on CouldNotUpdateTrans catch (e) {
      return Left(PhoneTransactionFailure(errorMessage: e.message));
    }
  }

}
