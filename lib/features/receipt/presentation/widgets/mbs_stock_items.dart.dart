import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/utils/utility_methods.dart';
import '../../../../theme/text_scheme.dart';
import '../../../stock/domain/entity/stock_item_entity.dart';
import '../../../stock/presentation/controller/stock_ctrl.dart';
import '../controller/receipt_ctrl.dart';

final _ctrl = Get.find<StockCtrl>();
final _rCtrl = Get.find<ReceiptCtrl>();

class MbsStockItems extends StatelessWidget {
  const MbsStockItems({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;

    _ctrl.fetchStockItems();

    return SizedBox(
      height: 300,
      child: Column(
        children: [
          Container(
            height: 3,
            width: 50,
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          Expanded(
            child: Obx(
              () {
                if (_ctrl.requestInProgress1.value) {
                  return Center(
                    child: LoadingAnimationWidget.fourRotatingDots(
                      color: color.primary,
                      size: 50,
                    ),
                  );
                }

                if (_ctrl.requestFailure != null) {
                  return Center(
                    child: Text(
                      _ctrl.requestFailure!.errorMessage,
                      style: bodyMedium(textTheme),
                    ),
                  );
                }

                final stock = _ctrl.stockItems.where((e) => !e.isSold).toList();

                return CarouselView(
                  itemExtent: 340,
                  itemSnapping: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  children: [
                    for (int i = 0; i < stock.length; i++)
                      StockItemGridTile(
                        stock: stock[i],
                        index: i,
                      ),
                  ],
                  onTap: (index) {
                    // set receipt details
                    _rCtrl.imeiz.value = stock[index].imei;
                    _rCtrl.shopId = stock[index].shopId;
                    _rCtrl.smUuid = stock[index].smUuid;
                    _rCtrl.deviceDetailsz.value = stock[index].phoneDetails;

                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class StockItemGridTile extends StatelessWidget {
  final StockItemEntity stock;
  final int index;
  const StockItemGridTile(
      {super.key, required this.stock, required this.index});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 170,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: stock.isSold
                    ? colorScheme.onSurface.withOpacity(0.1)
                    : colorScheme.primary.withOpacity(0.05),
                borderRadius: index.isEven
                    ? const BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      )
                    : const BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5),
                      ),
              ),
              child: Center(
                child: Hero(
                  tag: stock.imei,
                  child: CachedNetworkImage(
                    imageUrl: generateImageUrl(stock.imgUrl),
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: colorScheme.primary.withOpacity(0.1),
                      highlightColor: colorScheme.primary.withOpacity(0.2),
                      child: Container(
                        color: colorScheme.primary.withOpacity(0.1),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 5, left: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${stock.ram} ~ ${stock.storage}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 9,
                      ),
                ),
                Text(
                  stock.model,
                  overflow: TextOverflow.ellipsis,
                  style: bodyMedium(textTheme).copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
                Text(
                  stock.imei,
                  overflow: TextOverflow.ellipsis,
                  style: bodyMedium(textTheme).copyWith(
                    fontWeight: FontWeight.w300,
                    fontSize: 11,
                    color: colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
