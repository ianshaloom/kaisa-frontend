import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure_n_success.dart';
import '../../domain/entity/stock_item_entity.dart';
import '../../domain/repository/stock_abs.dart';
import '../../../../core/errors/cloud_storage_exceptions.dart';
import '../core/error/stock_failure_success.dart';
import '../provider/network/firestore_stock_ds.dart';

class StockAbsImpl extends StockAbs {
  StockAbsImpl(this.firestoreStockDs);
  final FirestoreStockDs firestoreStockDs;
  
  @override
  Future<Either<Failure, List<StockItemEntity>>> fetchStockItems() async {
    try {
      final stockItems = await firestoreStockDs.fetchStock();
      return Future.value(Right(stockItems));
    } on CouldNotFetchException catch (e) {
      return Future.value(Left(StockFailure(errorMessage: e.toString())));
    }
  }
}
