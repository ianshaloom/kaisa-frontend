import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/datasources/firestore/models/phone-transaction/phone_transaction.dart';
import '../../../../core/utils/utility_methods.dart';
import '../../../../core/widgets/custom_filled_btn.dart';
import '../../../../core/widgets/snacks.dart';
import '../../../../router/route_names.dart';
import '../../../../shared/shared_ctrl.dart';
import '../controller/phone_transaction_ctrl.dart';

final _ptCtrl = Get.find<PhoneTransactionCtrl>();
final _shCtrl = Get.find<SharedCtrl>();

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
    if (_shCtrl.kaisaShopsList.isEmpty || _shCtrl.isShopEmpty) {
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

    final sender = _shCtrl.userData;
    final smartphone = _ptCtrl.selectedPhone;

    final order = PhoneTransaction(
      smUuid: smartphone.id,
      uuid: const Uuid().v4(),
      senderId: sender.uuid,
      senderName: sender.fullName,
      senderAddress: sender.address,
      receiverId: _shCtrl.selectedShopId.value,
      receiverName: _shCtrl.selectedShopName.value,
      receiverAddress: _shCtrl.selectedShopAddress.value,
      deviceName: smartphone.name,
      imgUrl: smartphone.imageUrl,
      ram: smartphone.ram,
      storage: smartphone.storage,
      imei: _ptCtrl.barcode.value,
      model: smartphone.model,
      status: 'Pending',
      createdAt: todayDateFormatted(),
      receivedAt: todayDateFormatted(),
      participants: [sender.uuid, _shCtrl.selectedShopId.value],
      dateTime: DateTime.now(),
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
