import 'package:flutter/material.dart';

import '../../../../shared/shared_models.dart';
import '../../../../theme/text_scheme.dart';

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
