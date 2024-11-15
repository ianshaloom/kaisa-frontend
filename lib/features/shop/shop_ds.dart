import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kaisa/shared/shared_models.dart';

import '../../core/constants/constants.dart';
import '../../core/datasources/kaisa-backend/crud/kaisa_backend_ds.dart';
import '../../core/errors/cloud_storage_exceptions.dart';
import '../../core/utils/utility_methods.dart';
import '../feature-receipts/f_receipt.dart';

class ShopDs {
  static final shop =
      FirebaseFirestore.instance.collection(kaisaShopsCollection);
  final KaisaBackendDS kaisaBackendDS = KaisaBackendDS();

// get all receipts
  Future<List<ReceiptEntity>> fetchWeeklySales(String uuid) async {
    try {
      final firstDayOfTheWeek = getFirstDayOfTheWeek();
      final date = firstDayOfTheWeek.subtract(const Duration(days: 1));

      // reference to the shop
      final docRef = shop.doc(uuid).collection(receiptsSubCollection);

      final fetchedReceipts = await docRef.get();

      final query = fetchedReceipts.docs
          .map((doc) => ReceiptEntity.fromQuerySnapshot(documentSnapshot: doc))
          .toList();

      final finalQuery =
          query.where((element) => element.receiptDate.isAfter(date)).toList();

      return finalQuery;
    } on FirebaseException catch (e) {
      throw CouldNotFetchException(
          eMessage: e.message ?? 'Unable to fetch receipts');
    }
  }

  // fetch sales rank data
  Future<List<ShopAnalysis>> fetchSalesRank() async {
    try {
      List<ShopAnalysis> shopAnalysis = [];

      final weeklySales = await kaisaBackendDS.fetchWeeklySales();

      final sales = weeklySales
          .map(
            (e) => ReceiptEntity.fromJsonKBackend(e),
          )
          .toList();

      // create a list of the shopIds for the receipts
      final List<String> shopIds = [];
      for (final receipt in sales) {
        final shopId = receipt.shopId;

        if (!shopIds.contains(shopId)) {
          shopIds.add(shopId);
        }
      }

      for (var shopId in shopIds) {
        final shopReceipts = sales.where((receipt) => receipt.shopId == shopId);

        final shopName = getShopName(shopReceipts.first.shopId);

        final ShopAnalysis shopData = ShopAnalysis(
          shopName: shopName,
          totalSales: shopReceipts.length,
          sales: [],
        );

        // group the receipts by org
        for (final r in shopReceipts) {
          final org = r.org;

          if (org == 'Watu') {
            shopData.watuSales += 1;
          } else if (org == 'M-Kopa') {
            shopData.mKopaSales += 1;
          } else if (org == 'Onfon') {
            shopData.onfonSales += 1;
          } else {
            shopData.otherSales += 1;
          }

          shopData.sales.add(r);
        }

        shopAnalysis.add(shopData);
      }

      shopAnalysis.sort((a, b) => b.totalSales.compareTo(a.totalSales));

      return shopAnalysis;
    } on FirebaseException catch (e) {
      throw CouldNotFetchException(
          eMessage: e.message ?? 'Unable to fetch receipts');
    }
  }
}

DateTime getFirstDayOfTheWeek() {
  final now = DateTime.now();
  final firstDayOfTheWeek = now.subtract(Duration(days: now.weekday - 1));
  return firstDayOfTheWeek;
}
