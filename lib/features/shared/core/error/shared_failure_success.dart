import '../../../../../../core/errors/failure_n_success.dart';

// stock success and failures
class SharedFailure extends Failure {
  SharedFailure({required String errorMessage})
      : super(errorMessage: errorMessage);
}

class SharedSuccess extends Success {
  SharedSuccess({required String successContent})
      : super(successContent: successContent);
}
