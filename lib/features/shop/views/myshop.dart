import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/constants/image_path_const.dart';
import '../../../shared/shared_models.dart';
import '../../../theme/text_scheme.dart';
import '../../receipt/domain/entity/receipt_entity.dart';
import '../shop_ctrl.dart';
import '../widgets/donut_chart.dart';
import 'receipt_list.dart';

final _ctrl = Get.find<ShopCtrl>();

class MyShop extends StatelessWidget {
  const MyShop({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Obx(
      () {
        if (_ctrl.processingRequest1.value) {
          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: color.primary,
              size: 50,
            ),
          );
        }

        if (_ctrl.weeklySalesFailure != null) {
          return Center(
            child: Text(_ctrl.weeklySalesFailure!.errorMessage),
          );
        }

        return const Column(
          children: [
            AccMetrics(),
            SizedBox(height: 10),
            WeekliView(),
          ],
        );
      },
    );
  }
}

class AccMetrics extends StatelessWidget {
  const AccMetrics({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (_ctrl.weeklySales.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: SvgPicture.asset(
              graph,
              height: 100,
              width: 100,
              // colorFilter: ColorFilter.mode(color.primary, BlendMode.srcIn),
            ),
          );
        }

        return AnimatedPieChart(
          stokeWidth: 20.0,
          padding: 5,
          animatedSpeed: 200,
          pieRadius: 70,
          totalSales: _ctrl.weeklySales.length,
          segments: _ctrl.buildPieChartData(),
        );
      },
    );
  }
}

class WeekliView extends StatelessWidget {
  const WeekliView({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        decoration: BoxDecoration(
          color: color.surfaceBright,
          borderRadius: const BorderRadius.vertical(
              top: Radius.circular(40), bottom: Radius.circular(30)),
          // top box shadow
          boxShadow: [
            BoxShadow(
              color: color.primary.withOpacity(0.05),
              offset: const Offset(0, -5),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          children: [
            _handle(context),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                children: [
                  const Spacer(),
                  Text(
                    'Weekly Sales',
                    style: bodyBold(textTheme).copyWith(
                      fontSize: 13,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            Expanded(
              // child: RecentOrders(),
              child: Obx(() {
                if (_ctrl.processingRequest1.value) {
                  return _shimmerGridView(context);
                }

                if (_ctrl.weeklySales.isEmpty) {
                  return Center(
                    child: Text(
                      'Oops!\n\n You have ZERO weekly sales',
                      textAlign: TextAlign.center,
                      style: bodyMedium(textTheme).copyWith(
                        color: color.onSurface,
                      ),
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    mainAxisExtent: 120,
                    childAspectRatio: 0.5,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: _ctrl.listDailySales.length,
                  itemBuilder: (context, index) {
                    final pie = _ctrl.listDailySales[index];

                    return WeekTile(
                      onClick: () => Navigator.of(context).push(
                        toReceitView(pie.sales, pie.fullDayOfTheWeek),
                      ),
                      dailySale: pie,
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Route toReceitView(List<ReceiptEntity> receipts, String day) {
    return PageRouteBuilder<SlideTransition>(
      pageBuilder: (context, animation, secondaryAnimation) =>
          ReceiptsPage(day: day, receipts: receipts),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        //  create a slide animation that brings the new page from right to left
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  Widget _handle(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Container(
      height: 4,
      width: 50,
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: color.primary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Widget _shimmerGridView(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return GridView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        mainAxisExtent: 120,
        childAspectRatio: 0.5,
        crossAxisSpacing: 10,
      ),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: color.primary.withOpacity(0.1),
          highlightColor: color.primary.withOpacity(0.2),
          child: Container(
            decoration: BoxDecoration(
              color: color.surface,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
    );
  }
}

class WeekTile extends StatelessWidget {
  final Function() onClick;
  final double? circularColorSize;
  final DailySales dailySale;

  const WeekTile({
    super.key,
    required this.onClick,
    required this.dailySale,
    this.circularColorSize,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(25),
      onTap: onClick,
      child: Container(
        // height: 100,
        padding: const EdgeInsets.only(
          left: 20,
          top: 12,
          bottom: 16,
          right: 20,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: colorScheme.primary.withOpacity(0.04),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  dailySale.fullDayOfTheWeek,
                  style: bodyRegular(textTheme),
                ),
                const Spacer(),
                Text(
                  NumberFormat('00').format(dailySale.salesCount),
                  style: bodyBold(textTheme).copyWith(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const Spacer(),
            CircleAvatar(
              radius: 20,
              backgroundColor: dailySale.color,
              child: Icon(
                Icons.arrow_outward,
                color: colorScheme.onPrimary,
              ),
            )
          ],
        ),
      ),
    );
  }
}
