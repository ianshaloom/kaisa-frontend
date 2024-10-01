import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../core/constants/image_path_const.dart';
import '../../../../core/widgets/custom_filled_btn.dart';
import '../../../../core/widgets/custom_outllined_btn.dart';
import '../../../../theme/text_scheme.dart';
import '../controller/receipt_ctrl.dart';

final _rCtrl = Get.find<ReceiptCtrl>();

class PostingReceipt extends StatelessWidget {
  const PostingReceipt({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: Obx(
        () => _rCtrl.requestInProgress1.value
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
                      _rCtrl.progressStatus.value,
                      style: bodyLarge(textTheme).copyWith(
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              )
            : (_rCtrl.requestFailure != null)
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
                          _rCtrl.requestFailure!.errorMessage,
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
                                colorFilter: const ColorFilter.mode(
                                  Colors.green,
                                  BlendMode.srcIn,
                                ),
                              ),
                              const SizedBox(height: 30),
                              Text(
                                'Receipt Posted',
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
                  ),
      ),
      bottomNavigationBar: const CustomerBasketBottomBar(),
    );
  }

  Widget progressMessage(BuildContext context, String data) {
    final textTheme = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.primary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(0),
      ),
      child: Text(
        data,
        style: bodyMedium(textTheme).copyWith(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: color.surface,
        ),
      ),
    );
  }
}

class CustomerBasketBottomBar extends StatelessWidget {
  const CustomerBasketBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Obx(
        () => _rCtrl.requestInProgress1.value
            ? const SizedBox()
            : (_rCtrl.requestFailure != null)
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
                            _rCtrl.postReceipt();
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

  Future<void> backToHome(BuildContext context) async {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }
}
