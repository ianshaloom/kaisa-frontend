import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/constants/image_path_const.dart';
import '../../../../core/datasources/firestore/models/phone-transaction/phone_transaction.dart';
import '../../../../core/utils/utility_methods.dart';
import '../../../../theme/text_scheme.dart';
import 'mbs_trans_view.dart';
import 'shop_ctrl.dart';

final _ctrl = Get.find<ShopCtrl>();

class OrderTile extends StatelessWidget {
  final PhoneTransaction order;
  const OrderTile({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final font = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 17),
      child: GestureDetector(
        onTap: () {
          _ctrl.phoneTransaction = order;
          _toReceiptDetailView(context);
        },
        child: Stack(
          children: [
            Positioned(
              right: 0,
              top: 0,
              child: Text(
                elapsedTime(order.dateTime),
                style: bodyMedium(font).copyWith(
                  color: color.onSurface.withOpacity(0.3),
                  fontSize: 11,
                ),
              ),
            ),
            Container(
              height: 70,
              // color: Colors.black26,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: color.onSurface.withOpacity(0.07),
                    width: 0.5,
                  ),
                ),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: color.onSurface.withOpacity(0.00),
                  radius: 30,
                  child: SvgPicture.asset(svgPath(),
                      height: 60, colorFilter: colorFilter(color)),
                ),
                title: Text(
                  '# ${order.ram} ${order.storage}',
                  style: bodyMedium(font).copyWith(
                    fontSize: 10,
                  ),
                ),
                subtitle: Text(
                  order.deviceName,
                  style: bodyMedium(font).copyWith(
                    fontWeight: FontWeight.w400,
                    color: color.onSurface,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ColorFilter colorFilter(ColorScheme color) {
    if (order.isCancelled) {
      return const ColorFilter.mode(
        Colors.grey,
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
  }

  String svgPath() {
    if (order.isCancelled) {
      return cancelledOrder;
    } else if (order.isDelivered) {
      return receivedOrder;
    } else {
      return pendingOrder;
    }
  }

  //  to receipt detail view
  Future<void> _toReceiptDetailView(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (context) {
        return const MbsOrderView();
      },
    );
  }
}
