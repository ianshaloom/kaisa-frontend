import 'package:get/get.dart';

import '../../data/provider/network/firestore_phone_transaction_ds.dart';
import '../../data/provider/network/firestore_smartphone_ds.dart';
import '../../data/repository/phone_transaction_repo_impl.dart';
import '../../data/repository/smartphones_repo_impl.dart';
import '../../domain/usecase/phone_transaction_usecase.dart';
import '../../domain/usecase/smartphones_usecase.dart';
import 'phone_transaction_ctrl.dart';
import 'smartphones_ctrl.dart';
import 'transac_history_ctrl.dart';

class PhoneTransitBind extends Bindings {
  @override
  void dependencies() {
    Get.put(
      () => PhoneTransactionCtrl(
        PhoneTransactionUsecase(
          PhoneTransactionRepoImpl(FirestoreKOrderTransc()),
        ),
      ),
    );

    Get.lazyPut<SmartphonesCtrl>(
      () => SmartphonesCtrl(
        SmartphonesUsecase(
          SmartphonesRepoImpl(FirestoreSmartPhoneDs()),
        ),
      ),
    );

    Get.lazyPut<TransacHistoryCtrl>(
      () => TransacHistoryCtrl(
        PhoneTransactionUsecase(
          PhoneTransactionRepoImpl(FirestoreKOrderTransc()),
        ),
      ),
    );
  }
}
