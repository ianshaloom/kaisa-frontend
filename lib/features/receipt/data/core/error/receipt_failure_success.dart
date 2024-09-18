import '../../../../../../core/errors/failure_n_success.dart';

// receipt success and failures
class ReceiptFailure extends Failure {
  ReceiptFailure({required String errorMessage})
      : super(errorMessage: errorMessage);
}

class ReceiptSuccess extends Success {
  ReceiptSuccess({required String successContent})
      : super(successContent: successContent);
}
