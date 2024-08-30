import 'package:dartz/dartz.dart';

import '../../../../core/datasources/firestore/models/kaisa-user/kaisa_user.dart';
import '../../../../core/datasources/firestore/models/phone-transaction/phone_transaction.dart';
import '../../../../core/errors/failure_n_success.dart';

abstract class PhoneTransactionRepo {
  // new Phone Transaction
  Future<Either<Failure, void>> newPhoneTransaction(
      {required PhoneTransaction phoneTransaction});

  // complete Phone Transaction
  Future<Either<Failure, void>> completePhoneTransaction(
      {required PhoneTransaction phoneTransaction});

  // cancel Phone Transaction
  Future<Either<Failure, void>> cancelPhoneTransaction(
      {required PhoneTransaction phoneTransaction});

  // fetch Phone Transactions
  Future<Either<Failure, List<PhoneTransaction>>> fetchPhoneTransactions();


  // fetch Users
  Future<Either<Failure, List<KaisaUser>>> fetchUsers();

}