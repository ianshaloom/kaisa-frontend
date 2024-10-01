import 'package:get/get.dart';

import '../../../../core/datasources/firestore/models/kaisa-user/kaisa_user.dart';
import '../../../../core/datasources/firestore/models/phone-transaction/phone_transaction.dart';
import '../../../../core/errors/failure_n_success.dart';
import '../../domain/entity/smartphone_entity.dart';
import '../../domain/usecase/phone_transaction_usecase.dart';

class PhoneTransactionCtrl extends GetxController {
  final PhoneTransactionUsecase _phoneTransactionUseCase;
  PhoneTransactionCtrl(this._phoneTransactionUseCase);

  KaisaUser userData = KaisaUser.empty;

  var processingRequestOne = false.obs;
  var processingRequestTwo = false.obs; // used in [fetchPhoneTransactions]
  var actionFromTH = false;

  var requestFailure = <Failure>[];

  var phoneTransaction = <PhoneTransaction>[].obs;

  // selected objects
  SmartphoneEntity _selectedPhone = SmartphoneEntity.empty;
  SmartphoneEntity get selectedPhone => _selectedPhone;
  set newPhone(SmartphoneEntity value) => _selectedPhone = value;

  PhoneTransaction selectedTransaction = PhoneTransaction.empty;

  // actions performed on grid tile tap event
  void clearCode() {
    barcode.value = '';
  }

  //  new phone transaction
  Failure? newFailure;
  PhoneTransaction beingAdded = PhoneTransaction.empty;
  Future<void> newPhoneTransaction() async {
    newFailure = null;
    processingRequestOne.value = true;

    final phoneTransactionOrFailure = await _phoneTransactionUseCase.sendKOrder(
      phoneTransaction: beingAdded,
    );

    phoneTransactionOrFailure.fold(
      (failure) => newFailure = failure,
      (phoneTransaction) => null,
    );

    processingRequestOne.value = false;
  }

  // complete phone transaction
  Failure? completedFailure;
  PhoneTransaction beingCompleted = PhoneTransaction.empty;
  Future<void> completePhoneTransaction() async {
    completedFailure = null;
    processingRequestOne.value = true;

    final phoneTransactionOrFailure =
        await _phoneTransactionUseCase.completePhoneTransaction(
      phoneTransaction: beingCompleted,
    );

    phoneTransactionOrFailure.fold(
      (failure) => completedFailure = failure,
      (phoneTransaction) => null,
    );

    processingRequestOne.value = false;
  }

  // cancel phone transaction
  Failure? cancelFailure;
  PhoneTransaction beingCancelled = PhoneTransaction.empty;
  Future<void> cancelPhoneTransaction() async {
    cancelFailure = null;
    processingRequestOne.value = true;

    final phoneTransactionOrFailure =
        await _phoneTransactionUseCase.cancelKOrder(
      phoneTransaction: beingCancelled,
    );

    phoneTransactionOrFailure.fold(
      (failure) => cancelFailure = failure,
      (phoneTransaction) => null,
    );

    processingRequestOne.value = false;
  }

  // stream phone transactions by id
  Stream<List<PhoneTransaction>> streamKOrderTranscById() {
    return _phoneTransactionUseCase.streamKOrderTransc();
  }

  // stream a single phone transaction by id
  Stream<PhoneTransaction> streamSingleKOrderTransc() {
    return _phoneTransactionUseCase.streamSingleKOrderTransc(userData.uuid);
  }

// scan barcode
  var barcode = ''.obs;
  var isValidated = false;
}
