import 'package:get/get.dart';
import 'package:kaisa/core/errors/failure_n_success.dart';

import '../../domain/entity/stock_item_entity.dart';
import '../../domain/usecase/stock_usecase.dart';

class StockCtrl extends GetxController {
  final StockUsecase stockUsecase;
  StockCtrl(this.stockUsecase);

  var requestInProgress = false.obs;
  Failure? requestFailure;

  final _stockItems = <StockItemEntity>[].obs;
  List<StockItemEntity> get stockItems => _stockItems;
  set stockItems(List<StockItemEntity> value) => _stockItems.value = value;

  var _selStockItem = StockItemEntity.empty;
  StockItemEntity get selStockItem => _selStockItem;
  set stockItem(StockItemEntity value) => _selStockItem = value;

  void fetchStockItems() async{
    requestFailure = null;
    requestInProgress.value = true;

    final result = await stockUsecase.fetchStockItems();

    result.fold(
      (failure) => requestFailure = failure,
      (stockItems) => this.stockItems = stockItems,
    );

    requestInProgress.value = false;
  }
}
