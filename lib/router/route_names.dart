class AppNamedRoutes {
  // Authentication routes
  static String root = '/';
  static String landing = '${root}landing';

  static String toSignIn = '${root}signin';
  static String toForgotPass = '$toSignIn/forgot-password';
  static String toSignUp = '${root}signup';

  // from homepage
  static String home = '${root}home';
  static String toSmartPhonesGrid = '${root}smartphone-grid-list';
  static String toSmartPhoneDetails = '$toSmartPhonesGrid/smartphone-details';

  static String toOrderDetails = '${root}order-details';
  static String toReceivingOrder = '$toOrderDetails/receive-order';
  static String toReceiveScan = '$toOrderDetails/receive-scan';
  static String toCancellingOrder = '$toOrderDetails/cancel-order';

  // from smartphones grid lists

  static String toSendScan = '$toSmartPhoneDetails/send-scan';
  static String toSendingOrder = '$toSmartPhoneDetails/send-order';
}
