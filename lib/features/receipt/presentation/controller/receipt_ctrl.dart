import 'package:get/get.dart';

import '../../../../core/errors/failure_n_success.dart';
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
 
}
