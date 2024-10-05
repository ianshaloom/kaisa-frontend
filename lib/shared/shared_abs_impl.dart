import 'package:dartz/dartz.dart';

import '../core/datasources/firestore/crud/kaisa_users_ds.dart';
import '../core/datasources/firestore/models/kaisa-user/kaisa_user.dart';
import '../core/errors/failure_n_success.dart';
import 'shared_failure_success.dart';
import 'shared_abs.dart';

class SharedAbsImpl implements SharedAbs{
     @override
  Future<Either<Failure, List<KaisaUser>>> fetchUsers() async {
    try {
      final users = await FirestoreUsersDs.fetchUsers();

      return Right(users);
    } catch (e) {
      return Left(SharedFailure(errorMessage: e.toString()));
    }
  }
}