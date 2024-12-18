import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kaisa/theme/text_scheme.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../core/constants/image_path_const.dart';
import '../../../../core/utils/utility_methods.dart';
import '../../f_receipt.dart';
import '../../f_receipt_ctrl.dart';
import 'receipt_detail_view.dart';
import 'receipt_form.dart';

class ReceiptView extends StatelessWidget {
  const ReceiptView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;

    final rCtrl = Get.find<FReceiptCtrl>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sale Receipts',
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
      body: Obx(
        () {
          if (rCtrl.fetchRequest.value) {
            return Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: color.primary,
                size: 50,
              ),
            );
          }

          if (rCtrl.fetchFailure != null) {
            return Center(
              child: Text(
                rCtrl.fetchFailure!.errorMessage,
                textAlign: TextAlign.center,
                style: bodyMedium(textTheme),
              ),
            );
          }

          return ListView.builder(
            itemCount: groupByReceiptDate(rCtrl.receipts).length,
            itemBuilder: (context, index) {
              final date =
                  groupByReceiptDate(rCtrl.receipts).keys.elementAt(index);
              final receiptList = groupByReceiptDate(rCtrl.receipts)[date]!;

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
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          rCtrl.reset();

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ReceiptForm(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ReceiptTile extends StatelessWidget {
  final ReceiptEntity rcpt;
  const ReceiptTile({super.key, required this.rcpt});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final font = Theme.of(context).textTheme;

    final rCtrl = Get.find<FReceiptCtrl>();

    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: GestureDetector(
        onTap: () {
          rCtrl.receipt = rcpt;
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
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ReceiptDetailView(),
      ),
    );
  }

/*   ColorFilter colorFilter(ColorScheme color) {
    if (order.isCancelled) {
      return const ColorFilter.mode(
        Colors.black,
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
  } */
}
