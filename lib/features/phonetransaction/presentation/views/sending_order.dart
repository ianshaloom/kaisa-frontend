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

class SendingOrder extends StatelessWidget {
  const SendingOrder({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'To ${_ctrl.selectedShopAddress.value}',
          style: bodyMedium(textTheme).copyWith(
            fontSize: 14,
          ),
        ),
      ),
      body: Obx(
        () => _ctrl.processingRequestOne.value
            ? Center(
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
              )
            : Builder(builder: (context) {
                return (_ctrl.newFailure != null)
                    ? Center(
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
                              _ctrl.newFailure!.errorMessage,
                              style: bodyRegular(textTheme),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: Column(
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
                          ],
                        ),
                      );
              }),
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
            : Builder(
                builder: (context) {
                  return (_ctrl.newFailure != null)
                      ? Row(
                          children: [
                            Expanded(
                              child: CustomOutlinedBtn(
                                title: 'Close',
                                onPressed: () => backToHome(context),
                                pad: 8,
                              ),
                            ),
                            Expanded(
                              child: CustomFilledBtn(
                                title: 'Try Again',
                                onPressed: () {
                                  _ctrl.newPhoneTransaction();
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
                        );
                },
              ),
      ),
    );
  }

  Future backToHome(BuildContext context) async {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
