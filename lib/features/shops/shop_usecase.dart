import 'package:dartz/dartz.dart';

import '../../core/datasources/firestore/models/phone-transaction/phone_transaction.dart';
import '../../core/datasources/firestore/models/stock/stock_item_entity.dart';
import '../../core/errors/failure_n_success.dart';
import '../receipt/domain/entity/receipt_entity.dart';
import 'shop_abs.dart';

class ShopUsecase {
  final ShopAbs _shopAbs;
  ShopUsecase(this._shopAbs);

  Future<Either<Failure, List<PhoneTransaction>>> fetchKOrderTranscsById(
      List<String> ids) async {
    return await _shopAbs.fetchKOrderTranscsById(ids);
  }

  Future<Either<Failure, List<StockItemEntity>>> fetchShopStock(
      String shopId)  async {
    return await _shopAbs.fetchShopStock(shopId);
  }

  Future<Either<Failure, List<ReceiptEntity>>> fetchShopReceipts(
      String shopId) async {
    return await _shopAbs.fetchShopReceipts(shopId);
  }
}