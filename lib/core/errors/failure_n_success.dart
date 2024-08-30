abstract class Failure {
  final String errorMessage;
  const Failure({required this.errorMessage});
}

abstract class Success {
  final String successContent;
  const Success({required this.successContent});
}
