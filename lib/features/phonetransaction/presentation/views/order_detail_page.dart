import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../theme/text_scheme.dart';
import '../../../../core/constants/image_path_const.dart';
import '../../../../core/datasources/firestore/models/phone-transaction/phone_transaction.dart';
import '../../../../router/route_names.dart';
import '../controller/phone_transaction_ctrl.dart';
import '../widgets/tile_group_two.dart';
import '../widgets/tile_group_three.dart';
import '../widgets/tile_group_one.dart';

final _ctrl = Get.find<PhoneTransactionCtrl>();

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final font = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;

    final transaction = _ctrl.selectedTransaction;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            TileGroupOne(phoneTrans: transaction),
            Container(
              padding: const EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              child: Text(
                'RAM ${transaction.ram} ~ ${transaction.storage}',
                style: bodyDefaultBold(font),
              ),
            ),
            const SizedBox(height: 20),
            TileGroupTwo(phoneTrans: transaction),
            const SizedBox(height: 10),
            TileGroupThree(phoneTrans: transaction),
            const Spacer(),
            transaction.isSender &&
                    (!transaction.isCancelled && !transaction.isDelivered)
                ? FilledButton.tonal(
                    onPressed: () {
                      cancelOrder(context, transaction);
                    },
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      minimumSize: const Size.fromHeight(50),
                      textStyle: font.labelMedium,
                    ),
                    child: const Text(
                      'Cancel Order',
                    ),
                  )
                : const Center(),
            const SizedBox(height: 10)
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: transaction.isSender ||
              transaction.isCancelled ||
              transaction.isDelivered
          ? null
          : FloatingActionButton(
              onPressed: () {
                toReceiveScan(context);
              },
              child: SvgPicture.asset(
                scanOrder,
                colorFilter: ColorFilter.mode(color.primary, BlendMode.srcIn),
                height: 35,
              ),
            ),
    );
  }

  Future<void> toCancellingOrder(BuildContext context) async {
    context.go(AppNamedRoutes.toCancellingOrder);
  }

  Future<void> toReceiveScan(BuildContext context) async {
    context.go(AppNamedRoutes.toReceiveScan);
  }

  Future<void> cancelOrder(
      BuildContext context, PhoneTransaction transaction) async {
    await toCancellingOrder(
      context,
    ).then((value) async {
      final order = transaction.copyWith(
        transferId: transaction.transferId,
        status: 'Cancelled',
        senderId: transaction.senderId,
        senderName: transaction.senderName,
        senderAddress: transaction.senderAddress,
        receivedAt: DateTime.now(),
        receiverId: transaction.receiverId,
        receiverName: transaction.receiverName,
        receiverAddress: transaction.receiverAddress,
        phoneName: transaction.phoneName,
        ram: transaction.ram,
        storage: transaction.storage,
        createdAt: transaction.createdAt,
        participants: transaction.participants,
        processedBy: transaction.processedBy,
      );

      await _ctrl.cancelPhoneTransaction(transaction: order).then((value) {
        _ctrl.fetchPhoneTransactions();
      });
    });
  }
}
