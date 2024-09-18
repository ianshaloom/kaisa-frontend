import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure_n_success.dart';
import '../entity/stock_item_entity.dart';
import '../repository/stock_abs.dart';

class StockUsecase {
  final StockAbs stockAbs;
  StockUsecase(this.stockAbs);

  Future<Either<Failure, List<StockItemEntity>>> fetchStockItems() {
    return stockAbs.fetchStockItems();
  }
}