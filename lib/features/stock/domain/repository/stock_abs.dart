import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure_n_success.dart';
import '../entity/stock_item_entity.dart';

abstract class StockAbs {
  Future<Either<Failure, List<StockItemEntity>>> fetchStockItems();
}
