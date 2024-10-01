import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/errors/failure_n_success.dart';
import '../../domain/entity/receipt_entity.dart';
import '../../domain/usecase/receipt_usecase.dart';

enum Org { none, watu, mkopa, onfon, other }

class ReceiptCtrl extends GetxController {
  final ReceiptUsecase receiptUsecase;
  ReceiptCtrl(this.receiptUsecase);

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
  var date = <DateTime>[].obs;
  var org = Org.none.obs;
  var downloadUrls = <String>[];

  var images = <File>[].obs;
// Pick an image.
  void pickImage() async {
    ImagePicker picker = ImagePicker();
    XFile? i =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    if (i != null) {
      images.add(File(i.path));
    }

    i = null;
  }

  void removeImage(int index) async {
    final File image = images[index];

    // remove image from images list
    images.removeAt(index);

    // remove image from storage/memory
    await image.delete();
  }

  void clearImagesMemory() {
    for (var image in images) {
      image.delete();
    }
  }

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

  void reset() {
    imeiz.value = '';
    deviceDetailsz.value = '';

    receiptNo = '';
    customerName = '';
    customerPhoneNo = '';
    cashPrice = 0;
    date.clear();
    org.value = Org.none;
    images.clear();
    downloadUrls.clear();
  }

  Future<void> uploadImages() async {
    requestFailure = null;
    requestInProgress1.value = true;

    String leading = imeiz.value;

    final result = await receiptUsecase.uploadImage(images, leading);

    result.fold(
      (failure) => requestFailure = failure,
      (urls) => downloadUrls.assignAll(urls),
    );

    requestInProgress1.value = false;
  }

  void createReceipt(ReceiptEntity receipt) async {
    requestFailure = null;
    requestInProgress1.value = true;

    final result = await receiptUsecase.createReceipt(receipt);

    result.fold(
      (failure) => requestFailure = failure,
      (_) {
        clearImagesMemory();
        fetchReceipts();
      },
    );

    requestInProgress1.value = false;
  }

  Future<String> postReceipt() async {
    requestFailure = null;

    if (downloadUrls.isEmpty) {
      // update progress status
      progressStatus.value = 'Uploading images...';
      await uploadImages();

      if (requestFailure != null) {
        return 'fail upload';
      }

      // continue to post receipt
      final r = _toBeUploaded.copyWith(receiptImgUrl: downloadUrls);

      // update progress status
      progressStatus.value = 'Posting receipt...';

      // post receipt
      createReceipt(r);

      if (requestFailure != null) {
        return 'fail post';
      }

      return 'success';
    }

    // continue to post receipt
    final r = _toBeUploaded.copyWith(receiptImgUrl: downloadUrls);

    // update progress status
    progressStatus.value = 'Posting Receipt...';

    // post receipt
    createReceipt(r);

    if (requestFailure != null) {
      return 'fail post';
    }
    return 'success';
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
}
