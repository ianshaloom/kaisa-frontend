import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure_n_success.dart';
import '../entity/smartphone_entity.dart';

abstract class SmartphonesRepo {
  // get all smartphones
  Future<Either<Failure, List<SmartphoneEntity>>> fetchSmartphones();

}
