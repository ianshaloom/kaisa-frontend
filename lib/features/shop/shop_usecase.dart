import 'package:dartz/dartz.dart';

import '../../core/errors/failure_n_success.dart';
import '../../shared/shared_models.dart';
import '../feature-receipts/f_receipt.dart';
import 'shop_abs.dart';

class ShopUsecase {
  final ShopAbs shopAbs;
  ShopUsecase(this.shopAbs);
  
  Future<Either<Failure, List<ReceiptEntity>>> fetchWeeklySales(String uuid) async {
    return shopAbs.fetchWeeklySales(uuid);
  }

  Future<Either<Failure, List<ShopAnalysis>>> fetchSalesRank() async {
    return shopAbs.fetchSalesRank();
  }

}