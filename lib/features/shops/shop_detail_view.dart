import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../theme/text_scheme.dart';
import '../../core/utils/utility_methods.dart';
import '../../core/widgets/receipt_tile.dart';
import 'order_tile.dart';
import 'shop_ctrl.dart';
import 'stock_tile.dart';

final _ctrl = Get.find<ShopCtrl>();

class ShopDetailedView extends StatelessWidget {
  const ShopDetailedView({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final shop = _ctrl.selKaisaShop;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_sharp),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              shop.shopName,
              style: bodyMedium(textTheme).copyWith(
                fontSize: 13,
                color: color.onSurface,
              ),
            ),
            scrolledUnderElevation: 0,
            floating: true,
            pinned: true,
            centerTitle: true,
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: TopNav(),
            ),
          ),
          SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              sliver: Obx(
                () {
                  // The orders tab
                  if (_ctrl.navIndex.value == 0) {
                    return _sliver(context, 0);
                  }

                  //  The stock tab
                  if (_ctrl.navIndex.value == 1) {
                    return _sliver(context, 1);
                  }

                  // The sales tab
                  if (_ctrl.isProcessingRequest3.value) {
                    return lazyLoadingList(context);
                  }

                  if (_ctrl.receiptFailure != null) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Text(_ctrl.receiptFailure!.errorMessage),
                      ),
                    );
                  }

                  final rcts = _ctrl.receipts;
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final date =
                            groupByReceiptDate(rcts).keys.elementAt(index);
                        final receiptList = groupByReceiptDate(rcts)[date]!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '   ${DateFormat('dd MMMM yyyy').format(date)}',
                              style: bodyMedium(textTheme).copyWith(
                                color: color.onSurface.withOpacity(0.5),
                                fontSize: 11,
                              ),
                            ),
                            ListView.builder(
                              padding: const EdgeInsets.all(0),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: receiptList.length,
                              itemBuilder: (context, receiptIndex) {
                                final receipt = receiptList[receiptIndex];
                                return ReceiptTile(rcpt: receipt);
                              },
                            ),
                            const SizedBox(height: 20),
                          ],
                        );
                      },
                      childCount: groupByReceiptDate(rcts).length,
                    ),
                  );
                },
              )),
        ],
      ),
    );
  }

  Widget _sliver(BuildContext context, int index) {
    if (index == 0) {
      if (_ctrl.isProcessingRequest1.value) {
        return lazyLoadingList(context);
      }

      if (_ctrl.orderFailure != null) {
        return SliverFillRemaining(
          child: Center(
            child: Text(_ctrl.orderFailure!.errorMessage),
          ),
        );
      }

      final orders = _ctrl.phoneTransactions;
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final order = orders[index];
            return OrderTile(order: order);
          },
          childCount: orders.length,
        ),
      );
    }

    if (_ctrl.isProcessingRequest2.value) {
      return lazyLoadingList(context);
    }

    if (_ctrl.orderFailure != null) {
      return SliverFillRemaining(
        child: Center(
          child: Text(_ctrl.stockFailure!.errorMessage),
        ),
      );
    }

    final stks = _ctrl.stockItems;
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final stock = stks[index];
          return ShopStockTile(stk: stock);
        },
        childCount: stks.length,
      ),
    );
  }

  Widget lazyLoadingList(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Shimmer.fromColors(
            baseColor: color.primary.withOpacity(0.05),
            highlightColor: Colors.grey[300]!.withOpacity(0.05),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 20,
                        width: 100,
                        color: color.onSurface.withOpacity(0.1),
                      ),
                      const Spacer(),
                      Container(
                        height: 20,
                        width: 50,
                        color: color.onSurface.withOpacity(0.1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        height: 20,
                        width: 100,
                        color: color.onSurface.withOpacity(0.1),
                      ),
                      const Spacer(),
                      Container(
                        height: 20,
                        width: 50,
                        color: color.onSurface.withOpacity(0.1),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        childCount: Random().nextInt(10) + 1,
      ),
    );
  }
}

class TopNav extends StatelessWidget {
  const TopNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 0),
      alignment: Alignment.centerLeft,
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildButton('Orders', 0, context),
            _buildButton('Stock', 1, context),
            _buildButton('Sales', 2, context),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String title, int index, BuildContext context) {
    final font = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          _ctrl.navOnPressed(index, title);
        },
        child: AnimatedContainer(
          alignment: Alignment.center,
          height: 35,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: _ctrl.navIndex.value == index
                    ? color.primary
                    : color.surface,
                width: 3,
              ),
            ),
          ),
          child: Text(
            title,
            style: bodyBold(font),
          ),
        ),
      ),
    );
  }
}
