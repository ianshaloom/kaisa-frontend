import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kaisa/core/errors/failure_n_success.dart';

import 'f_receipt.dart';
import 'f_receipt_usc.dart';

enum Org { none, watu, mkopa, onfon, other }

class FReceiptCtrl extends GetxController {
  final FReceiptUsecase receiptUsecase;
  FReceiptCtrl(this.receiptUsecase);

  final _receipts = <ReceiptEntity>[].obs;
  List<ReceiptEntity> get receipts => _receipts;
  set receipts(List<ReceiptEntity> value) => _receipts.value = value;

  var _selReceipt = ReceiptEntity.empty;
  ReceiptEntity get selReceipt => _selReceipt;
  set receipt(ReceiptEntity value) => _selReceipt = value;

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

  // Pick an image.
  var images = <File>[].obs;
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

  Failure? uploadingImgFailure;
  var uploadingImgInProgress = false.obs;
  var downloadUrls = <String>[];

  uploadImages() async {
    uploadingImgFailure = null;
    uploadingImgInProgress.value = true;

    String leading = imeiz.value;

    final result = await receiptUsecase.uploadImage(images, leading);

    result.fold(
      (failure) => uploadingImgFailure = failure,
      (urls) => downloadUrls.assignAll(urls),
    );

    uploadingImgInProgress.value = false;
  }

  Failure? postingRFailure;
  var postingRInProgress = false.obs;

  createReceipt(ReceiptEntity receipt) async {
    postingRFailure = null;
    postingRInProgress.value = true;

    final result = await receiptUsecase.createReceipt(receipt);

    result.fold(
      (failure) => postingRFailure = failure,
      (_) {
        clearImagesMemory();
      },
    );

    postingRInProgress.value = false;
  }

  var requestStatus = 'Uploading images...'.obs;

  Future<String> postReceipt() async {
    if (downloadUrls.isEmpty) {
      // update progress status
      requestStatus.value = 'Uploading images...';

      await uploadImages();

      if (uploadingImgFailure != null) {
        return 'fail upload';
      }

      // continue to post receipt
      final r = _toBeUploaded.copyWith(receiptImgUrl: downloadUrls);

      // update progress status
      requestStatus.value = 'Posting receipt...';

      // post receipt
      createReceipt(r);

      if (postingRFailure != null) {
        return 'fail post';
      }

      return 'success';
    }

    // continue to post receipt
    final r = _toBeUploaded.copyWith(receiptImgUrl: downloadUrls);

    // update progress status
    requestStatus.value = 'Posting Receipt...';

    // post receipt
    createReceipt(r);

    if (postingRFailure != null) {
      return 'fail post';
    }

    return 'success';
  }

  // RECEIPT CRUD
  Failure? fetchFailure;
  var fetchRequest = false.obs;

  void fetchReceipts(String uuid) async {
    fetchFailure = null;
    fetchRequest.value = true;

    final result = await receiptUsecase.fetchReceipts(uuid);

    result.fold(
      (failure) => fetchFailure = failure,
      (receipts) => this.receipts = receipts,
    );

    fetchRequest.value = false;
  }

  void fetchReceipt() async {
    fetchFailure = null;
    fetchRequest.value = true;

    final result = await receiptUsecase.fetchReceipt(imei, shopId);

    result.fold(
      (failure) => fetchFailure = failure,
      (receipt) => _selReceipt = receipt,
    );

    fetchRequest.value = false;
  }
}
