import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../core/constants/image_path_const.dart';
import '../../../../core/widgets/custom_filled_btn.dart';
import '../../../../core/widgets/custom_outllined_btn.dart';
import '../../../../shared/shared_ctrl.dart';
import '../../../../theme/text_scheme.dart';
import '../../f_receipt_ctrl.dart';



class PostingReceipt extends StatelessWidget {
  const PostingReceipt({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final rCtrl = Get.find<FReceiptCtrl>();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: Obx(
        () {
          if (rCtrl.uploadingImgInProgress.value) {
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
                    rCtrl.requestStatus.value,
                    style: bodyLarge(textTheme).copyWith(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            );
          }

          if (rCtrl.postingRInProgress.value) {
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
                    rCtrl.requestStatus.value,
                    style: bodyLarge(textTheme).copyWith(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            );
          }

          if (rCtrl.uploadingImgFailure != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    serverError,
                    height: 200,
                  ),
                  const SizedBox(height: 34),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      rCtrl.uploadingImgFailure!.errorMessage,
                      style: bodyRegular(textTheme),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }

          if (rCtrl.postingRFailure != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    serverError,
                    height: 200,
                  ),
                  const SizedBox(height: 34),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      rCtrl.postingRFailure!.errorMessage,
                      style: bodyRegular(textTheme),
                      textAlign: TextAlign.center,
                    ),
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
          );
        },
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

    final rCtrl = Get.find<FReceiptCtrl>();

    return SizedBox(
      child: Obx(
        () {
          if (rCtrl.uploadingImgInProgress.value ||
              rCtrl.postingRInProgress.value) {
            return const SizedBox();
          }

          if (rCtrl.uploadingImgFailure != null ||
              rCtrl.postingRFailure != null) {
            return Row(
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
                      rCtrl.postReceipt();
                    },
                    pad: 8,
                  ),
                ),
              ],
            );
          }

          return CustomFilledBtn(
            title: 'Done',
            onPressed: () => backToHome(context),
            pad: 8,
          );
        },
      ),
    );
  }

  Future<void> backToHome(BuildContext context) async {
    final rCtrl = Get.find<FReceiptCtrl>();
    // fetch receipts
    final uuid = Get.find<SharedCtrl>().userData.shopId;
    rCtrl.fetchReceipts(uuid);

    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }
}
