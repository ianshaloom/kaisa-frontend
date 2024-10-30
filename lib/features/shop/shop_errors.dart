import '../../../core/errors/failure_n_success.dart';

// stock success and failures
class ShopFailure extends Failure {
  ShopFailure({required String errorMessage})
      : super(errorMessage: errorMessage);
}

class ShopSuccess extends Success {
  ShopSuccess({required String successContent})
      : super(successContent: successContent);
}
