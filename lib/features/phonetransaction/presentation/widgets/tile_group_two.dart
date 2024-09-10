import 'package:flutter/material.dart';

import '../../../../../../theme/text_scheme.dart';
import '../../../../core/datasources/firestore/models/phone-transaction/phone_transaction.dart';
import '../../../../core/utils/utility_methods.dart';

class TileGroupTwo extends StatelessWidget {
  final PhoneTransaction phoneTrans;
  const TileGroupTwo({super.key, required this.phoneTrans});

  @override
  Widget build(BuildContext context) {
    final font = Theme.of(context).textTheme;
    final bodyDft = bodyMedium(font);

    final color = Theme.of(context).colorScheme;
    return Container(
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
              Text('Status', style: bodyDft),
              const Spacer(),
              Text(
                phoneTrans.status,
                style: bodyDft.copyWith(
                  fontWeight: FontWeight.w600,
                  color: phoneTrans.status == 'Pending'
                      ? Colors.blue
                      : phoneTrans.status == 'Delivered'
                          ? Colors.green
                          : Colors.black54,
                ),
              )
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Text('Sent By', style: bodyDft),
              const Spacer(),
              Text(phoneTrans.senderName, style: bodyDft),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Text('From', style: bodyDft),
              const Spacer(),
              Text(phoneTrans.senderAddress, style: bodyDft),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Text('To', style: bodyDft),
              const Spacer(),
              Text(phoneTrans.receiverAddress, style: bodyDft),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Text(phoneTrans.isPending ? 'Receiver' : 'Received By',
                  style: bodyDft),
              const Spacer(),
              Text(phoneTrans.receiverName, style: bodyDft),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Text('Sent On', style: bodyDft),
              const Spacer(),
              Text(newDate(phoneTrans.createdAt), style: bodyDft),
            ],
          ),
        ],
      ),
    );
  }
}
