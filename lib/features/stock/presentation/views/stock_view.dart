import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaisa/features/stock/domain/entity/stock_item_entity.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/utils/utility_methods.dart';
import '../../../../theme/text_scheme.dart';
import '../../../feature-receipts/f_receipt_ctrl.dart';
import '../controller/stock_ctrl.dart';
import '../widgets/mbs_menu.dart';

final _sCtrl = Get.find<StockCtrl>();
final _rCtrl = Get.find<FReceiptCtrl>();

class StockView extends StatelessWidget {
  const StockView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Stock',
          style: bodyRegular(textTheme).copyWith(fontSize: 13),
        ),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(CupertinoIcons.back),
        ),
      ),
      body: Obx(
        () {
          if (_sCtrl.requestInProgress1.value) {
            return Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: color.primary,
                size: 50,
              ),
            );
          }

          if (_sCtrl.requestFailure != null) {
            return Center(
              child: Text(
                _sCtrl.requestFailure!.errorMessage,
                style: bodyMedium(textTheme),
              ),
            );
          }

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.6,
              mainAxisSpacing: 2,
              crossAxisSpacing: 5,
            ),
            itemCount: _sCtrl.stockItems.length,
            padding: const EdgeInsets.only(top: 12),
            itemBuilder: (context, index) {
              return StockItemGridTile(
                stock: _sCtrl.stockItems[index],
                index: index,
              );
            },
          );
        },
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

    return GestureDetector(
      onTap: () => onTap(context),
      child: SizedBox(
        height: 170,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: stock.isSold
                      ? Colors.transparent
                      : colorScheme.onSurface.withOpacity(0.1),
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
                    stock.imei,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 8,
                          color: stock.isSold
                              ? colorScheme.onSurface.withOpacity(0.5)
                              : colorScheme.primary.withOpacity(0.5),
                        ),
                  ),
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
                    style: bodyMedium(textTheme).copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  /* void onTap(BuildContext context) {
    // set stock item
    _sCtrl.stockItem = stock;

    // show MbsMenuStockItem
    _showMbsMenuStockItem(context);
  } */

  // this method shows the MbsMenuStockItem
  void _showMbsMenuStockItem(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      builder: (context) => MbsMenuStockItem(sold: stock.isSold),
    );
  }

  void onTap(BuildContext context) {
    // set stock item
    _sCtrl.stockItem = stock;

    // set receipt details
    _rCtrl.imei = stock.imei;
    _rCtrl.smUuid = stock.smUuid;
    _rCtrl.shopId = stock.shopId;
    _rCtrl.deviceDetails = stock.phoneDetails;

    // show MbsMenuStockItem
    _showMbsMenuStockItem(context);
  }
}
