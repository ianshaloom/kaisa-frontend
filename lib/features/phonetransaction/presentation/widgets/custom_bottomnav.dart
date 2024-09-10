import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/datasources/firestore/models/phone-transaction/phone_transaction.dart';
import '../../../../core/widgets/custom_filled_btn.dart';
import '../../../../core/widgets/snacks.dart';
import '../../../../router/route_names.dart';
import '../controller/phone_transaction_ctrl.dart';

final _ptCtrl = Get.find<PhoneTransactionCtrl>();

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
        /* boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
            blurRadius: 35,
            offset: const Offset(0, -1),
          ),
        ], */
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: CustomFilledBtn(
              title: 'Send Order',
              onPressed: () {
                if (validateOrder(context)) {
                  placeOrder(context, _ptCtrl.selectedPhone.id);
                }
              },
              pad: 7,
            ),
          )
        ],
      ),
    );
  }

  bool validateOrder(BuildContext context) {
    Snack snack = Snack();
    if (_ptCtrl.kaisaShopsList.isEmpty || _ptCtrl.isShopEmpty) {
      snack.showSnackBar(context: context, message: 'Please select a shop');
      return false;
    }

    if (_ptCtrl.barcode.isEmpty) {
      snack.showSnackBar(
          context: context, message: 'Please SCAN BARCODE to get IMEI  👇');
      return false;
    }

    return true;
  }

  void placeOrder(BuildContext context, String id) async {
    final transferId = _ptCtrl.barcode.value;
    final sender = _ptCtrl.userData;
    final smartphone = _ptCtrl.selectedPhone;

    final exchangesId = '${sender.uuid}-${_ptCtrl.selectedShopId.value}';

    final order = PhoneTransaction(
      transferId: transferId,
      exchangesId: exchangesId,
      senderId: sender.uuid,
      senderName: sender.fullName,
      senderAddress: sender.address,
      receiverId: _ptCtrl.selectedShopId.value,
      receiverName: _ptCtrl.selectedShopName.value,
      receiverAddress: _ptCtrl.selectedShopAddress.value,
      phoneName: smartphone.name,
      imgUrl: smartphone.imageUrl,
      ram: smartphone.ram,
      storage: smartphone.storage,
      imeis: _ptCtrl.barcode.value,
      status: 'Pending',
      createdAt: DateTime.now(),
      receivedAt: DateTime.now(),
      processedBy: '',
      participants: [sender.uuid, _ptCtrl.selectedShopId.value],
    );

    _ptCtrl.beingAdded = order;

    await toSendOrder(context).then((value) {
      _ptCtrl.newPhoneTransaction();
    });
  }

  Future<void> toSendOrder(BuildContext context) async {
    context.go(AppNamedRoutes.toSendingOrder);
  }
}
