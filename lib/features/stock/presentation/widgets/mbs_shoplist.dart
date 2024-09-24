import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kaisa/core/datasources/firestore/models/kaisa-user/kaisa_user.dart';
import 'package:kaisa/core/utils/utility_methods.dart';
import 'package:kaisa/core/widgets/custom_filled_btn.dart';
import 'package:kaisa/features/shared/presentation/controller/shared_ctrl.dart';
import 'package:kaisa/theme/text_scheme.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/image_path_const.dart';
import '../../../../core/datasources/firestore/models/phone-transaction/phone_transaction.dart';
import '../controller/stock_ctrl.dart';

final _shCtrl = Get.find<SharedCtrl>();
final _stCtrl = Get.find<StockCtrl>();

class MbsShopList extends StatelessWidget {
  const MbsShopList({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;

    return Obx(() {
      if (_stCtrl.requestInProgress2.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                  color: color.primary,
                  size: 50,
                ),
              ),
              const SizedBox(height: 60),
              Text(
                'Processing Order ...',
                style: bodyLarge(textTheme).copyWith(
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        );
      }

      if (_stCtrl.sendOrderFailure != null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                serverError,
                height: 200,
              ),
              const SizedBox(height: 34),
              Text(
                'Error From Server',
                style: bodyMedium(textTheme).copyWith(
                  color: color.error,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _stCtrl.sendOrderFailure!.errorMessage,
                style: bodyRegular(textTheme),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              CustomFilledBtn(
                title: 'Try Again',
                onPressed: () => _stCtrl.sendOrder(),
                pad: 5,
              ),
            ],
          ),
        );
      } else if (_stCtrl.sendOrderSuccess != null) {
        return Column(
          children: [
            const Spacer(),
            Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  SvgPicture.asset(
                    receivedOrder,
                    height: 100,
                    colorFilter: ColorFilter.mode(
                      color.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Order\nReady for Delivery',
                    textAlign: TextAlign.center,
                    style: bodyLarge(textTheme).copyWith(
                      fontWeight: FontWeight.w100,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            CustomFilledBtn(
              title: 'Close',
              onPressed: () => Navigator.of(context).pop(),
              pad: 5,
            )
          ],
        );
      }

      return Column(
        children: [
          Container(
            height: 3,
            width: 50,
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: Row(
              children: [
                Text(
                  'Select Shop',
                  style: bodyBold(textTheme).copyWith(fontSize: 16),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () =>
                      _shCtrl.isShopEmpty ? null : sendOrder(context),
                  icon: Icon(
                    Icons.send,
                    color: color.primary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(
              () {
                if (_shCtrl.requestInProgress.value) {
                  return Center(
                    child: LoadingAnimationWidget.fourRotatingDots(
                      color: color.primary,
                      size: 50,
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: _shCtrl.kaisaShopsList.length,
                  itemBuilder: (context, index) {
                    final user = _shCtrl.kaisaShopsList[index];
                    return CustomListTile(user: user);
                  },
                );
              },
            ),
          ),
        ],
      );
    });
  }

  void sendOrder(BuildContext context) {
    _stCtrl.phoneTransaction = PhoneTransaction(
      uuid: const Uuid().v4(),
      smUuid: _stCtrl.selStockItem.smUuid,
      senderId: _shCtrl.userData.uuid,
      senderName: _shCtrl.userData.fullName,
      senderAddress: _shCtrl.userData.address,
      receiverId: _shCtrl.selectedShopId.value,
      receiverName: _shCtrl.selectedShopName.value,
      receiverAddress: _shCtrl.selectedShopAddress.value,
      deviceName: _stCtrl.selStockItem.deviceName,
      model: _stCtrl.selStockItem.model,
      imgUrl: _stCtrl.selStockItem.imgUrl,
      ram: _stCtrl.selStockItem.ram,
      storage: _stCtrl.selStockItem.storage,
      imei: _stCtrl.selStockItem.imei,
      status: 'Pending',
      createdAt: formatDate(DateTime.now()),
      receivedAt: '',
      dateTime: DateTime.now(),
      participants: [
        _shCtrl.userData.uuid,
        _shCtrl.selectedShopId.value,
      ],
    );
    _stCtrl.sendOrder();
  }
}

class CustomListTile extends StatelessWidget {
  final KaisaUser user;
  const CustomListTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () {
        _shCtrl.setSelectedShopDetails = user;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        width: double.infinity,
        child: Row(
          children: [
            const SizedBox(width: 5),
            CircleAvatar(
              radius: 30,
              backgroundColor: color.primary.withOpacity(0.1),
              child: SvgPicture.asset(
                location,
                colorFilter: ColorFilter.mode(
                  color.primary,
                  BlendMode.srcIn,
                ),
                height: 30,
                width: 30,
              ),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.address.toUpperCase(),
                  style: bodyMedium(textTheme),
                ),
                const SizedBox(height: 3),
                Text(
                  user.fullName,
                  style: bodyRegular(textTheme),
                ),
              ],
            ),
            const Spacer(),
            Obx(
              () => _shCtrl.selectedShopId.value == user.uuid
                  ? Icon(Icons.check, color: color.primary)
                  : const Icon(Icons.check, color: Colors.transparent),
            )
          ],
        ),
      ),
    );
  }
}
