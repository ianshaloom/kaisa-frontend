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

  var kaisaShopsList = <KaisaUser>[].obs;
  var phoneTransaction = <PhoneTransaction>[].obs;

  // selected objects
  SmartphoneEntity selectedPhone = SmartphoneEntity.empty;
  PhoneTransaction selectedTransaction = PhoneTransaction.empty;

  // selected shop details
  var selectedShopId = ''.obs;
  var selectedShopName = ''.obs;
  var selectedShopAddress = ''.obs;
  set setSelectedShopDetails(KaisaUser selectedShop) {
    selectedShopId.value = selectedShop.uuid;
    selectedShopName.value = selectedShop.fullName;
    selectedShopAddress.value = selectedShop.shop;
  }

  bool get isShopEmpty => selectedShopName.isEmpty;

  // actions performed on grid tile tap event
  void clearSelectedShop(SmartphoneEntity smartphone) {
    selectedShopId.value = '';
    selectedShopName.value = '';
    selectedShopAddress.value = '';
    barcode.value = '';
    selectedPhone = smartphone;
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
        await _phoneTransactionUseCase.cancelPhoneTransaction(
      phoneTransaction: beingCancelled,
    );

    phoneTransactionOrFailure.fold(
      (failure) => cancelFailure = failure,
      (phoneTransaction) => null,
    );

    processingRequestOne.value = false;
  }

  // stream phone transactions by id
  Stream<List<PhoneTransaction>> streamKOrderTranscById(String uuid) {
    return _phoneTransactionUseCase.streamKOrderTranscById(uuid);
  }

  // stream a single phone transaction by id
  Stream<PhoneTransaction> streamSingleKOrderTransc() {
    return _phoneTransactionUseCase.streamSingleKOrderTransc(userData.uuid);
  }

  //  dellay 2 seconds
  Future<void> delayTwoSeconds(List<PhoneTransaction> trans) async {
    await Future.delayed(const Duration(seconds: 3));
    phoneTransaction.assignAll(trans);
  }

// scan barcode
  var barcode = ''.obs;
  var isValidated = false;
}
