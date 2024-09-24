import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure_n_success.dart';
import '../entity/receipt_entity.dart';
import '../repository/receipt_abs.dart';

class ReceiptUsecase {
  final ReceiptAbs receiptAbs;
  ReceiptUsecase(this.receiptAbs);

  Future<Either<Failure, ReceiptEntity>> fetchReceipt(String imei, String shopId) {
    return receiptAbs.fetchReceipt(imei, shopId);
  }

  Future<Either<Failure, List<ReceiptEntity>>> fetchReceipts() {
    return receiptAbs.fetchReceipts();
  }

  Future<Either<Failure, void>> createReceipt(ReceiptEntity receipt) {
    return receiptAbs.createReceipt(receipt);
  }

  Future<Either<Failure, void>> updateReceipt(ReceiptEntity receipt) {
    return receiptAbs.updateReceipt(receipt);
  }

  Future<Either<Failure, List<String>>> uploadImage(List<File> files, String imei) {
    return receiptAbs.uploadImage(files, imei);
  }
}
