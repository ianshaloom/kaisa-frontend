import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kaisa/features/receipt/domain/entity/receipt_entity.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../theme/text_scheme.dart';
import '../controller/receipt_ctrl.dart';

final _rCtrl = Get.find<ReceiptCtrl>();

class ReceiptDetailView extends StatelessWidget {
  const ReceiptDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Receipt ${_rCtrl.selReceipt.receiptNo}',
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
      body: ListView(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 400, minHeight: 200),
            child: CarouselView(
              itemExtent: 330,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              children: [
                for (int i = 0; i < _rCtrl.downloadUrlsList.length; i++)
                  CaroselTile(imgUrl: _rCtrl.downloadUrlsList[i]),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Spacer(),
              Text(
                "Receipt Details",
                style: bodyBold(textTheme),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 10),
          TileGroupTwo(
            receipt: _rCtrl.selReceipt,
          )
        ],
      ),
    );
  }
}

class CaroselTile extends StatelessWidget {
  final String imgUrl;
  const CaroselTile({super.key, required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CachedNetworkImage(
      imageUrl: imgUrl,
      placeholder: (context, url) {
        return Shimmer.fromColors(
          baseColor: colorScheme.primary.withOpacity(0.1),
          highlightColor: colorScheme.primary.withOpacity(0.2),
          child: Container(
            color: colorScheme.primary.withOpacity(0.1),
          ),
        );
      },
      errorWidget: (context, url, error) {
        return const Icon(Icons.error);
      },
      fit: BoxFit.cover,
    );
  }
}

class TileGroupTwo extends StatelessWidget {
  final ReceiptEntity receipt;
  const TileGroupTwo({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    final font = Theme.of(context).textTheme;
    final bodyDft1 = bodyMedium(font);
    final bodyDft2 = bodyRegular(font);

    final color = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      margin: const EdgeInsets.only(left: 5, right: 5, bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: color.onSurface.withOpacity(0.2),
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          /* Row(
            children: [
              Text('Status', style: bodyDft),
              const Spacer(),
              Text(
                receipt.status,
                style: bodyDft.copyWith(
                  fontWeight: FontWeight.w600,
                  color: receipt.status == 'Pending'
                      ? Colors.blue
                      : receipt.status == 'Delivered'
                          ? Colors.green
                          : Colors.black54,
                ),
              )
            ],
          ),
          const SizedBox(height: 15), */
          Row(
            children: [
              Text(
                'Product Name',
                style: bodyDft1,
              ),
              const Spacer(),
              Text(receipt.deviceDatails,
                  style: bodyDft2.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Text('Receipt Date', style: bodyDft1),
              const Spacer(),
              Text(
                DateFormat.yMMMMd().format(receipt.receiptDate),
                style: bodyDft2,
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Text('Receipt Number', style: bodyDft1),
              const Spacer(),
              Text(receipt.receiptNo.toString(), style: bodyDft2),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Text('Customer Name', style: bodyDft1),
              const Spacer(),
              Text(receipt.customerName, style: bodyDft2),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Text('Customer Tel.', style: bodyDft1),
              const Spacer(),
              Text(receipt.customerPhoneNo, style: bodyDft2),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Text(
                'Cash Price',
                style: bodyDft1,
              ),
              const Spacer(),
              Text('Kshs. ${receipt.cashPrice.toString()}', style: bodyDft2),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Text('Loan Company', style: bodyDft1),
              const Spacer(),
              Text(receipt.org, style: bodyDft2),
            ],
          ),
        ],
      ),
    );
  }
}
