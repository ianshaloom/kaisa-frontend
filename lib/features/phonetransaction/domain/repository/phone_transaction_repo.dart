import 'package:dartz/dartz.dart';

import '../../../../core/datasources/firestore/models/phone-transaction/phone_transaction.dart';
import '../../../../core/errors/failure_n_success.dart';

abstract class PhoneTransactionRepo {

  // complete Phone Transaction
  Future<Either<Failure, void>> completePhoneTransaction(
      {required PhoneTransaction phoneTransaction});

  // cancel Phone Transaction
  Future<Either<Failure, void>> cancelPhoneTransaction(
      {required PhoneTransaction phoneTransaction});

  // fetch Phone Transactions
  Future<Either<Failure, List<PhoneTransaction>>> fetchPhoneTransactions();

  // stream Phone Transactions by id
  Stream<List<PhoneTransaction>> streamKOrderTranscById(String userId);

  // stream a single Phone Transaction by id
  Stream<PhoneTransaction> streamSingleKOrderTransc(String uuid);
  

}