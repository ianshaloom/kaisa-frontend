import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../shared/shared_ctrl.dart';
import '../../theme/text_scheme.dart';
import 'shoptile.dart';

class ShopsView extends StatelessWidget {
  const ShopsView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final shCtrl = Get.find<SharedCtrl>();
    shCtrl.fetchShops();

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text(
            'Kaisa Shops',
            style: bodyMedium(textTheme).copyWith(fontSize: 13),
          ),
          centerTitle: true,
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
            if (shCtrl.requestInProgress.value) {
              return const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return ShopTile(shop: shCtrl.kaisaShops[index]);
                },
                childCount: shCtrl.kaisaShops.length,
              ),
            );
          },
        ),
      ],
    );
  }
}
