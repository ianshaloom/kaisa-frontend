import 'package:dartz/dartz.dart';

import '../../core/datasources/firestore/models/phone-transaction/phone_transaction.dart';
import '../../core/datasources/firestore/models/stock/stock_item_entity.dart';
import '../../core/errors/cloud_storage_exceptions.dart';
import '../../core/errors/failure_n_success.dart';
import '../../shared/shared_failure_success.dart';
import '../receipt/domain/entity/receipt_entity.dart';
import 'shop_abs.dart';
import 'shop_ds.dart';

class ShopAbsImpl implements ShopAbs {
  final ShopDs shopDs;

  ShopAbsImpl(this.shopDs);

  @override
  Future<Either<Failure, List<PhoneTransaction>>> fetchKOrderTranscsById(
      List<String> ids) async {
    try {
      final r = await shopDs.fetchKOrderTranscById(ids);

      final phoneTransactions =
          r.map((doc) => PhoneTransaction.fromJson(doc)).toList();

      return Right(phoneTransactions);
    } on CouldNotFetchException catch (e) {
      return Left(SharedFailure(errorMessage: e.message));
    }
  }

  @override
  Future<Either<Failure, List<StockItemEntity>>> fetchShopStock(
      String shopId) async {
    try {
      final r = await shopDs.fetchShopStock(shopId);

      final stockItems = r.map((doc) => StockItemEntity.fromJson(doc)).toList();

      return Right(stockItems);
    } on CouldNotFetchException catch (e) {
      return Left(SharedFailure(errorMessage: e.message));
    }
  }

  @override
  Future<Either<Failure, List<ReceiptEntity>>> fetchShopReceipts(
      String shopId) async {
    try {
      final r = await shopDs.fetchShopReceipts(shopId);

      final receipts = r.map((doc) => ReceiptEntity.fromJson(doc)).toList();

      return Right(receipts);
    } on CouldNotFetchException catch (e) {
      return Left(SharedFailure(errorMessage: e.message));
    }
  }
}
