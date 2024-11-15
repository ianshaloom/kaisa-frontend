import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure_n_success.dart';
import 'f_receipt.dart';
import 'f_receipt_abs.dart';

class FReceiptUsecase {
  final FReceiptAbs freceiptAbs;
  FReceiptUsecase(this.freceiptAbs);

  Future<Either<Failure, ReceiptEntity>> fetchReceipt(
      String imei, String shopId) {
    return freceiptAbs.fetchReceipt(imei, shopId);
  }

  Future<Either<Failure, List<ReceiptEntity>>> fetchReceipts(String uuid) {
    return freceiptAbs.fetchReceipts(uuid);
  }

  Future<Either<Failure, void>> createReceipt(ReceiptEntity receipt) {
    return freceiptAbs.createReceipt(receipt);
  }

  Future<Either<Failure, List<String>>> uploadImage(
      List<File> files, String imei) {
    return freceiptAbs.uploadImage(files, imei);
  }
}
