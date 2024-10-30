import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../theme/text_scheme.dart';
import 'shop_ctrl.dart';
import 'widgets/all_tile.dart';

class ShopRanks extends StatelessWidget {
  const ShopRanks({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ShopCtrl>();
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final controller = ctrl.scrollController;

    return Obx(
      () {
        if (ctrl.processingRequest2.value) {
          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: color.primary,
              size: 50,
            ),
          );
        }

        if (ctrl.shopAnalysisFailure != null) {
          return Center(
            child: Text(ctrl.shopAnalysisFailure!.errorMessage),
          );
        }

        if (ctrl.shopAnalysis.isEmpty) {
          return Center(
            child: Text(
              'No Shop Analysis Data',
              style: bodyMedium(textTheme),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10),
          controller: controller
            ..addListener(() {
              if (!(controller.offset >= 50)) {
                ctrl.showFab.value = true;
              } else {
                ctrl.showFab.value = false;
              }
            }),
          itemCount: ctrl.shopAnalysis.length,
          itemBuilder: (context, index) {
            final shop = ctrl.shopAnalysis[index];
            return AnaliticsTile(shop: shop);
          },
        );
      },
    );
  }
}
