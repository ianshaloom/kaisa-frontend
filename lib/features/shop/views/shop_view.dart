import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaisa/theme/text_scheme.dart';

import '../../../shared/shared_ctrl.dart';
import 'myshop.dart';
import '../shop_ctrl.dart';
import '../shop_ranks.dart';
import '../widgets/shop_switch.dart';

class ShopView extends StatelessWidget {
  const ShopView({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final ctrl = Get.find<ShopCtrl>();
    final shopName = Get.find<SharedCtrl>().userData.shop;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Obx(
          () => ctrl.navIndex.value == 0
              ? Text(
                  shopName,
                  style: bodyMedium(textTheme).copyWith(
                    fontSize: 14,
                  ),
                )
              : Text(
                  'Shop Ranks',
                  style: bodyMedium(textTheme).copyWith(
                    fontSize: 14,
                  ),
                ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(CupertinoIcons.back),
        ),
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: color.surface,
        toolbarHeight: 50,
      ),
      body: Stack(
        children: [
          Obx(
            () => Padding(
              padding: const EdgeInsets.only(top: 25),
              child: AnimatedPageSwitcher(
                index: ctrl.navIndex.value,
                children: const [
                  MyShop(),
                  ShopRanks(),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Obx(
              () => ctrl.showFab.value
                  ? AnimatedContainer(
                      curve: Curves.easeInOut,
                      duration: const Duration(milliseconds: 300),
                      child: const SegmButtons(),
                    )
                  : const SizedBox.shrink(),
            ),
          )
        ],
      ),
    );
  }
}

class AnimatedPageSwitcher extends StatelessWidget {
  const AnimatedPageSwitcher({
    super.key,
    required this.index,
    required this.children,
  });

  final int index;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      child: children[index],
    );
  }
}

class SegmButtons extends StatelessWidget {
  const SegmButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 50),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const ShopSwitch(),
    );
  }
}
