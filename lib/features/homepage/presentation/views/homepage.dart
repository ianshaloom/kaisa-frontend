import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:kaisa/core/utils/extension_methods.dart';

import '../../../../router/route_names.dart';
import '../../../../theme/text_scheme.dart';
import '../../../phonetransaction/presentation/controller/phone_transaction_ctrl.dart';
import '../../../phonetransaction/presentation/widgets/recent_orders_pageview.dart';
import '../widgets/avatar_n_name.dart';
import '../widgets/homepage_menu.dart';
import '../../../phonetransaction/presentation/widgets/order_tile.dart';

final _ctrl = Get.find<PhoneTransactionCtrl>();

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Column(
        children: [
          const ProfilePreveiw(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  RecentOrdersPageView(),
                  const SizedBox(height: 5),
                  const HomeMenu(),
                  Row(
                    children: [
                      Text(
                        "Transaction History",
                        style: bodyBold(textTheme).copyWith(
                          fontSize: 13,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          context.go(AppNamedRoutes.toTransHistory);
                        },
                        child: Text(
                          "View All",
                          style: bodyMedium(textTheme).copyWith(
                              color: color.primary,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: Obx(
                      () {
                        if (_ctrl.phoneTransaction.isEmpty) {
                          return Center(
                            child: Text(
                              'No transaction history',
                              style: bodyMedium(textTheme).copyWith(
                                color: color.onSurface.withOpacity(0.5),
                              ),
                            ),
                          );
                        }

                        final trans = _ctrl.phoneTransaction.last24Hours();

                        return ListView.builder(
                          itemCount: trans.length,
                          itemBuilder: (context, index) {
                            final order = trans[index];
                            return OrderTile(order: order);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void ontap(BuildContext context) {
    Navigator.of(context).pushNamed('/non-posted');
  }
}

class HomePageTile extends StatelessWidget {
  final Function onTap;
  final String title;
  final String svg;
  final String role;
  const HomePageTile({
    super.key,
    required this.onTap,
    required this.title,
    required this.svg,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () =>
            (title == 'Non-Posted') ? onTap(context) : onTap(context, role),
        child: Card(
          margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.02,
          ),
          child: Container(
            margin: const EdgeInsets.all(10),
            //height: 115,
            //width: 110,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(svg, height: 100, width: 70),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelMedium,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SquareTile extends StatelessWidget {
  final String title;
  final String svgPath;
  final Color color;
  final Function onTap;

  const SquareTile({
    super.key,
    required this.title,
    required this.svgPath,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () => onTap(),
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          /* border: Border.all(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
          ), */
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 23,
              child: SvgPicture.asset(
                svgPath,
                height: 30,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: bodyMedium(textTheme).copyWith(fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
