import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure_n_success.dart';
import '../entity/smartphone_entity.dart';
import '../repository/smartphones_repo.dart';

class SmartphonesUsecase {
  final SmartphonesRepo _smartphonesRepo;
  SmartphonesUsecase(this._smartphonesRepo);

  Future<Either<Failure, List<SmartphoneEntity>>> fetchSmartphones() async {
    return await _smartphonesRepo.fetchSmartphones();
  }
}
