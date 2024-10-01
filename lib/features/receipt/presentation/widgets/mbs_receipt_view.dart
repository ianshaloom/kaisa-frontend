import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kaisa/features/receipt/domain/entity/receipt_entity.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../theme/text_scheme.dart';
import '../controller/receipt_ctrl.dart';

final _rCtrl = Get.find<ReceiptCtrl>();

class MbsReceiptView extends StatelessWidget {
  const MbsReceiptView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
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
        Expanded(
          child: ListView(
            children: [
              Obx(
                () {
                  if (_rCtrl.requestInProgress1.value) {
                    return Shimmer.fromColors(
                      baseColor: colorScheme.primary.withOpacity(0.1),
                      highlightColor: colorScheme.primary.withOpacity(0.2),
                      child: Container(
                        height: 400,
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  }

                  if (_rCtrl.requestFailure != null) {
                    return Center(
                      child: Text(
                        _rCtrl.requestFailure!.errorMessage,
                        style: bodyMedium(textTheme),
                      ),
                    );
                  }

                  return ConstrainedBox(
                    constraints:
                        const BoxConstraints(maxHeight: 400, minHeight: 200),
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
                  );
                },
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
              Obx(
                () {
                  if (_rCtrl.requestInProgress1.value) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              textShimmers(context, 100),
                              const Spacer(),
                              textShimmers(context, 200),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              textShimmers(context, 100),
                              const Spacer(),
                              textShimmers(context, 200),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              textShimmers(context, 100),
                              const Spacer(),
                              textShimmers(context, 200),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              textShimmers(context, 100),
                              const Spacer(),
                              textShimmers(context, 200),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              textShimmers(context, 100),
                              const Spacer(),
                              textShimmers(context, 200),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              textShimmers(context, 100),
                              const Spacer(),
                              textShimmers(context, 200),
                            ],
                          ),
                        ],
                      ),
                    );
                  }

                  if (_rCtrl.requestFailure != null) {
                    return const Center();
                  }

                  return TileGroupTwo(
                    receipt: _rCtrl.selReceipt,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget textShimmers(BuildContext context, double width) {
    final color = Theme.of(context).colorScheme;

    return Shimmer.fromColors(
      baseColor: color.primary.withOpacity(0.1),
      highlightColor: color.primary.withOpacity(0.2),
      child: Container(
        // color: Colors.grey[300],
        height: 20,
        width: width,
        decoration: BoxDecoration(
          color: color.primary.withOpacity(0.5),
          borderRadius: BorderRadius.circular(5),
        ),
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
      margin: const EdgeInsets.symmetric(horizontal: 5),
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
