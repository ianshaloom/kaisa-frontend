class AppNamedRoutes {
  // Authentication routes
  static String root = '/';
  static String landing = '${root}landing';
  static String toSignIn = '${root}signin';
  static String toSignUp = '${root}signup';
  static String toForgotPass = '$toSignIn/forgot-password';

  // from homepage
  static String home = '${root}home';
  static String toSmartPhonesGrid = '${root}smartphone-grid-list';
  static String toOrderDetails = '${root}order-details';
  static String toTransHistory = '${root}transactions-history';
  static String toProfile = '${root}profile';
  static String toStock = '${root}stock';
  static String toReceipt = '${root}receipt';
  static String toShop = '${root}shop';


  // from order details
  static String toCancellingOrder = '$toOrderDetails/cancel-order';
  static String toReceiveScan = '$toOrderDetails/receive-scan';
  static String toReceivingOrder = '$toOrderDetails/receive-order';

  // from smartphones grid lists
  static String toSmartPhoneDetails = '$toSmartPhonesGrid/smartphone-details';
  static String toSendScan = '$toSmartPhoneDetails/send-scan';
  static String toSendingOrder = '$toSmartPhoneDetails/send-order';

  // from transactions history
  static String toTransHistoryDetails = '$toTransHistory/transHistory-details';
  static String toCancellingOrderTH = '$toTransHistoryDetails/cancel-order-TH';
  static String toReceiveScanTH = '$toTransHistoryDetails/receive-scan-TH';
  static String toReceivingOrderTH = '$toTransHistoryDetails/receive-order-TH';
}
