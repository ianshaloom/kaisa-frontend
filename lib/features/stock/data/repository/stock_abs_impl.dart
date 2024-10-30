import 'package:dartz/dartz.dart';

import '../../../../core/connection/network_info.dart';
import '../../../../core/datasources/firestore/models/phone-transaction/phone_transaction.dart';
import '../../../../core/errors/failure_n_success.dart';
import '../../domain/entity/stock_item_entity.dart';
import '../../domain/repository/stock_abs.dart';
import '../../../../core/errors/cloud_storage_exceptions.dart';
import '../core/error/stock_failure_success.dart';
import '../provider/network/firestore_stock_ds.dart';

class StockAbsImpl extends StockAbs {
  StockAbsImpl(this._firestoreStockDs);
  final FirestoreStockDs _firestoreStockDs;

  @override
  Future<Either<Failure, List<StockItemEntity>>> fetchStockItems(
      String uuid) async {
    try {
      final stockItems = await _firestoreStockDs.fetchStock(uuid);
      return Future.value(Right(stockItems));
    } on CouldNotFetchException catch (e) {
      return Future.value(Left(StockFailure(errorMessage: e.toString())));
    }
  }

  @override
  Future<Either<Failure, Success>> sendOrder(
      {required PhoneTransaction phoneTransaction}) async {
    final bool isConnected = await NetworkInfo.connectionChecker.hasConnection;

    if (!isConnected) {
      return Left(
        StockFailure(errorMessage: 'You have no internet connection 🚩'),
      );
    }

    try {
      await _firestoreStockDs.sendOrder(phoneTransaction.toJson());

      return  Right(StockSuccess(successContent: 'Order sent successfully'));
    } on CouldNotCreateException catch (e) {
      return Left(StockFailure(errorMessage: e.message));
    } on GenericException catch (e) {
      return Left(StockFailure(errorMessage: e.message));
    }
  }
}
