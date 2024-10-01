import 'package:get/get.dart';

import '../../../../core/datasources/kaisa-backend/crud/kaisa_backend_ds.dart';
import '../../../../core/errors/failure_n_success.dart';
import '../../domain/entity/daily_sales.dart';
import '../../domain/entity/receipt_entity.dart';
import '../../domain/usecase/receipt_usecase.dart';

enum Org { none, watu, mkopa, onfon, other }

class ReceiptCtrl extends GetxController {
  final ReceiptUsecase receiptUsecase;
  ReceiptCtrl(this.receiptUsecase);

  var actionFromReceiptList = true;

  var requestInProgress1 = false.obs;
  var progressStatus = 'Uploading images...'.obs;
  var requestInProgress2 = false.obs;
  Failure? requestFailure;

  final _receipts = <ReceiptEntity>[].obs;
  List<ReceiptEntity> get receipts => _receipts;
  set receipts(List<ReceiptEntity> value) => _receipts.value = value;

  var _selReceipt = ReceiptEntity.empty;
  ReceiptEntity get selReceipt => _selReceipt;
  set receipt(ReceiptEntity value) => _selReceipt = value;

  // FOR RECEIPT FORM

  var _toBeUploaded = ReceiptEntity.empty;
  ReceiptEntity get toBeUploaded => _toBeUploaded;
  set tReceipt(ReceiptEntity value) => _toBeUploaded = value;

  var imeiz = ''.obs;
  var deviceDetailsz = ''.obs;

  var imei = '';
  var smUuid = '';
  var shopId = '';
  var deviceDetails = '';

  var receiptNo = '';
  var customerName = '';
  var customerPhoneNo = '';
  var cashPrice = 0;
  var date = DateTime.now().obs;
  var org = Org.none.obs;
  var downloadUrls = <String>[];

  List<String> get downloadUrlsList => _selReceipt.receiptImgUrl;
  String get organisation {
    switch (org.value) {
      case Org.watu:
        return 'Watu';
      case Org.mkopa:
        return 'M-Kopa';
      case Org.onfon:
        return 'Onfon';
      case Org.other:
        return 'Other';
      default:
        return 'None';
    }
  }

  void reset1() {
    receiptNo = '';
    customerName = '';
    customerPhoneNo = '';
    cashPrice = 0;

    date.value = DateTime.now();
    org.value = Org.none;
    downloadUrls.clear();
  }

  void reset2() {
    imeiz.value = '';
    deviceDetailsz.value = '';

    receiptNo = '';
    customerName = '';
    customerPhoneNo = '';
    cashPrice = 0;
    date.value = DateTime.now();
    org.value = Org.none;
    downloadUrls.clear();
  }

  // RECEIPT CRUD
  void fetchReceipts() async {
    requestFailure = null;
    requestInProgress1.value = true;

    final result = await receiptUsecase.fetchReceipts();

    result.fold(
      (failure) => requestFailure = failure,
      (receipts) => this.receipts = receipts,
    );

    requestInProgress1.value = false;
  }

  void fetchReceipt() async {
    requestFailure = null;
    requestInProgress1.value = true;

    final result = await receiptUsecase.fetchReceipt(imei, shopId);

    result.fold(
      (failure) => requestFailure = failure,
      (receipt) => _selReceipt = receipt,
    );

    requestInProgress1.value = false;
  }

  /* -------------------------------------------------------------------------- */
  KaisaBackendDS kaisaBackendDS = KaisaBackendDS();

  var isProcessingRequest = false.obs;

  var pageIndex = 0.obs;
  void swipeToPage(int i) {
    pageIndex.value = i;
  }

  var allOrgSales = <String, Map<String, List<Map<String, dynamic>>>>{}.obs;

  // getters
  Map<String, List<Map<String, dynamic>>> get watuSales => allOrgSales['Watu']!;
  Map<String, List<Map<String, dynamic>>> get mkopaSales =>
      allOrgSales['M-Kopa']!;
  Map<String, List<Map<String, dynamic>>> get onfonSales =>
      allOrgSales['Onfon']!;

  int get totalWatWeeklySales {
    int total = 0;
    watuSales.forEach((key, value) {
      total += value.length;
    });
    return total;
  }

  int get totalMkopaWeeklySales {
    int total = 0;
    mkopaSales.forEach((key, value) {
      total += value.length;
    });
    return total;
  }

  int get totalOnfonWeeklySales {
    int total = 0;
    onfonSales.forEach((key, value) {
      total += value.length;
    });
    return total;
  }

  int get totalWeeklySales {
    int total =
        totalMkopaWeeklySales + totalOnfonWeeklySales + totalWatWeeklySales;
    return total;
  }

  List<DailySales> get dailyNumberOfSalesWatu {
    List<DailySales> sales = [];
    watuSales.forEach((key, value) {
      final aSale = DailySales(totalSales: value.length, dayOfTheWeek: key);
      sales.add(aSale);
    });
    return sales;
  }

  int get watuTotalSalesInAmount {
    int total = 0;
    watuSales.forEach((key, value) {
      for (var element in value) {
        total += element['cashPrice'] as int;
      }
    });
    return total;
  }

  List<DailySales> get dailyNumberOfSalesMkopa {
    List<DailySales> sales = [];
    mkopaSales.forEach((key, value) {
      final aSale = DailySales(totalSales: value.length, dayOfTheWeek: key);
      sales.add(aSale);
    });
    return sales;
  }

  List<DailySales> get dailyNumberOfSalesOnfon {
    List<DailySales> sales = [];
    onfonSales.forEach((key, value) {
      final aSale = DailySales(totalSales: value.length, dayOfTheWeek: key);
      sales.add(aSale);
    });
    return sales;
  }

  // get sales
  void getSales() async {
    isProcessingRequest.value = true;
    allOrgSales.clear();

    final date = getFirstDayOfTheWeek();

    await kaisaBackendDS.fetchWeeklySales(date).then((value) {
      allOrgSales.value = groupReceiptsByOrgAndDate(value, date);
    });

    isProcessingRequest.value = false;
  }

  // return string of date e.g. 2024-09-23 from computing the first day of the week
  String getFirstDayOfTheWeek() {
    final now = DateTime.now();
    final firstDayOfTheWeek = now.subtract(Duration(days: now.weekday - 1));
    return firstDayOfTheWeek.toString().substring(0, 10);
  }
}

// group receipts by org and date

Map<String, Map<String, List<Map<String, dynamic>>>> groupReceiptsByOrgAndDate(
    List<Map<String, dynamic>> receipts, String startDate) {
  //  create a map of the orgs
  final Map<String, Map<String, List<Map<String, dynamic>>>> groupedReceipts = {
    'Watu': {},
    'Onfon': {},
    'M-Kopa': {},
    'Other': {},
  };

  groupedReceipts.map(
    (key, value) {
      Map<String, List<Map<String, dynamic>>> dailySalez = {
        'mon': [],
        'tue': [],
        'wed': [],
        'thu': [],
        'fri': [],
        'sat': [],
        'sun': [],
      };

      List<String> exactDates = [];

      // create a list of the receipts for each day of the week
      for (var i = 0; i < 7; i++) {
        final date = DateTime.parse(startDate)
            .add(Duration(days: i))
            .toIso8601String()
            .split('T')[0];

        exactDates.add(date);
      }

      // group the receipts by org and date
      for (final receipt in receipts) {
        if (receipt['org'] == key) {
          final date = receipt['receiptDate'];

          // get index of the date
          final index = exactDates.indexOf(date);

          if (index != -1) {
            final day = getDayOfWeek(index);
            dailySalez[day]!.add(receipt);
          }
        }
      }

      groupedReceipts[key] = dailySalez;
      return MapEntry(key, dailySalez);
    },
  );

  return groupedReceipts;
}

//  days of the week
const List<String> daysOfWeek = [
  'mon',
  'tue',
  'wed',
  'thu',
  'fri',
  'sat',
  'sun',
];

// return day of the week from index
String getDayOfWeek(int index) {
  return daysOfWeek[index];
}
