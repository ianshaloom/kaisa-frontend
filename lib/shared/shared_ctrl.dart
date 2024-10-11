import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaisa/features/receipt/domain/entity/receipt_entity.dart';

import '../core/datasources/firestore/models/kaisa-user/kaisa_user.dart';
import '../core/datasources/hive/hive-crud/hive_user_crud.dart';
import '../core/datasources/kaisa-backend/crud/kaisa_backend_ds.dart';
import '../core/errors/failure_n_success.dart';
import '../features/receipt/presentation/views/receipt_view.dart';
import 'shared_models.dart';
import 'shared_usecase.dart';

class SharedCtrl extends GetxController {
  final SharedUsecase stockUsecase;
  SharedCtrl(this.stockUsecase);

  @override
  void onInit() {
    fetchUserProfile();
    super.onInit();
  }

  /* -------------------------------------------------------------------------- */
  var analysis = 'All'.obs;
  var isGettingAnalysisData = true.obs;
  bool get isOverview => analysis.value == 'All';

  var index = 0.obs;

  //  STRICTLY FOR KAISA USER AND SHOPS
  /* -------------------------------------------------------------------------- */

  KaisaUser userData = KaisaUser.empty;

  var requestInProgress = false.obs;
  Failure? requestFailure;

  final _kaisaShopsList = <KaisaUser>[].obs;
  List<KaisaUser> get kaisaShopsList => _kaisaShopsList;
  set kaisaShopsList(List<KaisaUser> value) => _kaisaShopsList.value = value;

  // selected shop details
  var selectedShopId = ''.obs;
  var selectedShopName = ''.obs;
  var selectedShopAddress = ''.obs;
  set setSelectedShopDetails(KaisaUser selectedShop) {
    selectedShopId.value = selectedShop.uuid;
    selectedShopName.value = selectedShop.fullName;
    selectedShopAddress.value = selectedShop.address;
  }

  bool get isShopEmpty => selectedShopName.value.isEmpty;

  Future<void> fetchUsers() async {
    kaisaShopsList.clear();
    requestFailure = null;
    requestInProgress.value = true;

    final usersOrFailure = await stockUsecase.fetchUsers();

    usersOrFailure.fold(
      (failure) => requestFailure = failure,
      (users) {
        users.removeWhere((user) => user.address == userData.address);
        users.sort((a, b) => a.address.compareTo(b.address));
        kaisaShopsList.assignAll(users);
      },
    );

    requestInProgress.value = false;
  }

  Future<void> fetchShops() async {
    kaisaShopsList.clear();
    requestFailure = null;
    requestInProgress.value = true;

    final usersOrFailure = await stockUsecase.fetchUsers();

    usersOrFailure.fold(
      (failure) => requestFailure = failure,
      (users) {
        users.sort((a, b) => a.address.compareTo(b.address));
        kaisaShopsList.assignAll(users);
      },
    );

    requestInProgress.value = false;
  }

  // actions performed on grid tile tap event
  void reset() {
    requestFailure = null;
    requestInProgress.value = false;

    selectedShopId.value = '';
    selectedShopName.value = '';
    selectedShopAddress.value = '';
  }

  // fetch user profile data
  Future<void> fetchUserProfile() async {
    final user = await HiveUserDataCrud().getUser();

    userData = KaisaUser.fromUserHiveData(userDataHive: user);
  }

  List<KaisaShop> get kaisaShops => getKaisaShops(kaisaShopsList);

  /* -------------------------------------------------------------------------- */
  KaisaBackendDS kaisaBackendDS = KaisaBackendDS();

  var isProcessingRequest = false.obs;
  var isProcessingRequest1 = false.obs;

  var pageIndex = 0.obs;
  void swipeToPage(int i) {
    pageIndex.value = i;
  }

  var receipts = <Map<String, dynamic>>[];

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

  // Watu Credit Sales
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

  // M-Kopa Credit Sales
  List<DailySales> get dailyNumberOfSalesMkopa {
    List<DailySales> sales = [];
    mkopaSales.forEach((key, value) {
      final aSale = DailySales(totalSales: value.length, dayOfTheWeek: key);
      sales.add(aSale);
    });
    return sales;
  }

  // Onfon Credit Sales
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
      receipts.assignAll(value);
    });

    isProcessingRequest.value = false;
  }

  // view Receipts
  void orgReceipts(String org, BuildContext context) {
    final orgReceipts = receipts.where((receipt) => receipt['org'] == org);
    final rcts =
        orgReceipts.map((e) => ReceiptEntity.fromJsonKBackend(e)).toList();

    Navigator.of(context).push(toReceitView(org, rcts));
  }

  Route toReceitView(String org, List<ReceiptEntity> receipts) {
    return PageRouteBuilder<SlideTransition>(
      pageBuilder: (context, animation, secondaryAnimation) =>
          ReceiptsPage(org: org, receipts: receipts),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        //  create a slide animation that brings the new page from right to left
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
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

// return string of date e.g. 2024-09-23 from computing the first day of the week
String getFirstDayOfTheWeek() {
  final now = DateTime.now();
  final firstDayOfTheWeek = now.subtract(Duration(days: now.weekday - 1));
  return firstDayOfTheWeek.toString().substring(0, 10);
}

//  return a list of [KaisaShop]s
List<KaisaShop> getKaisaShops(List<KaisaUser> users) {
  List<KaisaShop> shops = [];

  // extract the shop name from the users
  List<String> shopNames = [];
  for (var user in users) {
    if (!shopNames.contains(user.address)) {
      shopNames.add(user.address);
    }
  }

  // create a list of KaisaShop
  for (var shopName in shopNames) {
    List<KaisaUser> attendants = [];

    for (var user in users) {
      if (user.address == shopName) {
        attendants.add(user);
      }
    }

    final shop = KaisaShop(shopName: shopName, attendants: attendants);

    shops.add(shop);
  }

  return shops;
}
