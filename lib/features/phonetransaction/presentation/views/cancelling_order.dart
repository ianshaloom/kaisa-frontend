import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../core/constants/image_path_const.dart';
import '../../../../core/widgets/custom_filled_btn.dart';
import '../../../../core/widgets/custom_outllined_btn.dart';
import '../../../../theme/text_scheme.dart';
import '../controller/phone_transaction_ctrl.dart';

final _ctrl = Get.find<PhoneTransactionCtrl>();

class CancellingOrder extends StatelessWidget {
  const CancellingOrder({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        title: Text(
          _ctrl.selectedTransaction.deviceName,
          style: bodyMedium(textTheme).copyWith(
            fontSize: 14,
          ),
        ),
      ),
      body: Obx(
        () {
          if (_ctrl.processingRequestOne.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
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

          if (_ctrl.cancelFailure != null) {
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
                    _ctrl.cancelFailure!.errorMessage,
                    style: bodyRegular(textTheme),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                const Spacer(),
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        cancelledOrder,
                        height: 100,
                        colorFilter: const ColorFilter.mode(
                          Colors.grey,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'Order Cancelled',
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
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const CustomerBasketBottomBar(),
    );
  }
}

class CustomerBasketBottomBar extends StatelessWidget {
  const CustomerBasketBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Obx(
        () => _ctrl.processingRequestOne.value
            ? const SizedBox()
            : (_ctrl.cancelFailure != null)
                ? Row(
                    children: [
                      Expanded(
                        child: CustomOutlinedBtn(
                          title: 'Close',
                          onPressed: () => exitPage(context),
                          pad: 8,
                        ),
                      ),
                      Expanded(
                        child: CustomFilledBtn(
                          title: 'Try Again',
                          onPressed: () {
                            _ctrl.cancelPhoneTransaction();
                          },
                          pad: 8,
                        ),
                      ),
                    ],
                  )
                : CustomFilledBtn(
                    title: 'Done',
                    onPressed: () => backToHome(context),
                    pad: 8,
                  ),
      ),
    );
  }

  Future backToHome(BuildContext context) async {
    _ctrl.actionFromTH
        ? Navigator.of(context).pop()
        : Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void exitPage(BuildContext context) {
    _ctrl.actionFromTH
        ? Navigator.of(context).pop()
        : Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
