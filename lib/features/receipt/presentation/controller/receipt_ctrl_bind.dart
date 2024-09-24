import 'package:get/get.dart';


import '../../data/provider/network/firestore_receipt_ds.dart';
import '../../data/repository/receipt_abs_impl.dart';
import '../../domain/usecase/receipt_usecase.dart';
import 'receipt_ctrl.dart';

class ReceiptCtrlBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReceiptCtrl>(
      () => ReceiptCtrl(
        ReceiptUsecase(
          ReceiptAbsImpl(FirestoreReceiptDs()),
        ),
      ),
    );
  }
}
