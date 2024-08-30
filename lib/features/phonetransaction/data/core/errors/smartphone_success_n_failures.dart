
import '../../../../../core/errors/failure_n_success.dart';

// smartphone success and failures
class SmartphoneFailure extends Failure {
  SmartphoneFailure({required String errorMessage})
      : super(errorMessage: errorMessage);
}

class SmartphoneSuccess extends Success {
  SmartphoneSuccess({required String successContent})
      : super(successContent: successContent);
}

// phone transaction success and failures
class PhoneTransactionFailure extends Failure {
  PhoneTransactionFailure({required String errorMessage})
      : super(errorMessage: errorMessage);
}

class PhoneTransactionSuccess extends Success {
  PhoneTransactionSuccess({required String successContent})
      : super(successContent: successContent);
}
