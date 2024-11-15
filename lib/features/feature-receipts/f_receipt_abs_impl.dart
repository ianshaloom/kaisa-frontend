import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/connection/network_info.dart';
import '../../../../core/errors/failure_n_success.dart';
import '../../../../core/errors/cloud_storage_exceptions.dart';
import 'f_receipt.dart';
import 'f_receipt_abs.dart';
import 'f_receipt_ds.dart';
import 'f_receipt_errors.dart';

class FReceiptAbsImpl extends FReceiptAbs {
  FReceiptAbsImpl(this.fReceiptDs);
  final FReceiptDs fReceiptDs;

  @override
  Future<Either<Failure, void>> createReceipt(ReceiptEntity receipt) async {
    final bool isConnected = await NetworkInfo.connectionChecker.hasConnection;

    if (!isConnected) {
      return Left(
        ReceiptFailure(errorMessage: 'You have no internet connection 🚩'),
      );
    }

    try {
      final r = receipt.toJson();

      await fReceiptDs.createReceipt(r);

      return const Right(null);
    } on CouldNotCreateException catch (e) {
      return Left(ReceiptFailure(errorMessage: e.eMessage));
    }
  }

  @override
  Future<Either<Failure, List<ReceiptEntity>>> fetchReceipts(
      String uuid) async {
    try {
      final receipts = await fReceiptDs.fetchReceipts(uuid);
      return Future.value(Right(receipts));
    } on CouldNotFetchException catch (e) {
      return Future.value(Left(ReceiptFailure(errorMessage: e.eMessage)));
    }
  }

  @override
  Future<Either<Failure, ReceiptEntity>> fetchReceipt(
      String imei, String shopId) async {
    try {
      final receipt = await fReceiptDs.fetchReceipt(imei, shopId);
      return Future.value(Right(receipt));
    } on CouldNotFetchException catch (e) {
      return Future.value(Left(ReceiptFailure(errorMessage: e.message)));
    }
  }

  @override
  Future<Either<Failure, List<String>>> uploadImage(
    List<File> files,
    String imei,
  ) async {
    final bool isConnected = await NetworkInfo.connectionChecker.hasConnection;

    if (!isConnected) {
      return Left(
        ReceiptFailure(errorMessage: 'You have no internet connection 🚩'),
      );
    }

    if (files.isEmpty) {
      return Left(
        ReceiptFailure(errorMessage: 'No image selected 🚩'),
      );
    }

    final fileNames = genFilenames(files.length, imei);

    try {

      List<String> downloadUrls = [];

      // upload image 1
      final imgUrl1 = await fReceiptDs.uploadImage(files[0], fileNames[0]);

      //  upload image 2
      final imgUrl2 = await fReceiptDs.uploadImage(files[1], fileNames[1]);

      // add to downloadUrls
      downloadUrls.addAll([imgUrl1, imgUrl2]);

      return Future.value(Right(downloadUrls));
    } on CloudStorageExceptions catch (e) {
      return Future.value(Left(ReceiptFailure(errorMessage: e.message)));
    }

    //  return Future.value(Left(ReceiptFailure(errorMessage: '🚩 e.message')));
  }
}

// return a list<string> of filenames from the length of list of files
List<String> genFilenames(int length, String imei) {
  List<String> filenames = [];
  for (int i = 0; i < length; i++) {
    filenames.add('$imei-$i.jpg');
  }
  return filenames;
}
