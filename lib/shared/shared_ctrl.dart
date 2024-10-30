import 'package:get/get.dart';
import 'package:kaisa/core/errors/failure_n_success.dart';

import '../core/datasources/firestore/models/kaisa-user/kaisa_user.dart';
import 'shared_usecase.dart';

class SharedCtrl extends GetxController {
  final SharedUsecase stockUsecase;
  SharedCtrl(this.stockUsecase);

  //  STRICTLY FOR KAISA USER AND SHOPS
  /* -------------------------------------------------------------------------- */

  KaisaUser userData = KaisaUser.empty;

  var requestInProgress = false.obs;
  Failure? requestFailure;

  final _kaisaUsers = <KaisaUser>[].obs;
  List<KaisaUser> get kaisaUsers => _kaisaUsers;
  set kaisaUsers(List<KaisaUser> value) => _kaisaUsers.value = value;

  final _shops = <String>[].obs;
  List<String> get shops => _shops;
  set shops(List<String> value) => _shops.value = value;

  // selected shop details
  var selectedShopId = ''.obs;
  var selectedShopName = ''.obs;
  var selectedShopAddress = ''.obs;
  set setSelectedShopDetails(KaisaUser selectedShop) {
    selectedShopId.value = selectedShop.uuid;
    selectedShopName.value = selectedShop.fullName;
    selectedShopAddress.value = selectedShop.shop;
  }

  bool get isShopEmpty => selectedShopName.value.isEmpty;

  Future<void> fetchUsers() async {
    kaisaUsers.clear();
    requestFailure = null;
    requestInProgress.value = true;

    final usersOrFailure = await stockUsecase.fetchUsers();

    usersOrFailure.fold(
      (failure) => requestFailure = failure,
      (users) {
        users.removeWhere((user) => user.shop == userData.shop);
        users.removeWhere((user) => !user.active);
        users.sort((a, b) => a.shop.compareTo(b.shop));
        kaisaUsers.assignAll(users);
      },
    );

    requestInProgress.value = false;
  }

  Future<void> fetchShops() async {
    kaisaUsers.clear();
    requestFailure = null;
    requestInProgress.value = true;

    final shopsOrFailure = await stockUsecase.fetchShops();

    shopsOrFailure.fold(
      (failure) => requestFailure = failure,
      (s) {
        s.sort();
        shops.assignAll(s);        
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
}

extension ShopNames on List<KaisaUser> {
  List<String> shopNames() {
    List<String> shops = [];

    for (var shop in this) {
      if (!shops.contains(shop.shop)) {
        shops.add(shop.shop);
      }
    }

    return shops;
  }
}
