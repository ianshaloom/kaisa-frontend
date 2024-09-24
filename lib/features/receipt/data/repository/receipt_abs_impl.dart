import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/connection/network_info.dart';
import '../../../../core/datasources/kaisa-backend/crud/kaisa_backend_ds.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/failure_n_success.dart';
import '../../domain/entity/receipt_entity.dart';
import '../../domain/repository/receipt_abs.dart';
import '../core/error/cloud_storage_exceptions.dart';
import '../core/error/receipt_failure_success.dart';
import '../provider/network/cloud_storage_ds.dart';
import '../provider/network/firestore_receipt_ds.dart';
import '../../../../core/errors/cloud_storage_exceptions.dart';

class ReceiptAbsImpl extends ReceiptAbs {
  ReceiptAbsImpl(this.firestoreReceiptDs);
  final FirestoreReceiptDs firestoreReceiptDs;
  final CloudStorageDs cloudStorageDs = CloudStorageDs();
  final KaisaBackendDS kaisaBackendDS = KaisaBackendDS();

  @override
  Future<Either<Failure, List<ReceiptEntity>>> fetchReceipts() async {
    try {
      final receipts = await firestoreReceiptDs.fetchReceipts();
      return Future.value(Right(receipts));
    } on CouldNotFetchException catch (e) {
      return Future.value(Left(ReceiptFailure(errorMessage: e.toString())));
    }
  }

  @override
  Future<Either<Failure, ReceiptEntity>> fetchReceipt(String imei, String shopId) async {
    try {
      final receipt = await firestoreReceiptDs.fetchReceipt(imei, shopId);
      return Future.value(Right(receipt));
    } on CouldNotFetchException catch (e) {
      return Future.value(Left(ReceiptFailure(errorMessage: e.toString())));
    }
  }

  @override
  Future<Either<Failure, void>> updateReceipt(ReceiptEntity receipt) async {
    final bool isConnected = await NetworkInfo.connectionChecker.hasConnection;

    if (!isConnected) {
      return Left(
        ReceiptFailure(errorMessage: 'You have no internet connection 🚩'),
      );
    }

    try {
      await firestoreReceiptDs.updateReceipt(receipt.toJson());
      return const Right(null);
    } on CouldNotUpdateException catch (e) {
      return Left(ReceiptFailure(errorMessage: e.toString()));
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

    try {
      List<String> downloadUrls = [];
      final fileNames = genFilenames(files.length, imei);

      for (int i = 0; i < files.length; i++) {
        // upload image
        final downloadUrl =
            await cloudStorageDs.uploadImage(files[i], fileNames[i]);

        // add to downloadUrls
        downloadUrls.add(downloadUrl);
      }

      return Future.value(Right(downloadUrls));
    } on CloudStorageExceptions catch (e) {
      return Future.value(Left(ReceiptFailure(errorMessage: e.toString())));
    }
  }

  @override
  Future<Either<Failure, void>> createReceipt(ReceiptEntity receipt) async {
    final bool isConnected = await NetworkInfo.connectionChecker.hasConnection;

    if (!isConnected) {
      return Left(
        ReceiptFailure(errorMessage: 'You have no internet connection 🚩'),
      );
    }

    try {
      await kaisaBackendDS.postReceipt(receipt.toJson());
      return const Right(null);
    } on PostDataException catch (e) {
      return Left(ReceiptFailure(errorMessage: e.toString()));
    }
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
