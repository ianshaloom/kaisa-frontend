import 'package:dartz/dartz.dart';


import '../../../../core/errors/failure_n_success.dart';
import '../../../../core/datasources/firestore/models/stock/stock_item_entity.dart';
import '../../domain/repository/stock_abs.dart';
import '../../../../core/errors/cloud_storage_exceptions.dart';
import '../core/error/stock_failure_success.dart';
import '../provider/network/firestore_stock_ds.dart';

class StockAbsImpl extends StockAbs {
  StockAbsImpl(this._firestoreStockDs);
  final FirestoreStockDs _firestoreStockDs;

  @override
  Future<Either<Failure, List<StockItemEntity>>> fetchStockItems() async {
    try {
      final stockItems = await _firestoreStockDs.fetchStock();

      final List<StockItemEntity> stock = stockItems
          .map((stockItem) => StockItemEntity.fromJson(stockItem))
          .toList();

      return Future.value(Right(stock));
    } on CouldNotFetchException catch (e) {
      return Future.value(Left(StockFailure(errorMessage: e.toString())));
    }
  }
}
