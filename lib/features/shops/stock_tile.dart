import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/image_path_const.dart';
import '../../core/datasources/firestore/models/stock/stock_item_entity.dart';
import '../../core/utils/utility_methods.dart';
import '../../theme/text_scheme.dart';

class ShopStockTile extends StatelessWidget {
  final StockItemEntity stk;
  const ShopStockTile({super.key, required this.stk});

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
                  colorFilter: colorFilter(color),
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

  ColorFilter colorFilter(ColorScheme color) {
    if (stk.isSold) {
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
  }
}
