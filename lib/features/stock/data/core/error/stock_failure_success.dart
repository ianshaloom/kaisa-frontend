import '../../../../../../core/errors/failure_n_success.dart';

// stock success and failures
class StockFailure extends Failure {
  StockFailure({required String errorMessage})
      : super(errorMessage: errorMessage);
}

class StockSuccess extends Success {
  StockSuccess({required String successContent})
      : super(successContent: successContent);
}
