import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:kaisa/shared/shared_models.dart';
import 'package:kaisa/theme/text_scheme.dart';

import '../../../../core/constants/image_path_const.dart';
import '../../../receipt/domain/entity/receipt_entity.dart';
import '../widget/mbs_s_receipt_view.dart';

class ShopReceipts extends StatelessWidget {
  final ShopAnalysis shop;
  const ShopReceipts({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          shop.shopName,
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
      body: ListView.builder(
        itemCount: groupByReceiptDate(shop.shopReceipts).length,
        itemBuilder: (context, index) {
          final date =
              groupByReceiptDate(shop.shopReceipts).keys.elementAt(index);
          final receiptList = groupByReceiptDate(shop.shopReceipts)[date]!;

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
      ),
    );
  }

  // Function to group receipts by date
  Map<DateTime, List<ReceiptEntity>> groupByReceiptDate(
    List<ReceiptEntity> receipts,
  ) {
    // Create a map to store the grouped receipts
    final Map<DateTime, List<ReceiptEntity>> groupedReceipts = {};

    // Loop through the receipts, obtain the date into a List<DateTime>
    // dont repeat the date that is already in the list
    List dates = [];
    for (final receipt in receipts) {
      final date = receipt.addeOn;
      if (!dates.contains(date)) {
        dates.add(date);
      }
    }

    // sort the dates, starting from the most recent
    dates.sort((a, b) => b.compareTo(a));

    // Loop through the dates and group the receipts by date
    for (final date in dates) {
      final receiptsByDate =
          receipts.where((receipt) => receipt.addeOn.day == date.day).toList();

      groupedReceipts[receiptsByDate.first.addeOn] = receiptsByDate;
    }

    return groupedReceipts;
  }
}

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
        return MbsShopReceipt(receipt: rcpt);
      },
    );
  }
}
