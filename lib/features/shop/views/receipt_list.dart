import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/utility_methods.dart';
import '../../../theme/text_scheme.dart';
import '../../feature-receipts/f_receipt.dart';
import '../../feature-receipts/presentation/views/receipt_listview.dart';

class ReceiptsPage extends StatelessWidget {
  final String day;
  final List<ReceiptEntity> receipts;
  const ReceiptsPage({super.key, required this.receipts, required this.day});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          day,
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
        itemCount: groupByReceiptDate(receipts).length,
        itemBuilder: (context, index) {
          final date = groupByReceiptDate(receipts).keys.elementAt(index);
          final receiptList = groupByReceiptDate(receipts)[date]!;

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
}
