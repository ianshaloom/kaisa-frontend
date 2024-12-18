import 'package:dartz/dartz.dart';

import '../../../../core/datasources/firestore/models/phone-transaction/phone_transaction.dart';
import '../../../../core/errors/failure_n_success.dart';
import '../entity/stock_item_entity.dart';
import '../repository/stock_abs.dart';

class StockUsecase {
  final StockAbs stockAbs;
  StockUsecase(this.stockAbs);

  Future<Either<Failure, List<StockItemEntity>>> fetchStockItems(String uuid) {
    return stockAbs.fetchStockItems(uuid);
  }

  Future<Either<Failure, Success>> sendOrder(
      {required PhoneTransaction phoneTransaction}) {
    return stockAbs.sendOrder(phoneTransaction: phoneTransaction);
  }
}
