import 'package:dartz/dartz.dart';

import '../../../../core/datasources/firestore/models/phone-transaction/phone_transaction.dart';
import '../../../../core/errors/failure_n_success.dart';

abstract class PhoneTransactionRepo {
  // new Phone Transaction
  Future<Either<Failure, void>> sendKOrder(
      {required PhoneTransaction phoneTransaction});

  // complete Phone Transaction
  Future<Either<Failure, void>> receiveKOrder(
      {required PhoneTransaction phoneTransaction});

  // cancel Phone Transaction
  Future<Either<Failure, void>> cancelKOrder(
      {required PhoneTransaction phoneTransaction});

  // fetch Phone Transactions
  Future<Either<Failure, List<PhoneTransaction>>> fetchPhoneTransactions();

  // stream Phone Transactions by id
  Stream<List<PhoneTransaction>> streamKOrderTransc();

  // stream a single Phone Transaction by id
  Stream<PhoneTransaction> streamSingleKOrderTransc(String uuid);
}
