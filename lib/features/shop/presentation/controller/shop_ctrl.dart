import 'package:get/get.dart';

import '../../../../core/datasources/kaisa-backend/crud/kaisa_backend_ds.dart';
import '../../../../core/errors/failure_n_success.dart';
import '../../../../core/utils/utility_methods.dart';
import '../../../../shared/shared_models.dart';

class ShopCtrl extends GetxController {
  KaisaBackendDS kaisaBackendDS = KaisaBackendDS();

  var index = 0.obs;
  var analysis = 'All'.obs;
  bool get isOverview => analysis.value == 'All';

  Failure? requestFailure;

  var isGettingAnalysisData = true.obs;

  var receipts = <Map<String, dynamic>>[].obs;

  void getSalesAnalysis() async {
    isGettingAnalysisData.value = true;
    receipts.clear();

    final date = getFirstDayOfTheWeek();

    await kaisaBackendDS
        .fetchWeeklySales(date.toString().substring(0, 10))
        .then((value) {
      receipts.assignAll(value);
      shopAnalysis();
    });

    isGettingAnalysisData.value = false;
  }

  var shopAnalysisData = <ShopAnalysis>[].obs;

  // shop analysis
  void shopAnalysis() {
    List<ShopAnalysis> shopAnalysis = [];

    // create a list of the shopIds for the receipts
    final List<String> shopIds = [];
    for (final receipt in receipts) {
      final shopId = receipt['shopId'];
      if (!shopIds.contains(shopId)) {
        shopIds.add(shopId);
      }
    }

    if (analysis.value == 'All') {
      for (var shopId in shopIds) {
        final shopReceipts =
            receipts.where((receipt) => receipt['shopId'] == shopId);

        final shopName = getShopName(shopReceipts.first['shopId']);

        final ShopAnalysis shopData = ShopAnalysis(
          shopName: shopName,
          totalSales: shopReceipts.length,
          sales: [],
        );

        // group the receipts by org
        for (final receipt in shopReceipts) {
          final org = receipt['org'];

          if (org == 'Watu') {
            shopData.watuSales += 1;
          } else if (org == 'M-Kopa') {
            shopData.mKopaSales += 1;
          } else if (org == 'Onfon') {
            shopData.onfonSales += 1;
          } else {
            shopData.otherSales += 1;
          }

          shopData.sales.add(receipt);
        }

        shopAnalysis.add(shopData);
      }
    } else {
      final orgReceipts =
          receipts.where((receipt) => receipt['org'] == analysis.value);

      for (var shopId in shopIds) {
        final shopReceipts =
            orgReceipts.where((receipt) => receipt['shopId'] == shopId);

        final shopData = ShopAnalysis(
          shopName: getShopName(shopId),
          totalSales: shopReceipts.length,
          sales: shopReceipts.toList(),
        );

        if (shopData.totalSales == 0) continue;

        shopAnalysis.add(shopData);
      }
    }

    shopAnalysis.sort((a, b) => b.totalSales.compareTo(a.totalSales));

    shopAnalysisData.assignAll(shopAnalysis);
  }

  /* -------------------------------------------------------------------------- */
  /*                                Filter Methods                               */
  /* -------------------------------------------------------------------------- */

  // temporary list for filtering
  var filterResults = <Map<String, dynamic>>[];
  var isFiltering = false;

  var firstDayOfTheWeek = getFirstDayOfTheWeek().obs;
  var days = 0.obs;

  // change the week
  void changeWeek() {
    final currentDate = getFirstDayOfTheWeek();
    final newDate = currentDate.subtract(Duration(days: days.value));
    firstDayOfTheWeek.value = newDate;
  }

  // apply filter
  void getFilteredAnalysis() async {
    analysis.value = 'All';
    isFiltering = true;
    index.value = 0;
    isGettingAnalysisData.value = true;
    receipts.clear();

    await kaisaBackendDS
        .fetchWeeklySales(firstDayOfTheWeek.value.toString().substring(0, 10))
        .then((value) {
      filterResults.assignAll(value);
      trimReceipts();
      shopAnalysis();
    });

    isGettingAnalysisData.value = false;
  }

  void trimReceipts() {
    final rs = filterResults;
    // start date i.e start of the week
    final firstDate = firstDayOfTheWeek.value;

    // end date i.e end of the week
    final lastDate = firstDate.add(const Duration(days: 6));

    rs.removeWhere(
        (receipt) => DateTime.parse(receipt['receiptDate']).isAfter(lastDate));

    receipts.assignAll(rs);
  }

  void resetFilters() {
    index.value = 0;
    isFiltering = false;
    days.value = 0;
    firstDayOfTheWeek.value = getFirstDayOfTheWeek();
    getSalesAnalysis();
  }
  void resetFilterss() {
    index.value = 0;
    isFiltering = false;
    days.value = 0;
    firstDayOfTheWeek.value = getFirstDayOfTheWeek();
  }
}

/* extension PurchaseFilter on List<PurchaseEntity> {
  List<PurchaseEntity> filterByStatus(String requiredStatus) {
    return where((purchase) => purchase.status == requiredStatus).toList();
  }
} */

// get first day of the week
DateTime getFirstDayOfTheWeek() {
  final now = DateTime.now();
  final day = now.weekday;
  final firstDay = now.subtract(Duration(days: day - 1));
  return DateTime(firstDay.year, firstDay.month, firstDay.day);
}

// return string e.g. '30th Sep - 6th Oct', given the first day of the week
String getWeekString(DateTime firstDay) {
  final lastDay = firstDay.add(const Duration(days: 6));

  // if its this week, return 'This Week'
  if (DateTime.now().isAfter(firstDay) && DateTime.now().isBefore(lastDay)) {
    return 'This Week';
  }

  // if its last week, return 'Last Week'
  if (DateTime.now().isAfter(lastDay) &&
      DateTime.now().isBefore(lastDay.add(const Duration(days: 7)))) {
    return 'Last Week';
  }

  return '${customDate(firstDay)}   -   ${customDate(lastDay)}';
}
