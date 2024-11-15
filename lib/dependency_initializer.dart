import 'dart:async';

import 'package:get/get.dart';
import 'package:kaisa/features/homepage/presentation/controller/homepagectrl.dart';

import 'features/authentication/data/provider/network/authentication_ds.dart';
import 'features/authentication/data/repository/auth_repo_impl.dart';
import 'features/authentication/domain/usecase/auth_usecase.dart';
import 'features/authentication/presentation/controller/authrepo_controller.dart';
import 'features/feature-receipts/f_receipt_abs_impl.dart';
import 'features/feature-receipts/f_receipt_ctrl.dart';
import 'features/feature-receipts/f_receipt_ds.dart';
import 'features/feature-receipts/f_receipt_usc.dart';
import 'features/phonetransaction/data/provider/network/firestore_phone_transaction_ds.dart';
import 'features/phonetransaction/data/provider/network/firestore_smartphone_ds.dart';
import 'features/phonetransaction/data/repository/phone_transaction_repo_impl.dart';
import 'features/phonetransaction/data/repository/smartphones_repo_impl.dart';
import 'features/phonetransaction/domain/usecase/phone_transaction_usecase.dart';
import 'features/phonetransaction/domain/usecase/smartphones_usecase.dart';
import 'features/phonetransaction/presentation/controller/phone_transaction_ctrl.dart';
import 'features/phonetransaction/presentation/controller/smartphones_ctrl.dart';
import 'features/phonetransaction/presentation/controller/transac_history_ctrl.dart';
import 'features/shop/shop_abs_impl.dart';
import 'features/shop/shop_ctrl.dart';
import 'features/shop/shop_usecase.dart';
import 'features/stock/data/provider/network/firestore_stock_ds.dart';
import 'features/stock/data/repository/stock_abs_impl.dart';
import 'features/stock/domain/usecase/stock_usecase.dart';
import 'features/stock/presentation/controller/stock_ctrl.dart';
import 'shared/shared_abs_impl.dart';
import 'shared/shared_ctrl.dart';
import 'shared/shared_usecase.dart';

FutureOr<void> init() async {
  DependencyBinder().dependencies();
}

class DependencyBinder extends Bindings {
  @override
  void dependencies() {

    Get.put(SharedCtrl(SharedUsecase(SharedAbsImpl())));

    Get.lazyPut(() => HomePageCtrl());

    Get.put(
      PhoneTransactionCtrl(
        PhoneTransactionUsecase(
          PhoneTransactionRepoImpl(FirestoreKOrderTransc()),
        ),
      ),
    );

    Get.lazyPut<AuthUC>(
      () => AuthUC(
        AuthRepoImpl(
          FirebaseAuthentification(),
        ),
      ),
    );
    Get.lazyPut<AuthController>(
      () => AuthController(
        Get.find<AuthUC>(),
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

    Get.lazyPut<StockCtrl>(
      () => StockCtrl(
        StockUsecase(
          StockAbsImpl(FirestoreStockDs()),
        ),
      ),
    );

    Get.lazyPut<FReceiptCtrl>(
      () => FReceiptCtrl(
        FReceiptUsecase(
          FReceiptAbsImpl(FReceiptDs()),
        ),
      ),
    );

    Get.lazyPut<ShopCtrl>(
      () => ShopCtrl(
        ShopUsecase(
          ShopAbsImpl(),
        ),
      ),
    );


  }
}
