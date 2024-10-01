import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../core/constants/image_path_const.dart';
import '../../../../theme/text_scheme.dart';
import '../../../shared/presentation/controller/shared_ctrl.dart';

final _shCtrl = Get.find<SharedCtrl>();

class MbsShopList extends StatelessWidget {
  const MbsShopList({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;

    _shCtrl.fetchUsers();

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

                  return ListTile(
                    leading: CircleAvatar(
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
                    title: Text(
                      user.address.toUpperCase(),
                      style: bodyBold(textTheme),
                    ),
                    subtitle: Text(
                      user.fullName,
                      style: bodyMedium(textTheme),
                    ),
                    onTap: () {
                      _shCtrl.setSelectedShopDetails = user;
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
