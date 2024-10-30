import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/shared_ctrl.dart';
import '../../../theme/text_scheme.dart';
import '../shop_ctrl.dart';

class ShopSwitch extends StatelessWidget {
  const ShopSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ShopCtrl>();
    final shCtrl = Get.find<SharedCtrl>();

    final uuid = shCtrl.userData.shopId;
    
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final color1 = color.primary;
    final color2 = color.onSurface.withOpacity(0.2);
    final font = bodyBold(textTheme).copyWith(
      fontSize: 13,
      fontWeight: FontWeight.w700,
    );
    final font1 = font.copyWith( 
      color: color1,
    );

    final font2 = font.copyWith(
      color: color2,
    );

    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Spacer(),
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => ctrl.navOnPressed(0, uuid),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                'My Shop',
                style: ctrl.navIndex.value == 0 ? font1 : font2,
              ),
            ),
          ),
          Text(' | ', style: bodyBold(textTheme)),
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => ctrl.navOnPressed(1, uuid),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                'Weekly Ranking',
                style: ctrl.navIndex.value == 1 ? font1 : font2,
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
