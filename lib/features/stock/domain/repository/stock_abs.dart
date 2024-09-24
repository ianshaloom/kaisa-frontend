import 'package:dartz/dartz.dart';

import '../../../../core/datasources/firestore/models/phone-transaction/phone_transaction.dart';
import '../../../../core/errors/failure_n_success.dart';
import '../entity/stock_item_entity.dart';

abstract class StockAbs {
  Future<Either<Failure, List<StockItemEntity>>> fetchStockItems();
  Future<Either<Failure, Success>> sendOrder(
      {required PhoneTransaction phoneTransaction});
}
