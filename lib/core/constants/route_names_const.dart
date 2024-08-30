/* class AppNamedRoutes {
  static String home = '/';
  static String toSignIn = '${home}signin';
  static String toForgotPass = '$toSignIn/forgot-password';
  static String toSignUp = '${home}signup';

  // from homepage
  static String toPurchaseLists = '${home}purchase-lists';
  static String fromHomeToPurchaseDetail = '${home}purchase-details';

  // from purchase lists
  static String toPurchaseDetail = '$toPurchaseLists/purchase-details';

  // from purchase detail
  static String toStatusUpdated(String id) {
    return '$toPurchaseDetail/$id/status-updated';
  }
} */
