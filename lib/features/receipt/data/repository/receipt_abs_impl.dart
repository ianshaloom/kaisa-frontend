import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure_n_success.dart';
import '../../domain/entity/receipt_entity.dart';
import '../../domain/repository/receipt_abs.dart';
import '../core/error/receipt_failure_success.dart';
import '../provider/network/firestore_receipt_ds.dart';
import '../../../../core/errors/cloud_storage_exceptions.dart';

class ReceiptAbsImpl extends ReceiptAbs{
  ReceiptAbsImpl(this.firestoreReceiptDs);
  final FirestoreReceiptDs firestoreReceiptDs;
  @override
  Future<Either<Failure, void>> createReceipt(ReceiptEntity receipt) async{
    try {
      await firestoreReceiptDs.createReceipt(receipt.toJson());
      return const Right(null);
    } on CouldNotCreateException catch (e) {
      return Left(ReceiptFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ReceiptEntity>>> fetchReceipts() async{
    try {
      final receipts = await firestoreReceiptDs.fetchReceipts();
      return Future.value(Right(receipts));
    } on CouldNotFetchException catch (e) {
      return Future.value(Left(ReceiptFailure(errorMessage: e.toString())));
    }
  }

  @override
  Future<Either<Failure, void>> updateReceipt(ReceiptEntity receipt) async {
    try {
     await  firestoreReceiptDs.updateReceipt(receipt.toJson());
      return const Right(null);
    } on CouldNotUpdateException catch (e) {
      return Left(ReceiptFailure(errorMessage: e.toString()));
    }
  }
  
}