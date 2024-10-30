import 'package:dartz/dartz.dart';

import '../core/datasources/firestore/models/kaisa-user/kaisa_user.dart';
import '../core/errors/failure_n_success.dart';

abstract class SharedAbs {
  Future<Either<Failure, List<KaisaUser>>> fetchUsers();
  Future<Either<Failure, List<String>>> fetchShops();
}