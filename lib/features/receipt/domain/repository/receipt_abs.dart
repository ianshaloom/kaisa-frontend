import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure_n_success.dart';
import '../entity/receipt_entity.dart';

abstract class ReceiptAbs {
  Future<Either<Failure, ReceiptEntity>> fetchReceipt(
    String imei,
    String shopId,
  );
  Future<Either<Failure, List<ReceiptEntity>>> fetchReceipts();
  Future<Either<Failure, void>> createReceipt(ReceiptEntity receipt);
  Future<Either<Failure, void>> updateReceipt(ReceiptEntity receipt);
  Future<Either<Failure, List<String>>> uploadImage(
      List<File> files, String imei);
}
