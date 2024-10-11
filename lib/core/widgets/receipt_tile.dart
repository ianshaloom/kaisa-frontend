import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../features/receipt/domain/entity/receipt_entity.dart';
import '../../theme/text_scheme.dart';
import '../constants/image_path_const.dart';
import 'mbs_receipt_view.dart';

class ReceiptTile extends StatelessWidget {
  final ReceiptEntity rcpt;
  const ReceiptTile({super.key, required this.rcpt});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final font = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: GestureDetector(
        onTap: () {
          _toReceiptDetailView(context);
        },
        child: Stack(
          children: [
            Positioned(
              right: 0,
              top: 0,
              child: Text(
                rcpt.deviceDatails,
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
                    receipt,
                    height: 60,
                    colorFilter:
                        ColorFilter.mode(color.primary, BlendMode.srcIn),
                  ),
                ),
                title: Text(
                  rcpt.customerName,
                  style: bodyMedium(font).copyWith(
                    fontWeight: FontWeight.w400,
                    color: color.onSurface,
                  ),
                ),
                subtitle: Text(
                  '#${rcpt.receiptNo} ~ ${rcpt.imei}',
                  style: bodyMedium(font).copyWith(
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
        return MbsReceiptView(receipt: rcpt);
      },
    );
  }
}
