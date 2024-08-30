import 'package:dartz/dartz.dart';

import '../../../../core/errors/cloud_storage_exceptions.dart';
import '../../../../core/errors/failure_n_success.dart';
import '../../domain/entity/smartphone_entity.dart';
import '../../domain/repository/smartphones_repo.dart';
import '../core/errors/smartphone_success_n_failures.dart';
import '../provider/network/firestore_smartphone_ds.dart';

class SmartphonesRepoImpl implements SmartphonesRepo {
  SmartphonesRepoImpl(this._firestoreSmartPhoneDs);
  final FirestoreSmartPhoneDs _firestoreSmartPhoneDs;

  @override
  Future<Either<Failure, void>> createSmartphone({
    required SmartphoneEntity smartphone,
  }) async {
    try {
      await _firestoreSmartPhoneDs.createSmartPhone(smartphone: smartphone);

      return Future.value(const Right(null));
    } on CouldNotCreateException catch (e) {
      return Future.value(Left(SmartphoneFailure(errorMessage: e.toString())));
    }
  }

  @override
  Future<Either<Failure, List<SmartphoneEntity>>> fetchSmartphones() async {
    try {
      final smartphones = await _firestoreSmartPhoneDs.fetchSmartPhones();

      return Future.value(Right(smartphones));
    } on CouldNotFetchException catch (e) {
      return Future.value(Left(SmartphoneFailure(errorMessage: e.toString())));
    }
  }

  @override
  Future<Either<Failure, void>> updateSmartphone({
    required SmartphoneEntity smartphone,
  }) async {
    try {
      await _firestoreSmartPhoneDs.updateSmartPhone(smartphone: smartphone);

      return Future.value(const Right(null));
    } on CouldNotUpdateException catch (e) {
      return Future.value(Left(SmartphoneFailure(errorMessage: e.toString())));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSmartphone({
    required String id,
  }) async {
    try {
      await _firestoreSmartPhoneDs.deleteSmartPhone(id: id);

      return Future.value(const Right(null));
    } on CouldNotDeleteException catch (e) {
      return Future.value(Left(SmartphoneFailure(errorMessage: e.toString())));
    }
  }
}
