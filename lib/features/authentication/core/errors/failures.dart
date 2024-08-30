import '../../../../core/errors/failure_n_success.dart';

class AuthFailure extends Failure {
  AuthFailure({required String errorMessage})
      : super(errorMessage: errorMessage);
}
