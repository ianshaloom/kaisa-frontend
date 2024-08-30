import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/constants/image_path_const.dart';
import '../../../../core/constants/network_const.dart';
import '../../../../core/datasources/firestore/models/phone-transaction/phone_transaction.dart';
import '../../../../router/route_names.dart';
import '../../../../theme/text_scheme.dart';
import '../controller/phone_transaction_ctrl.dart';

final _ctrl = Get.find<PhoneTransactionCtrl>();

class RecentOrdersPageView extends StatelessWidget {
  RecentOrdersPageView({super.key});

  final controller = PageController();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return SizedBox(
      height: 200,
      child: Obx(
        () {
          if (_ctrl.processingRequestTwo.value) {
            return Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: color.primary,
                size: 50,
              ),
            );
          }

          final trans = _ctrl.todaysTranscs;

          return Column(
            children: [
              Expanded(
                child: trans.isEmpty
                    ? Container(
                        height: 160,
                        padding: const EdgeInsets.all(30),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              color.primary.withOpacity(0.5),
                              color.primary.withOpacity(0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SvgPicture.asset(
                          recentOrders,
                        ),
                      )
                    : PageView.builder(
                        controller: controller,
                        scrollDirection: Axis.horizontal,
                        itemCount: trans.length,
                        itemBuilder: (context, index) {
                          final transaction = trans[index];

                          return RecentsPageTile(transaction: transaction);
                        },
                      ),
              ),
              trans.isEmpty
                  ? const Center()
                  : SmoothPageIndicator(
                      controller: controller,
                      count: trans.length,
                      effect: WormEffect(
                        dotWidth: 5,
                        dotHeight: 5,
                        activeDotColor: color.primary,
                        dotColor: color.onSurface.withOpacity(0.5),
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }
}

class RecentsPageTile extends StatelessWidget {
  final PhoneTransaction transaction;
  const RecentsPageTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        _ctrl.selectedTransaction = transaction;
        context.go(AppNamedRoutes.toOrderDetails);
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.primary.withOpacity(0.2),
              color.primary.withOpacity(0.02),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        height: 160,
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Text(
                        transaction.phoneName,
                        style: bodyLarge(textTheme).copyWith(
                            color: color.onSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      const SizedBox(height: 7),
                      Row(
                        children: [
                          Text(
                            'RAM ${transaction.ram}',
                            style: bodyLarge(textTheme).copyWith(
                                color: color.onSurface.withOpacity(0.5),
                                fontSize: 12),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '~  Storage ${transaction.storage}',
                            style: bodyLarge(textTheme).copyWith(
                                color: color.onSurface.withOpacity(0.5),
                                fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 7),
                      Text(
                        transaction.isSender
                            ? 'To ${transaction.receiverAddress}'
                            : 'From ${transaction.senderAddress}',
                        style: bodyLarge(textTheme).copyWith(
                            color: color.onSurface.withOpacity(0.5),
                            fontSize: 12),
                      ),
                    ],
                  ),
                  // const Spacer(),
                  Container(
                    height: 30,
                    width: 105,
                    margin: const EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      color: color.surface,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 13,
                          width: 13,
                          margin: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            color: statusColor(color),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: statusColorBlur(color),
                                blurRadius: 5,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          transaction.status,
                          style: bodyDefault(textTheme),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Container(
              height: 120,
              width: 90,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('$kBaseUrlShop${transaction.imgUrl}'),
                  fit: BoxFit.cover,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  bool isDelivered() {
    return transaction.status == 'Delivered';
  }

  bool isCancelled() {
    return transaction.status == 'Cancelled';
  }

  Color statusColorBlur(ColorScheme color) {
    if (transaction.status == 'Delivered') {
      return Colors.green.withOpacity(0.3);
    } else if (transaction.status == 'Pending') {
      return color.primary.withOpacity(0.3);
    } else {
      return Colors.black45;
    }
  }

  Color statusColor(ColorScheme color) {
    if (transaction.status == 'Delivered') {
      return Colors.green;
    } else if (transaction.status == 'Pending') {
      return color.primary;
    } else {
      return Colors.grey;
    }
  }
}
