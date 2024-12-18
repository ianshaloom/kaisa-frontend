import 'package:dartz/dartz.dart';

import '../../core/errors/failure_n_success.dart';
import '../../shared/shared_models.dart';
import '../feature-receipts/f_receipt.dart';

abstract class ShopAbs {
  Future<Either<Failure, List<ReceiptEntity>>> fetchWeeklySales(String uuid);
  Future<Either<Failure, List<ShopAnalysis>>> fetchSalesRank();
}