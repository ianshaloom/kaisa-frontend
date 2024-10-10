import 'package:get/get.dart';
import 'package:kaisa/shared/shared_abs_impl.dart';
import 'package:kaisa/shared/shared_usecase.dart';

import '../features/homepage/presentation/controller/homepagectrl.dart';
import '../features/phonetransaction/data/provider/network/firestore_phone_transaction_ds.dart';
import '../features/phonetransaction/data/provider/network/firestore_smartphone_ds.dart';
import '../features/phonetransaction/data/repository/phone_transaction_repo_impl.dart';
import '../features/phonetransaction/data/repository/smartphones_repo_impl.dart';
import '../features/phonetransaction/domain/usecase/phone_transaction_usecase.dart';
import '../features/phonetransaction/domain/usecase/smartphones_usecase.dart';
import '../features/phonetransaction/presentation/controller/phone_transaction_ctrl.dart';
import '../features/phonetransaction/presentation/controller/smartphones_ctrl.dart';
import '../features/phonetransaction/presentation/controller/transac_history_ctrl.dart';
import '../features/receipt/data/provider/network/firestore_receipt_ds.dart';
import '../features/receipt/data/repository/receipt_abs_impl.dart';
import '../features/receipt/domain/usecase/receipt_usecase.dart';
import '../features/receipt/presentation/controller/receipt_ctrl.dart';
import '../features/shop/presentation/controller/shop_ctrl.dart';
import '../features/stock/data/provider/network/firestore_stock_ds.dart';
import '../features/stock/data/repository/stock_abs_impl.dart';
import '../features/stock/domain/usecase/stock_usecase.dart';
import '../features/stock/presentation/controller/stock_ctrl.dart';
import 'shared_ctrl.dart';

class SharedCtrlBind extends Bindings {
  @override
  void dependencies() {
    Get.put(SharedCtrl(SharedUsecase(SharedAbsImpl())));
    Get.put(HomePageCtrl());
    Get.put(
      PhoneTransactionCtrl(
        PhoneTransactionUsecase(
          PhoneTransactionRepoImpl(FirestoreKOrderTransc()),
        ),
      ),
    );
    Get.lazyPut(() => ShopCtrl());
    Get.lazyPut<ReceiptCtrl>(
      () => ReceiptCtrl(
        ReceiptUsecase(
          ReceiptAbsImpl(FirestoreReceiptDs()),
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
