import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaisa/theme/text_scheme.dart';

import '../../../../shared/shared_models.dart';
import '../controller/analytics_ctrl.dart';
import '../widget/all_tile.dart';
import '../widget/analytics_view_appbar.dart';
import 'receipt_list.dart';

final _shCtrl = Get.find<AnalyticsCtlr>();

class AnalyticsView extends StatelessWidget {
  const AnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          title: ShopViewAppbar(),
          automaticallyImplyLeading: false,
          floating: true,
          snap: true,
          scrolledUnderElevation: 0,
          elevation: 0,
          // pinned: true,
          toolbarHeight: 50,
          /*  bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: ShopViewAppbar(),
            ),
          ), */
        ),
        Obx(
          () {
            if (_shCtrl.isGettingAnalysisData.value) {
              return const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (_shCtrl.requestFailure != null) {
              return SliverFillRemaining(
                child: Center(
                  child: Text(_shCtrl.requestFailure!.errorMessage),
                ),
              );
            }

            if (_shCtrl.shopAnalysisData.isEmpty) {
              return const SliverFillRemaining(
                child: Center(
                  child: Text('No Shop Analysis Data'),
                ),
              );
            }
            return SliverList.builder(
              itemCount: _shCtrl.shopAnalysisData.length,
              itemBuilder: (context, index) {
                if (_shCtrl.index.value != 0) {
                  final shop = _shCtrl.shopAnalysisData[index];

                  return ListTile(
                    onTap: () => Navigator.of(context).push(toReceitForm(shop)),
                    leading: CircleAvatar(
                      child: Center(
                        child: Text(
                          shop.totalSalesString,
                          style: bodyBold(textTheme),
                        ),
                      ),
                    ),
                    title: Text(
                      shop.shopName,
                      style: bodyBold(textTheme),
                    ),
                  );
                }

                final shop = _shCtrl.shopAnalysisData[index];
                return AnaliticsTile(shop: shop);
              },
            );
          },
        ),
      ],
    );
  }

  Route toReceitForm(ShopAnalysis shop) {
    return PageRouteBuilder<SlideTransition>(
      pageBuilder: (context, animation, secondaryAnimation) =>
          ShopReceipts(shop: shop),
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
}
