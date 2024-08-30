import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure_n_success.dart';
import '../entity/smartphone_entity.dart';
import '../repository/smartphones_repo.dart';

class SmartphonesUsecase {
  final SmartphonesRepo _smartphonesRepo;
  SmartphonesUsecase(this._smartphonesRepo);

  Future<Either<Failure, void>> createSmartphone({
    required SmartphoneEntity smartphone,
  }) async {
    return await _smartphonesRepo.createSmartphone(smartphone: smartphone);
  }

  Future<Either<Failure, List<SmartphoneEntity>>> fetchSmartphones() async {
    return await _smartphonesRepo.fetchSmartphones();
  }

  Future<Either<Failure, void>> updateSmartphone({
    required SmartphoneEntity smartphone,
  }) async {
    return await _smartphonesRepo.updateSmartphone(smartphone: smartphone);
  }

  Future<Either<Failure, void>> deleteSmartphone({
    required String id,
  }) async {
    return await _smartphonesRepo.deleteSmartphone(id: id);
  }
}
