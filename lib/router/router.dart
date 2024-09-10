import 'package:go_router/go_router.dart';

import '../features/authentication/presentation/views/forgot_password_page.dart';
import '../features/authentication/presentation/views/sign_in_page.dart';
import '../features/authentication/presentation/views/sign_up_page.dart';
import '../features/phonetransaction/presentation/views/order_detail_page.dart';
import '../features/phonetransaction/presentation/views/cancelling_order.dart';
import '../features/phonetransaction/presentation/views/receive_scan.dart';
import '../features/phonetransaction/presentation/views/receiving_order.dart';
import '../features/phonetransaction/presentation/views/sending_order.dart';
import '../features/phonetransaction/presentation/views/send_scan.dart';
import '../features/phonetransaction/presentation/views/smartphone_detail.dart';
import '../features/phonetransaction/presentation/views/smartphone_grid_list.dart';
import '../features/phonetransaction/presentation/views/trans_history.dart';
import '../features/profile/presentation/views/profile_view.dart';
import '../features/zkeleton/views/zleton.dart';

final router = GoRouter(
  debugLogDiagnostics: true,
  routes: <GoRoute>[
    GoRoute(
      path: RoutePath.root.path,
      name: RoutePath.root.name,
      builder: (context, state) => const Zleton(),
      routes: [
        GoRoute(
          path: RoutePath.signIn.path,
          name: RoutePath.signIn.name,
          builder: (context, state) => SignInPage(),
          routes: [
            GoRoute(
              path: RoutePath.forgotPassword.path,
              name: RoutePath.forgotPassword.name,
              builder: (context, state) => ForgotPasswordPage(),
            ),
          ],
        ),
        GoRoute(
          path: RoutePath.signUp.path,
          name: RoutePath.signUp.name,
          builder: (context, state) => const SignUpPage(),
        ),

        // root page is Home page, to show order details
        GoRoute(
          path: RoutePath.orderDetailFromHome.path,
          name: RoutePath.orderDetailFromHome.name,
          builder: (context, state) {
            return const OrderDetailPage();
          },
          routes: [
            GoRoute(
              path: RoutePath.cancelOrder.path,
              name: RoutePath.cancelOrder.name,
              builder: (context, state) => const CancellingOrder(),
            ),
            GoRoute(
              path: RoutePath.receiveScan.path,
              name: RoutePath.receiveScan.name,
              builder: (context, state) => const ReceiveScan(),
            ),
            GoRoute(
              path: RoutePath.receiveOrder.path,
              name: RoutePath.receiveOrder.name,
              builder: (context, state) => const ReceivingOrder(),
            ),
          ],
        ),

        // root page is Home page, to show smartphones grid list
        GoRoute(
          path: RoutePath.smartphonesGridList.path,
          name: RoutePath.smartphonesGridList.name,
          builder: (context, state) => const SmartphonesGridList(),
          routes: [
            GoRoute(
              path: RoutePath.smartphoneDetailFromGridList.path,
              name: RoutePath.smartphoneDetailFromGridList.name,
              builder: (context, state) {
                return const SmartphoneDetailPage();
              },
              routes: [
                GoRoute(
                  path: RoutePath.sendOrder.path,
                  name: RoutePath.sendOrder.name,
                  builder: (context, state) => const SendingOrder(),
                ),
                GoRoute(
                  path: RoutePath.sendScan.path,
                  name: RoutePath.sendScan.name,
                  builder: (context, state) => const SendScan(),
                ),
              ],
            ),
          ],
        ),

        // root page is Home page, to show transactions history
        GoRoute(
          path: RoutePath.transHistory.path,
          name: RoutePath.transHistory.name,
          builder: (context, state) => const TransHistoryView(),
          routes: [
            GoRoute(
                path: RoutePath.transHistoryDetails.path,
                name: RoutePath.transHistoryDetails.name,
                builder: (context, state) {
                  return const OrderDetailPage();
                },
                routes: [
                  GoRoute(
                    path: RoutePath.cancelOrderTH.path,
                    name: RoutePath.cancelOrderTH.name,
                    builder: (context, state) => const CancellingOrder(),
                  ),
                  GoRoute(
                    path: RoutePath.receiveScanTH.path,
                    name: RoutePath.receiveScanTH.name,
                    builder: (context, state) => const ReceiveScan(),
                  ),
                  GoRoute(
                    path: RoutePath.receiveOrderTH.path,
                    name: RoutePath.receiveOrderTH.name,
                    builder: (context, state) => const ReceivingOrder(),
                  ),
                ],
              ),

          ]
        ),

        // root page is Home page, to show profile details
        GoRoute(
          path: RoutePath.profile.path,
          name: RoutePath.profile.name,
          builder: (context, state) => const ProfileView(),
        ),
      ],
    ),
  ],
);

enum RoutePath {
  root(path: '/'),
  signIn(path: 'signin'),
  signUp(path: 'signup'),
  verifyEmail(path: 'email-verified'),
  forgotPassword(path: 'forgot-password'),
  smartphonesGridList(path: 'smartphone-grid-list'),
  smartphoneDetailFromGridList(path: 'smartphone-details'), //
  orderDetailFromHome(path: 'order-details'),
  sendOrder(path: 'send-order'),
  sendScan(path: 'send-scan'),
  receiveScan(path: 'receive-scan'),
  receiveOrder(path: 'receive-order'),
  cancelOrder(path: 'cancel-order'),
  transHistory(path: 'transactions-history'),
  transHistoryDetails(path: 'transHistory-details'),
    receiveScanTH(path: 'receive-scan-TH'),
  receiveOrderTH(path: 'receive-order-TH'),
  cancelOrderTH(path: 'cancel-order-TH'),
  profile(path: 'profile'),
  ;

  const RoutePath({required this.path});
  final String path;
}
