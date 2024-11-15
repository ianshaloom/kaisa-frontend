import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure_n_success.dart';
import 'f_receipt.dart';

abstract class FReceiptAbs {
  Future<Either<Failure, ReceiptEntity>> fetchReceipt(
    String imei,
    String shopId,
  );
  Future<Either<Failure, List<ReceiptEntity>>> fetchReceipts(String uuid);
  Future<Either<Failure, void>> createReceipt(ReceiptEntity receipt);
  Future<Either<Failure, List<String>>> uploadImage(
      List<File> files, String imei);
}
