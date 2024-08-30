class AuthenticationException implements Exception {
  final String message;
  AuthenticationException({this.message = 'An error occurred during authentication'});
  @override
  String toString() => message;
}
