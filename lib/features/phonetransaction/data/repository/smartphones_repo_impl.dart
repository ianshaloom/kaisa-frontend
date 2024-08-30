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
  Future<Either<Failure, List<SmartphoneEntity>>> fetchSmartphones() async {
    try {
      final smartphones = await _firestoreSmartPhoneDs.fetchSmartPhones();

      return Future.value(Right(smartphones));
    } on CouldNotFetchException catch (e) {
      return Future.value(Left(SmartphoneFailure(errorMessage: e.toString())));
    }
  }
}
