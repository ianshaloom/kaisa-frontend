import 'package:dartz/dartz.dart';

import '../core/connection/network_info.dart';
import '../core/datasources/firestore/crud/kaisa_users_ds.dart';
import '../core/datasources/firestore/models/kaisa-user/kaisa_user.dart';
import '../core/errors/failure_n_success.dart';
import 'shared_failure_success.dart';
import 'shared_abs.dart';

class SharedAbsImpl implements SharedAbs{
     @override
  Future<Either<Failure, List<KaisaUser>>> fetchUsers() async {
     final bool isConnected = await NetworkInfo.connectionChecker.hasConnection;

    if (!isConnected) {
      return Left(
        SharedFailure(errorMessage: 'You have no internet connection 🚩'),
      );
    } 

    try {
      final users = await FirestoreUsersDs.fetchUsers();

      return Right(users);
    } catch (e) {
      return Left(SharedFailure(errorMessage: e.toString()));
    }
  }

     @override
  Future<Either<Failure, List<String>>> fetchShops() async {
     final bool isConnected = await NetworkInfo.connectionChecker.hasConnection;

    if (!isConnected) {
      return Left(
        SharedFailure(
            errorMessage: 'You have no internet connection 🚩'),
      );
    } 
    try {
      final users = await FirestoreUsersDs.fetchShops();

      return Right(users);
    } catch (e) {
      return Left(SharedFailure(errorMessage: e.toString()));
    }
  }
}