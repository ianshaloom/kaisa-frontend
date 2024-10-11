import 'package:get/get.dart';
import 'package:kaisa/shared/shared_models.dart';

import '../../core/datasources/firestore/models/phone-transaction/phone_transaction.dart';
import '../../core/datasources/firestore/models/stock/stock_item_entity.dart';
import '../../core/errors/failure_n_success.dart';
import '../receipt/domain/entity/receipt_entity.dart';
import 'shop_usecase.dart';

class ShopCtrl extends GetxController {
  final ShopUsecase shopUsecase;
  ShopCtrl(this.shopUsecase);

  var navIndex = 0.obs;

  var requestFailure = <Failure>[].obs;

  void navOnPressed(int i, String status) {
    navIndex.value = i;

    if (i == 0) {
      fetchOrders();
    } else if (i == 1) {
      fetchStock();
    } else if (i == 2) {
      fetchReceipts();
    }
  }

  var _selKaisaShop = KaisaShop.empty;
  KaisaShop get selKaisaShop => _selKaisaShop;
  set kaisaShop(KaisaShop value) => _selKaisaShop = value;

  //  receipt entity
  final _receipts = <ReceiptEntity>[].obs;
  List<ReceiptEntity> get receipts => _receipts;
  set receipts(List<ReceiptEntity> value) => _receipts.value = value;

  var _selReceipt = ReceiptEntity.empty;
  ReceiptEntity get selReceipt => _selReceipt;
  set receipt(ReceiptEntity value) => _selReceipt = value;

  // stock entity
  final _stockItems = <StockItemEntity>[].obs;
  List<StockItemEntity> get stockItems => _stockItems;
  set stockItems(List<StockItemEntity> value) => _stockItems.value = value;

  // phone transactions
  final _phoneTransactions = <PhoneTransaction>[].obs;
  List<PhoneTransaction> get phoneTransactions => _phoneTransactions;
  var _selPhoneTransaction = PhoneTransaction.empty;
  PhoneTransaction get selPhoneTransaction => _selPhoneTransaction;
  set phoneTransaction(PhoneTransaction value) => _selPhoneTransaction = value;

  Failure? orderFailure;
  var isProcessingRequest1 = false.obs;
  void fetchOrders() async {
    isProcessingRequest1.value = true;
    requestFailure.clear();
    _phoneTransactions.clear();

    final successOrFailure =
        await shopUsecase.fetchKOrderTranscsById(_selKaisaShop.attendantIds);

    successOrFailure.fold(
      (failure) => orderFailure = failure,
      (success) {
        success.sort((b, a) => a.dateTime.compareTo(b.dateTime));
        _phoneTransactions.addAll(success);
      },
    );

    isProcessingRequest1.value = false;
  }

  Failure? stockFailure;
  var isProcessingRequest2 = false.obs;
  void fetchStock() async {
    isProcessingRequest2.value = true;
    requestFailure.clear();
    _stockItems.clear();

    final successOrFailure =
        await shopUsecase.fetchShopStock(_selKaisaShop.shopId);

    successOrFailure.fold(
      (failure) => stockFailure = failure,
      (success) {
        success.sort((b, a) => a.addeOn.compareTo(b.addeOn));
        _stockItems.addAll(success);
      },
    );

    isProcessingRequest2.value = false;
  }

  Failure? receiptFailure;
  var isProcessingRequest3 = false.obs;
  void fetchReceipts() async {
    isProcessingRequest3.value = true;
    requestFailure.clear();
    _receipts.clear();

    final successOrFailure =
        await shopUsecase.fetchShopReceipts(_selKaisaShop.shopId);

    successOrFailure.fold(
      (failure) => receiptFailure = failure,
      (success) => _receipts.addAll(success),
    );

    isProcessingRequest3.value = false;
  }

  // clear list
  void clearList() {
    _receipts.clear();
    _stockItems.clear();
    _phoneTransactions.clear();
  }

  // reset
  void reset() {
    navIndex.value = 0;
    clearList();
  }
}
