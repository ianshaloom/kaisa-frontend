import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaisa/features/shops/shop_ctrl.dart';

import '../../../../../../theme/text_scheme.dart';
import '../../../../core/datasources/firestore/models/phone-transaction/phone_transaction.dart';
import '../../../../core/utils/utility_methods.dart';
import '../../core/constants/network_const.dart';

final _ctrl = Get.find<ShopCtrl>();

class MbsOrderView extends StatelessWidget {
  const MbsOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    final font = Theme.of(context).textTheme;

    final transaction = _ctrl.selPhoneTransaction;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Container(
            height: 3,
            width: 50,
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const SizedBox(height: 20),
          TileGroupOne(phoneTrans: transaction),
          Container(
            padding: const EdgeInsets.only(left: 10),
            alignment: Alignment.centerLeft,
            child: Text(
              'RAM ${transaction.ram} ~ ${transaction.storage}',
              style: bodyBold(font),
            ),
          ),
          const SizedBox(height: 20),
          TileGroupTwo(phoneTrans: transaction),
          const SizedBox(height: 10),
          TileGroupThree(phoneTrans: transaction),
          const Spacer(),
        ],
      ),
    );
  }
}

class TileGroupOne extends StatelessWidget {
  final PhoneTransaction phoneTrans;
  const TileGroupOne({super.key, required this.phoneTrans});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    // subtract a hozintal padding of 24 from width
    final width = size.width - 24;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: (width * 0.68) - 40,
          height: 100,
          padding: const EdgeInsets.only(left: 10, top: 10),
          alignment: Alignment.bottomLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                phoneTrans.deviceName,
                // overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: bodyBold(textTheme).copyWith(
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 150,
          width: (width * 0.32) + 20,
          margin: const EdgeInsets.only(left: 20, bottom: 8),
          padding: const EdgeInsets.symmetric(
            horizontal: 7,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('$kBaseUrlImages${phoneTrans.imgUrl}'),
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
      ],
    );
  }
}

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
                          : const Color(0xffB1BCAE),
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
              Text(customDateFromString(phoneTrans.createdAt), style: bodyDft),
            ],
          ),
        ],
      ),
    );
  }
}

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
              Text(phoneTrans.imei, style: bodyDft),
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
