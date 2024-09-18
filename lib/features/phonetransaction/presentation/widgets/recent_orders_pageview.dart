import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:kaisa/core/utils/extension_methods.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/constants/image_path_const.dart';
import '../../../../core/datasources/firestore/models/phone-transaction/phone_transaction.dart';
import '../../../../core/utils/utility_methods.dart';
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
      child: StreamBuilder<List<PhoneTransaction>>(
        stream: _ctrl.streamKOrderTranscById(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: bodyMedium(Theme.of(context).textTheme),
              ),
            );
          }

          if (snapshot.hasData) {
            var data = snapshot.data as List<PhoneTransaction>;
            data.sort((a, b) => b.dateTime.compareTo(a.dateTime));
            _ctrl.delayTwoSeconds(data);

            data = data.todaysPhoneTransactions();

            return Column(children: [
              Expanded(
                child: data.isEmpty
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
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final transaction = data[index];

                          return RecentsPageTile(transaction: transaction);
                        },
                      ),
              ),
              data.isEmpty
                  ? const SizedBox()
                  : SmoothPageIndicator(
                      controller: controller,
                      count: data.length,
                      effect: WormEffect(
                        dotWidth: 5,
                        dotHeight: 5,
                        activeDotColor: color.primary,
                        dotColor: color.onSurface.withOpacity(0.5),
                      ),
                    ),
            ]);
          } else {
            return Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: color.primary,
                size: 50,
              ),
            );
          }
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
        _ctrl.actionFromTH = false;
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
        height: 130,
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Text(
                        transaction.deviceName,
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
                        'From ${transaction.senderAddress} \n to ${transaction.receiverAddress}',
                        style: bodyLarge(textTheme).copyWith(
                            color: color.onSurface.withOpacity(0.5),
                            fontSize: 12),
                      ),
                    ],
                  ),
                  const Spacer(),
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
                          style: bodyMedium(textTheme),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: 110,
              child: CachedNetworkImage(
                imageUrl: generateImageUrl(transaction.imgUrl),
              ),
            )
          ],
        ),
      ),
    );
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
