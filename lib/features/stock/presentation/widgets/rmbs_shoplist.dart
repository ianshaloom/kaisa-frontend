/* import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../core/constants/image_path_const.dart';
import '../../../../core/datasources/firestore/models/kaisa-user/kaisa_user.dart';
import '../../../../core/widgets/custom_filled_btn.dart';
import '../../../../theme/text_scheme.dart';

final _ctrl = Get.find<StockCtrl>();

class $MbsShopList extends StatelessWidget {
  const $MbsShopList({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;

    _ctrl.fetchUsers();

    return Obx(() {
      if (_ctrl.requestInProgress3.value) {
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

      if (_ctrl.sendOrderFailure != null) {
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
                _ctrl.sendOrderFailure!.errorMessage,
                style: bodyRegular(textTheme),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              CustomFilledBtn(
                title: 'Try Again',
                onPressed: () => _ctrl.sendOrder(),
                pad: 5,
              ),
            ],
          ),
        );
      } else if (_ctrl.sendOrderSuccess != null) {
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
                  onPressed: () => sendOrder(context),
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
                if (_ctrl.requestInProgress2.value) {
                  return Center(
                    child: LoadingAnimationWidget.fourRotatingDots(
                      color: color.primary,
                      size: 50,
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: _ctrl.kaisaShopsList.length,
                  itemBuilder: (context, index) {
                    final user = _ctrl.kaisaShopsList[index];
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
    if (_ctrl.isShopEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Select a shop to send order'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      _ctrl.sendOrder();
    }
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
        _ctrl.setSelectedShopDetails = user;
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
                  style: bodyBold(textTheme),
                ),
                const SizedBox(height: 3),
                Text(
                  user.fullName,
                  style: bodyMedium(textTheme),
                ),
              ],
            ),
            const Spacer(),
            Obx(
              () => _ctrl.selectedShopId.value == user.uuid
                  ? const Icon(Icons.check, color: Colors.green)
                  : const Icon(Icons.check, color: Colors.transparent),
            )
          ],
        ),
      ),
    );
  }
}
 */