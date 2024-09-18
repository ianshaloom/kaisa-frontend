import 'package:get/get.dart';

import '../../../../core/errors/failure_n_success.dart';
import '../../domain/entity/receipt_entity.dart';
import '../../domain/usecase/receipt_usecase.dart';

class ReceiptCtrl extends GetxController{
  final ReceiptUsecase receiptUsecase;
  ReceiptCtrl(this.receiptUsecase);

  var requestInProgress = false.obs;
  Failure? requestFailure;

  final _receipts = <ReceiptEntity>[].obs;
  List<ReceiptEntity> get receipts => _receipts;
  set receipts(List<ReceiptEntity> value) => _receipts.value = value;

  var _selReceipt = ReceiptEntity.empty;
  ReceiptEntity get selReceipt => _selReceipt;
  set receipt(ReceiptEntity value) => _selReceipt = value;

  void fetchReceipts() async{
    requestFailure = null;
    requestInProgress.value = true;

    final result = await receiptUsecase.fetchReceipts();

    result.fold(
      (failure) => requestFailure = failure,
      (receipts) => this.receipts = receipts,
    );

    requestInProgress.value = false;
  }

  void createReceipt(ReceiptEntity receipt) async{
    requestFailure = null;
    requestInProgress.value = true;

    final result = await receiptUsecase.createReceipt(receipt);

    result.fold(
      (failure) => requestFailure = failure,
      (_) => fetchReceipts(),
    );

    requestInProgress.value = false;
  }

  void updateReceipt(ReceiptEntity receipt) async{
    requestFailure = null;
    requestInProgress.value = true;

    final result = await receiptUsecase.updateReceipt(receipt);

    result.fold(
      (failure) => requestFailure = failure,
      (_) => fetchReceipts(),
    );

    requestInProgress.value = false;
  }

}