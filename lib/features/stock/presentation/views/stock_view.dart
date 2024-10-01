import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../core/constants/image_path_const.dart';
import '../../../../core/utils/utility_methods.dart';
import '../../../../theme/text_scheme.dart';
import '../../../../core/datasources/firestore/models/stock/stock_item_entity.dart';
import '../../../stock/presentation/controller/stock_ctrl.dart';

final _sCtrl = Get.find<StockCtrl>();

class StockView extends StatelessWidget {
  const StockView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;

    _sCtrl.fetchStockItems();

    return Obx(
      () {
        if (_sCtrl.requestInProgress1.value) {
          return Center(
            child: LoadingAnimationWidget.fourRotatingDots(
              color: color.primary,
              size: 50,
            ),
          );
        }

        if (_sCtrl.requestFailure != null) {
          return Center(
            child: Text(
              _sCtrl.requestFailure!.errorMessage,
              textAlign: TextAlign.center,
              style: bodyMedium(textTheme),
            ),
          );
        }

        return ListView.builder(
          itemCount: groupByShop(_sCtrl.stockItems).length,
          itemBuilder: (context, index) {
            final shop = groupByShop(_sCtrl.stockItems).keys.elementAt(index);
            final stockList = groupByShop(_sCtrl.stockItems)[shop]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 10),
                    Text(
                      shop,
                      style: bodyMedium(textTheme).copyWith(
                        color: color.onSurface.withOpacity(0.5),
                        fontSize: 11,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: stockList.length,
                  itemBuilder: (context, receiptIndex) {
                    final stock = stockList[receiptIndex];
                    return StockTile(stk: stock);
                  },
                ),
                const SizedBox(height: 20),
              ],
            );
          },
        );
      },
    );
  }

  // function to group stock items by shop
  Map<String, List<StockItemEntity>> groupByShop(List<StockItemEntity> stock) {
    // create a map to store the grouped stock items
    final Map<String, List<StockItemEntity>> groupedStock = {};

    // loop through the stock items, obtain shopIds in List
    // dont repeat the shopId that is already in the list
    List shopIds = [];
    for (final item in stock) {
      final shopId = item.shopId;
      if (!shopIds.contains(shopId)) {
        shopIds.add(shopId);
      }
    }

    // loop through the shopIds and group the stock items by shop
    for (final shopId in shopIds) {
      final stockByShop = stock.where((item) => item.shopId == shopId).toList();

      groupedStock[getShopName(stockByShop.first.shopId)] = stockByShop;
    }

    return groupedStock;
  }

//  my shop ids are shop name location having sentence case and joined
//  for example 'Kisumu Kondele' will be 'KisumuKondele'
// more example 'Nairobi Ngara East' will be 'NairobiNgaraEast'
// return shopName from shopId
  String getShopName(String shopId) {
    // shopId has no spaces, so split it by uppercase letters
    final shopName = shopId.splitMapJoin(
      RegExp(r'(?=[A-Z])'),
      onMatch: (m) => ' ',
      onNonMatch: (m) => m,
    );

    return shopName;
  }
}

class StockTile extends StatelessWidget {
  final StockItemEntity stk;
  const StockTile({super.key, required this.stk});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final font = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: Stack(
        children: [
          Positioned(
            right: 10,
            top: 0,
            child: Text(
              customDate(stk.addeOn),
              style: bodyMedium(font).copyWith(
                color: color.onSurface.withOpacity(0.3),
                fontSize: 10,
              ),
            ),
          ),
          SizedBox(
            height: 70,
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: color.onSurface.withOpacity(0.00),
                radius: 30,
                child: SvgPicture.asset(
                  stock,
                  height: 60,
                  colorFilter: ColorFilter.mode(color.primary, BlendMode.srcIn),
                ),
              ),
              title: Text(
                stk.phoneDetails,
                style: bodyMedium(font).copyWith(
                  fontWeight: FontWeight.w400,
                  color: color.onSurface,
                ),
              ),
              subtitle: Text(
                stk.imei,
                style: bodyMedium(font).copyWith(
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //  to receipt detail view
  // Future<void> _toReceiptDetailView(BuildContext context) async {}

/*   ColorFilter colorFilter(ColorScheme color) {
    if (order.isCancelled) {
      return const ColorFilter.mode(
        Colors.black,
        BlendMode.srcIn,
      );
    } else if (order.isDelivered) {
      return const ColorFilter.mode(
        Colors.green,
        BlendMode.srcIn,
      );
    } else {
      return ColorFilter.mode(
        color.primary,
        BlendMode.srcIn,
      );
    }
  } */
}
