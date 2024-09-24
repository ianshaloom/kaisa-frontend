import 'package:get/get.dart';
import 'package:kaisa/core/errors/failure_n_success.dart';

import '../../../../core/datasources/firestore/models/kaisa-user/kaisa_user.dart';
import '../../domain/usecase/shared_usecase.dart';

class SharedCtrl extends GetxController {
  final SharedUsecase stockUsecase;
  SharedCtrl(this.stockUsecase);


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
}
