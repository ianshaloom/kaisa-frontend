import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/utils/utility_methods.dart';
import '../../../../router/route_names.dart';
import '../../../../theme/text_scheme.dart';
import '../../../../shared/shared_ctrl.dart';

class ProfilePreveiw extends StatelessWidget {
  const ProfilePreveiw({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = Get.find<SharedCtrl>().userData;
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 10),
      child: Row(
        children: [
          const SizedBox(width: 3),
          CachedNetworkImage(
            imageUrl: userData.imgUrl,
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
          const SizedBox(width: 5),
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
}
