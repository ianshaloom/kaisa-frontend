import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/errors/failure_n_success.dart';
import '../../shared/shared_models.dart';
import '../receipt/domain/entity/receipt_entity.dart';
import 'shop_usecase.dart';

class ShopCtrl extends GetxController {
  final ShopUsecase shopUsecase;

  ShopCtrl(this.shopUsecase);

  var navIndex = 0.obs;
  var lsIndex = 0.obs;

  var processingRequest1 = false.obs;
  var processingRequest2 = false.obs;

  Failure? shopAnalysisFailure;
  Failure? weeklySalesFailure;
  var shopAnalysis = <ShopAnalysis>[].obs;
  var weeklySales = <ReceiptEntity>[].obs;

  void navOnPressed(int i, String uuid) {
    navIndex.value = i;

    if (i == 0) {
      fetchWeeklySales(uuid);
    } else {
      fetchSalesRank();
    }
  }

  Future<void> fetchWeeklySales(String uuid) async {
    processingRequest1.value = true;
    weeklySales.clear();
    weeklySalesFailure = null;

    final weeklySalesOrFailure = await shopUsecase.fetchWeeklySales(uuid);

    weeklySalesOrFailure.fold(
      (failure) => weeklySalesFailure = failure,
      (sales) {
        weeklySales.assignAll(sales);
        orgWeeklySales.assignAll(listDailySales);
      },
    );

    processingRequest1.value = false;
  }

  Future<void> fetchSalesRank() async {
    processingRequest2.value = true;
    shopAnalysis.clear();
    shopAnalysisFailure = null;

    final salesRankOrFailure = await shopUsecase.fetchSalesRank();

    salesRankOrFailure.fold(
      (failure) => shopAnalysisFailure = failure,
      (sales) => shopAnalysis.assignAll(sales),
    );

    processingRequest2.value = false;
  }

  ScrollController scrollController = ScrollController();
  var showFab = true.obs;

  var orgWeeklySales = <DailySales>[].obs;

  // Watu Credit Sales
  List<DailySales> get listDailySales {
    List<DateTime> dates = [];

    for (var element in weeklySales) {
      final date = DateTime(element.receiptDate.year, element.receiptDate.month,
          element.receiptDate.day);

      if (!dates.contains(date)) {
        dates.add(date);
      }
    }

    List<DailySales> sales = [];
    for (var e in dates) {
      final salesCount = weeklySales
          .where((element) => element.receiptDate.day == e.day)
          .toList();
      final aSale = DailySales(sales: salesCount, dayOfTheWeek: e);
      sales.add(aSale);
    }
    return sales;
  }

  List<DonutData> buildPieChartData() {
    final pieListData = listDailySales;

    return List.generate(
      pieListData.length,
      (index) {
        final data = pieListData[index];
        final color = data.color;
        final perc = percValue(data.salesCount.toDouble(), pieListData);

        final pieData = DonutData(color, perc);

        return pieData;
      },
    );
  }

  //  return a double from a percentage
  double percValue(double value, List<DailySales> items) {
    double total = 0;
    for (int i = 0; i < items.length; i++) {
      total += items[i].salesCount;

      // print('total: $total');
    }

    double p = (value / total) * 100;

    return p;
  }

  reset(String uuid){
    navIndex.value = 0;
    fetchWeeklySales(uuid);
  }
}
