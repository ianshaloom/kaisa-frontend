import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:kaisa/theme/text_scheme.dart';

import '../../../../core/constants/image_path_const.dart';
import '../../../../router/route_names.dart';
import '../../../../shared/shared_ctrl.dart';
import '../../../feature-receipts/f_receipt_ctrl.dart';
import '../../../stock/presentation/controller/stock_ctrl.dart';

class HomeMenu extends StatelessWidget {
  const HomeMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: GridView(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.2,
        ),
        children: [
          MenuTile(
            onTap: _toStock,
            title: 'Stock',
            svg: stock,
          ),
          MenuTile(
            onTap: _toReceipt,
            title: 'Receipts',
            svg: receipt,
          ),
          MenuTile(
            onTap: _toShop,
            title: 'Browse',
            svg: search,
          ),
        ],
      ),
    );
  }

  void _toStock(BuildContext context) {
    final sCtrl = Get.find<StockCtrl>();
    final uuid = Get.find<SharedCtrl>().userData.shopId;
    sCtrl.fetchStockItems(uuid);
    context.go(AppNamedRoutes.toStock);
  }

  void _toReceipt(BuildContext context) {
    final uuid = Get.find<SharedCtrl>().userData.shopId;
    
    final rCtrl = Get.find<FReceiptCtrl>();
    rCtrl.fetchReceipts(uuid);
    context.go(AppNamedRoutes.toReceipt);
  }

  void _toShop(BuildContext context) {
    context.go(AppNamedRoutes.toSmartPhonesGrid);
  }
}

class MenuTile extends StatelessWidget {
  final Function onTap;
  final String title;
  final String svg;
  const MenuTile(
      {super.key, required this.onTap, required this.title, required this.svg});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () => onTap(context),
      splashColor: color.primary.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
              radius: 30,
              backgroundColor: color.primary.withOpacity(0.05),
              child: SvgPicture.asset(
                svg,
                height: 40,
                colorFilter: ColorFilter.mode(color.primary, BlendMode.srcIn),
              )),
          Text(
            title,
            style: bodyMedium(textTheme),
          )
        ],
      ),
    );
  }
}
