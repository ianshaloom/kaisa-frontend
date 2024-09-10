import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../theme/text_scheme.dart';
import '../../../../core/datasources/firestore/models/phone-transaction/phone_transaction.dart';

class TileGroupThree extends StatelessWidget {
  final PhoneTransaction phoneTrans;

  const TileGroupThree({super.key, required this.phoneTrans});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final font = Theme.of(context).textTheme;
    final bodyDft = bodyMedium(font);
    const double height = 20.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: color.onSurface.withOpacity(0.2),
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text('IMEI', style: bodyDft),
              const Spacer(),
              Text(phoneTrans.imeis, style: bodyDft),
            ],
          ),
          const SizedBox(height: height),
          Row(
            children: [
              Text('RAM', style: bodyDft),
              const Spacer(),
              Text(phoneTrans.ram, style: bodyDft),
            ],
          ),
          const SizedBox(height: height),
          Row(
            children: [
              Text('Storage', style: bodyDft),
              const Spacer(),
              Text(phoneTrans.storage, style: bodyDft),
            ],
          ),
        ],
      ),
    );
  }
}

class ReceiptItemTileO extends StatelessWidget {
  final String title;
  final double unitprice;
  final int quantity;
  final double amount;

  const ReceiptItemTileO({
    super.key,
    required this.title,
    required this.unitprice,
    required this.quantity,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final font = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;
    return Column(
      children: [
        Divider(
          height: 0,
          thickness: 0.8,
          color: color.onSurface.withOpacity(0.2),
        ),
        ListTile(
          leading: Text(quantity.toString(),
              style: bodyBold(font).copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              )),
          title: Text(
            title,
            style: bodyBold(font),
          ),
          subtitle: Text(
            'X ${unitprice.toString()}',
            style: bodyMedium(font),
          ),
          trailing: Text(
            NumberFormat('#,##0.00').format((unitprice * quantity)),
            style: bodyBold(font),
          ),
        ),
      ],
    );
  }
}
