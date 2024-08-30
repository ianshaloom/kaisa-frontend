import 'package:get/get.dart';
import 'package:kaisa/core/utils/extension_methods.dart';

import '../../../../core/datasources/firestore/models/kaisa-user/kaisa_user.dart';
import '../../../../core/datasources/firestore/models/phone-transaction/phone_transaction.dart';
import '../../../../core/errors/failure_n_success.dart';
import '../../../homepage/presentation/controller/homepagectrl.dart';
import '../../domain/entity/smartphone_entity.dart';
import '../../domain/usecase/phone_transaction_usecase.dart';

final _homePageCtrl = Get.find<HomePageCtrl>();

class PhoneTransactionCtrl extends GetxController {
  final PhoneTransactionUsecase _phoneTransactionUseCase;
  PhoneTransactionCtrl(this._phoneTransactionUseCase);

  var processingRequestOne = false.obs;
  var processingRequestTwo = false.obs; // used in [fetchPhoneTransactions]

  var requestFailure = <Failure>[].obs;
  var kaisaShopsList = <KaisaUser>[].obs;
  var phoneTransaction = <PhoneTransaction>[].obs;
  var todaysTranscs = <PhoneTransaction>[].obs;

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
    selectedShopAddress.value = selectedShop.address;
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

  KaisaUser get getMyProfile {
    final id = _homePageCtrl.userData.uuid;
    return kaisaShopsList.firstWhere((element) => element.uuid == id);
  }

  // get my profile details

  Future<void> fetchUsers() async {
    requestFailure.clear();
    processingRequestOne.value = true;

    final usersOrFailure = await _phoneTransactionUseCase.fetchUsers();

    usersOrFailure.fold(
      (failure) => requestFailure.add(failure),
      (users) => kaisaShopsList.assignAll(users),
    );

    processingRequestOne.value = false;
  }

  //  new phone transaction
  Future<void> newPhoneTransaction(
      {required PhoneTransaction transaction}) async {
    requestFailure.clear();
    processingRequestOne.value = true;

    final phoneTransactionOrFailure =
        await _phoneTransactionUseCase.newPhoneTransaction(
      phoneTransaction: transaction,
    );

    phoneTransactionOrFailure.fold(
      (failure) => requestFailure.add(failure),
      (phoneTransaction) {},
    );

    processingRequestOne.value = false;
  }

  // complete phone transaction
  Future<void> completePhoneTransaction(
      {required PhoneTransaction transaction}) async {
    requestFailure.clear();
    processingRequestOne.value = true;

    final phoneTransactionOrFailure =
        await _phoneTransactionUseCase.completePhoneTransaction(
      phoneTransaction: transaction,
    );

    phoneTransactionOrFailure.fold(
      (failure) => requestFailure.add(failure),
      (phoneTransaction) {},
    );

    processingRequestOne.value = false;
  }

  // cancel phone transaction
  Future<void> cancelPhoneTransaction(
      {required PhoneTransaction transaction}) async {
    requestFailure.clear();
    processingRequestOne.value = true;

    final phoneTransactionOrFailure =
        await _phoneTransactionUseCase.cancelPhoneTransaction(
      phoneTransaction: transaction,
    );

    phoneTransactionOrFailure.fold(
      (failure) => requestFailure.add(failure),
      (phoneTransaction) {},
    );

    processingRequestOne.value = false;
  }

  // get all phone transactions
  Future<void> fetchPhoneTransactions() async {
    requestFailure.clear();
    processingRequestTwo.value = true;

    final phoneTransactionsOrFailure =
        await _phoneTransactionUseCase.fetchPhoneTransactions();

    phoneTransactionsOrFailure.fold(
      (failure) => requestFailure.add(failure),
      (phoneTransactions) {
        phoneTransactions.sort((b, a) => a.createdAt.compareTo(b.createdAt));
        
        var trans = phoneTransactions.todaysPhoneTransactions();
        todaysTranscs.assignAll(trans);

        phoneTransaction.assignAll(phoneTransactions);
      },
    );

    processingRequestTwo.value = false;
  }

// scan barcode
  var barcode = ''.obs;
}
