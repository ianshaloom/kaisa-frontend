import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaisa/theme/text_scheme.dart';

import '../../../../shared/shared_ctrl.dart';
import '../../../../shared/shared_models.dart';
import '../widget/shop_view_appbar.dart';

final _shCtrl = Get.find<SharedCtrl>();

class ShopView extends StatelessWidget {
  const ShopView({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    _shCtrl.getSalesAnalysis();

    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          title: ShopViewAppbar(),
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
            if (_shCtrl.isProcessingRequest1.value) {
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

            if (_shCtrl.shopAnalysis().isEmpty) {
              return const SliverFillRemaining(
                child: Center(
                  child: Text('No Shop Analysis Data'),
                ),
              );
            }
            return SliverList.builder(
              itemCount: _shCtrl.shopAnalysis().length,
              itemBuilder: (context, index) {
                final shop = _shCtrl.shopAnalysis()[index];
                return AnaliticsTile(shop: shop);
              },
            );
          },
        ),
      ],
    );
  }
}

class AnaliticsTile extends StatelessWidget {
  final ShopAnalysis shop;
  const AnaliticsTile({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: color.onSurface.withOpacity(0.04),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                Text(
                  shop.shopName,
                  style: bodyBold(textTheme),
                ),
                const Spacer(),
                Text(
                  shop.totalSalesString,
                  style: bodyBold(textTheme),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
          Divider(
            color: color.primary.withOpacity(0.5),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _dataTile(
                  context,
                  title: 'Watu',
                  value: shop.watuSalesString,
                ),
                _dataTile(
                  context,
                  title: 'M-Kopa',
                  value: shop.mKopaSalesString,
                ),
                _dataTile(
                  context,
                  title: 'Onfon',
                  value: shop.onfonSalesString,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _dataTile(BuildContext context,
      {String title = '', String value = ''}) {
    final textTheme = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: bodyMedium(textTheme).copyWith(
            fontWeight: FontWeight.w400,
            color: color.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: bodyRegular(textTheme),
        ),
      ],
    );
  }
}
