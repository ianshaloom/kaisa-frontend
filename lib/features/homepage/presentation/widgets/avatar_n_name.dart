import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kaisa/core/datasources/firestore/models/kaisa-user/kaisa_user.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/datasources/hive/hive_init.dart';
import '../../../../core/utils/utility_methods.dart';
import '../../../../router/route_names.dart';
import '../../../../theme/text_scheme.dart';
import '../../../phonetransaction/presentation/controller/phone_transaction_ctrl.dart';
import '../../../shared/presentation/controller/shared_ctrl.dart';

final _pCtrl = Get.find<PhoneTransactionCtrl>();
final _sCtrl = Get.find<SharedCtrl>();

class ProfilePreveiw extends StatelessWidget {
  const ProfilePreveiw({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ValueListenableBuilder(
      valueListenable: HiveBoxes.getUserDataBox.listenable(),
      builder: (context, box, child) {
        if (box.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(left: 10, right: 5, top: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Shimmer(
                      gradient: LinearGradient(
                        colors: [
                          color.surface,
                          color.onSurface.withOpacity(0.1),
                          color.surface,
                        ],
                      ),
                      child: const CircleAvatar(
                        radius: 25,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Shimmer(
                      gradient: LinearGradient(
                        colors: [
                          color.surface,
                          color.onSurface.withOpacity(0.1),
                          color.surface,
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 10,
                            width: 100,
                            color: color.surface,
                            margin: const EdgeInsets.only(bottom: 5),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            height: 10,
                            width: 70,
                            color: color.surface,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
          );
        } else {
          final userData = box.values.first;
          assignUserData(userData);

          return Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 10),
            child: Row(
              children: [
                CachedNetworkImage(
                  imageUrl: userData.profileImgUrl,
                  height: 50,
                  width: 50,
                  placeholder: (context, url) => Shimmer(
                    gradient: LinearGradient(
                      colors: [
                        color.surface,
                        color.onSurface.withOpacity(0.1),
                        color.surface,
                      ],
                    ),
                    child: const CircleAvatar(
                      radius: 25,
                    ),
                  ),
                ),
                const SizedBox(width: 7),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      greetingMessage(),
                      style: bodyMedium(textTheme),
                    ),
                    Text(userData.fullName, style: bodyBold(textTheme)),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    context.go(AppNamedRoutes.toProfile);
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }

  void assignUserData(userData) {
    _pCtrl.userData = KaisaUser.fromUserHiveData(userDataHive: userData);
    _sCtrl.userData = KaisaUser.fromUserHiveData(userDataHive: userData);
  }
}
