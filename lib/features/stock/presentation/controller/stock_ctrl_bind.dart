import 'package:get/get.dart';

import '../../data/provider/network/firestore_stock_ds.dart';
import '../../data/repository/stock_abs_impl.dart';
import '../../domain/usecase/stock_usecase.dart';
import 'stock_ctrl.dart';

class StockCtrlBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StockCtrl>(
      () => StockCtrl(
        StockUsecase(
          StockAbsImpl(FirestoreStockDs()),
        ),
      ),
    );
  }
}
