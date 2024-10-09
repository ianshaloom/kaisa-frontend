import 'package:get/get.dart';

import '../core/datasources/firestore/models/kaisa-user/kaisa_user.dart';
import '../core/datasources/hive/hive-crud/hive_user_crud.dart';
import '../core/datasources/kaisa-backend/crud/kaisa_backend_ds.dart';
import '../core/errors/failure_n_success.dart';
import 'shared_models.dart';
import 'shared_usecase.dart';

class SharedCtrl extends GetxController {
  final SharedUsecase stockUsecase;
  SharedCtrl(this.stockUsecase);

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

  @override
  void onInit() {
    fetchUserProfile();
    super.onInit();
  }

  /* -------------------------------------------------------------------------- */
  KaisaBackendDS kaisaBackendDS = KaisaBackendDS();

  var isProcessingRequest = false.obs;
  var isProcessingRequest1 = false.obs;

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
    });

    isProcessingRequest.value = false;
  }

  var receipts = <Map<String, dynamic>>[].obs;

  void getSalesAnalysis() async {
    isProcessingRequest1.value = true;
    receipts.clear();

    final date = getFirstDayOfTheWeek();

    await kaisaBackendDS.fetchWeeklySales(date).then((value) {
      receipts.assignAll(value);
    });

    isProcessingRequest1.value = false;
  }

  // shop analysis
  List<ShopAnalysis> shopAnalysis() {
    List<ShopAnalysis> shopAnalysis = [];

    // create a list of the shopIds for the receipts
    final List<String> shopIds = [];
    for (final receipt in receipts) {
      final shopId = receipt['shopId'];
      if (!shopIds.contains(shopId)) {
        shopIds.add(shopId);
      }
    }

    // create a map of the shops
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

    shopAnalysis.sort((a, b) => b.totalSales.compareTo(a.totalSales));

    return shopAnalysis;
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

// analysis for shop
// the map will have the following structure
/* 
    {
      'Shop Name' : {
            'Shop Name': "Shop Name",
            'Total Sales': 0,
            'Watu Sales': 0,
            'M-Kopa Sales': 0,
            'Onfon Sales': 0, e
            'Other Sales': 0,
            'sales':[],
          },
      'SHop Name' : {
            'Shop Name': "Shop Name",
            'Total Sales': 0,
            'Watu Sales': 0,
            'M-Kopa Sales': 0,
            'Onfon Sales': 0,
            'Other Sales': 0,
            'Allales':[],
          },
    }
*/
// to that method will pass a filter of the org name, The filter string can be either 'Watu', 'M-Kopa', 'Onfon', 'Other'
// if the filter string is null, then the method will return the total sales for all the orgs

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

String getShopName(String shopId) {
  // shopId has no spaces, so split it by uppercase letters
  final shopName = shopId.splitMapJoin(
    RegExp(r'(?=[A-Z])'),
    onMatch: (m) => ' ',
    onNonMatch: (m) => m,
  );

  return shopName;
}
