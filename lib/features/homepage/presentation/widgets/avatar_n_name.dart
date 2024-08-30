import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kaisa/theme/text_scheme.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constants/image_path_const.dart';
import '../../../../core/datasources/firestore/models/kaisa-user/kaisa_user.dart';
import '../../../../core/datasources/hive/hive_init.dart';
import '../../../../core/utils/utility_methods.dart';
import '../controller/homepagectrl.dart';

final _controller = Get.find<HomePageCtrl>();

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
          return Shimmer(
            gradient: LinearGradient(
              colors: [
                color.surface,
                color.onSurface.withOpacity(0.1),
                color.surface,
              ],
            ),
            child: Row(
              children: [
                const Row(
                  children: [
                    CircleAvatar(
                      radius: 35.5,
                    ),
                    SizedBox(width: 10),
                    Text(
                      '',
                    ),
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          );
        } else {
          final userData = box.values.first;
          _controller.userData = KaisaUser.fromUserHiveData(userDataHive: userData);
          

          return Row(
            children: [
              CircleAvatar(
                backgroundColor: color.surface,
                backgroundImage: const AssetImage(defaultProfilePicture),
                radius: 30,
              ),
              const SizedBox(width: 0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    greetingMessage(),
                    style: bodyDefault(textTheme),
                  ),
                  Text(userData.fullName, style: bodyDefaultBold(textTheme)),
                ],
              ),
            ],
          );
        }
      },
    );
  }
}
