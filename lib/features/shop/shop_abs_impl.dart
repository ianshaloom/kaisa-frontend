import 'package:dartz/dartz.dart';
import 'package:kaisa/features/shop/shop_ds.dart';

import '../../core/connection/network_info.dart';
import '../../core/errors/cloud_storage_exceptions.dart';
import '../../core/errors/failure_n_success.dart';
import '../../shared/shared_models.dart';
import '../feature-receipts/f_receipt.dart';
import 'shop_abs.dart';
import 'shop_errors.dart';

class ShopAbsImpl implements ShopAbs {
  final ShopDs shopDs = ShopDs();

  @override
  Future<Either<Failure, List<ReceiptEntity>>> fetchWeeklySales(
      String uuid) async {
    final bool isConnected = await NetworkInfo.connectionChecker.hasConnection;

    if (!isConnected) {
      return Left(
        ShopFailure(errorMessage: 'You have no internet connection 🚩'),
      );
    }

    try {
      
      final List<ReceiptEntity> receipts = await shopDs.fetchWeeklySales(uuid);

      return Right(receipts);
    } on CouldNotFetchException catch (e) {
      return Left(ShopFailure(errorMessage: e.eMessage));
    } catch (e) {
      return Left(ShopFailure(errorMessage: 'An error occurred:\n$e'));
    }
  }

  @override
  Future<Either<Failure, List<ShopAnalysis>>> fetchSalesRank() async {
    final bool isConnected = await NetworkInfo.connectionChecker.hasConnection;

    if (!isConnected) {
      return Left(
        ShopFailure(errorMessage: 'You have no internet connection 🚩'),
      );
    }

    try {
      final List<ShopAnalysis> shopAnalysis = await shopDs.fetchSalesRank();
      return Right(shopAnalysis);
    } on CouldNotFetchException catch (e) {
      return Left(ShopFailure(errorMessage: e.eMessage));
    } catch (e) {
      return Left(ShopFailure(errorMessage: 'An error occurred:\n$e'));
    }
  }
}
