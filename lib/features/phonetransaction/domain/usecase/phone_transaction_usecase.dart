import 'package:dartz/dartz.dart';

import '../../../../core/datasources/firestore/models/phone-transaction/phone_transaction.dart';
import '../repository/phone_transaction_repo.dart';
import '../../../../core/errors/failure_n_success.dart';

class PhoneTransactionUsecase {
  final PhoneTransactionRepo _phoneTransactionRepo;

  PhoneTransactionUsecase(this._phoneTransactionRepo);

  // complete phone transaction
  Future<Either<Failure, void>> completePhoneTransaction(
      {required PhoneTransaction phoneTransaction}) async {
    return await _phoneTransactionRepo.completePhoneTransaction(phoneTransaction: phoneTransaction);
  }

  // cancel phone transaction
  Future<Either<Failure, void>> cancelPhoneTransaction(
      {required PhoneTransaction phoneTransaction}) async {
    return await _phoneTransactionRepo.cancelPhoneTransaction(phoneTransaction: phoneTransaction);
  }

  // fetch phone transactions
  Future<Either<Failure, List<PhoneTransaction>>> fetchPhoneTransactions() async {
    return await _phoneTransactionRepo.fetchPhoneTransactions();
  }

  // stream phone transactions by id
  Stream<List<PhoneTransaction>> streamKOrderTranscById(String userId) {
    return _phoneTransactionRepo.streamKOrderTranscById(userId);
  }

  // stream a single phone transaction by id
  Stream<PhoneTransaction> streamSingleKOrderTransc(String uuid) {
    return _phoneTransactionRepo.streamSingleKOrderTransc(uuid);
  }


}