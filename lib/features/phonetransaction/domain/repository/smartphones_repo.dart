import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure_n_success.dart';
import '../entity/smartphone_entity.dart';

abstract class SmartphonesRepo {
  // create a smartphone
  Future<Either<Failure, void>> createSmartphone({
    required SmartphoneEntity smartphone,
  });

  // get all smartphones
  Future<Either<Failure, List<SmartphoneEntity>>> fetchSmartphones();

  // update a smartphone
  Future<Either<Failure, void>> updateSmartphone({
    required SmartphoneEntity smartphone,
  });

  // delete a smartphone
  Future<Either<Failure, void>> deleteSmartphone({
    required String id,
  });

}
