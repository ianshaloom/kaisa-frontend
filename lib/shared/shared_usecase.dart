import 'package:dartz/dartz.dart';

import '../core/datasources/firestore/models/kaisa-user/kaisa_user.dart';
import '../core/errors/failure_n_success.dart';
import 'shared_abs.dart';

class SharedUsecase {
  final SharedAbs sharedAbs;
  SharedUsecase(this.sharedAbs);

    // fetch Users
  Future<Either<Failure, List<KaisaUser>>> fetchUsers() {
    return sharedAbs.fetchUsers();
  }

  // fetch Shops
  Future<Either<Failure, List<String>>> fetchShops() {
    return sharedAbs.fetchShops();
  }
}