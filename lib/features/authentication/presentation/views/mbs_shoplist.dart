import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../core/constants/image_path_const.dart';
import '../../../../shared/shared_ctrl.dart';
import '../../../../theme/text_scheme.dart';
import '../controller/authrepo_controller.dart';

final _shCtrl = Get.find<SharedCtrl>();

class MbsShopList extends StatelessWidget {
  const MbsShopList({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;

    _shCtrl.fetchShops();

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
                style: bodyBold(textTheme).copyWith(fontSize: 14),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),
        Expanded(
          child: Obx(
            () {
              if (_shCtrl.requestInProgress.value) {
                return Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: color.primary,
                    size: 50,
                  ),
                );
              }

              if (_shCtrl.requestFailure != null) {
                return Center(
                  child: Text(
                    _shCtrl.requestFailure!.errorMessage,
                    style: bodyBold(textTheme).copyWith(color: color.error),
                  ),
                );
              }

              return ListView.builder(
                itemCount: _shCtrl.shops.length,
                itemBuilder: (context, index) {
                  final shop = _shCtrl.shops[index];

                  return ListTile(
                    leading: CircleAvatar(
                      radius: 25,
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
                    title: Text(
                      shop.toUpperCase(),
                      style: bodyBold(textTheme),
                    ),
                    onTap: () {
                      final ctrl = Get.find<AuthController>();
                      ctrl.address.value = shop;
                      Navigator.pop(context);
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
