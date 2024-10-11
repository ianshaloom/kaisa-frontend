import 'package:dartz/dartz.dart';
import 'package:kaisa/core/datasources/firestore/models/stock/stock_item_entity.dart';
import 'package:kaisa/core/errors/failure_n_success.dart';
import 'package:kaisa/features/receipt/domain/entity/receipt_entity.dart';

import '../../core/datasources/firestore/models/phone-transaction/phone_transaction.dart';

abstract class ShopAbs {
  Future<Either<Failure, List<PhoneTransaction>>> fetchKOrderTranscsById(List<String> ids);
  Future<Either<Failure, List<StockItemEntity>>> fetchShopStock(String shopId);
  Future<Either<Failure, List<ReceiptEntity>>> fetchShopReceipts(String shopId);
}

