import 'package:get/get.dart';
import 'package:kaisa/core/errors/failure_n_success.dart';

import '../../../../core/datasources/firestore/models/phone-transaction/phone_transaction.dart';
import '../../domain/entity/stock_item_entity.dart';
import '../../domain/usecase/stock_usecase.dart';

class StockCtrl extends GetxController {
  final StockUsecase stockUsecase;
  StockCtrl(this.stockUsecase);

  PhoneTransaction phoneTransaction = PhoneTransaction.empty;

  var requestInProgress1 = false.obs;
  var requestInProgress2 = false.obs;
  Failure? requestFailure;

  /* -------------------------------------------------------------------------- */

  final _stockItems = <StockItemEntity>[].obs;
  List<StockItemEntity> get stockItems => _stockItems;
  set stockItems(List<StockItemEntity> value) => _stockItems.value = value;

  var _selStockItem = StockItemEntity.empty;
  StockItemEntity get selStockItem => _selStockItem;
  set stockItem(StockItemEntity value) => _selStockItem = value;

  void fetchStockItems(String uuid) async {
    requestFailure = null;
    requestInProgress1.value = true;

    final result = await stockUsecase.fetchStockItems(uuid);

    result.fold(
      (failure) => requestFailure = failure,
      (stks) {
        // sort the stock items that have been fetched
        // let the unsold items come first
        stks.sort((a, b) {
          if (a.isSold == b.isSold) {
            return 0;
          } else if (a.isSold) {
            return 1;
          } else {
            return -1;
          }
        });

        stockItems = stks;
      },
    );

    requestInProgress1.value = false;
  }

  /* -------------------------------------------------------------------------- */

  Failure? sendOrderFailure;
  Success? sendOrderSuccess;
  Future<void> sendOrder() async {
    sendOrderFailure = null;
    requestInProgress2.value = true;

    final successOrFailure =
        await stockUsecase.sendOrder(phoneTransaction: phoneTransaction);

    successOrFailure.fold(
      (failure) => sendOrderFailure = failure,
      (success) {
        sendOrderSuccess = success;
        _stockItems.removeWhere((element) => element == _selStockItem);
      },
    );

    requestInProgress2.value = false;
  }

  void reset1() {
    phoneTransaction = PhoneTransaction.empty;
    sendOrderSuccess = null;
    sendOrderFailure = null;
  }
}
