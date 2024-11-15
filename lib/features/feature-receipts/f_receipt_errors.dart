// receipt success and failures
import '../../core/errors/failure_n_success.dart';

class ReceiptFailure extends Failure {
  ReceiptFailure({required String errorMessage})
      : super(errorMessage: errorMessage);
}

class ReceiptSuccess extends Success {
  ReceiptSuccess({required String successContent})
      : super(successContent: successContent);
}


class CloudStorageExceptions implements Exception {
  final String message;
  CloudStorageExceptions(this.message);
}
