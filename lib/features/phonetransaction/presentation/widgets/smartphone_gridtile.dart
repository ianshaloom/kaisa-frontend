import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/utils/utility_methods.dart';
import '../../../../router/route_names.dart';
import '../../../../theme/text_scheme.dart';
import '../../domain/entity/smartphone_entity.dart';
import '../controller/phone_transaction_ctrl.dart';

final _phoneTransactionCtrl = Get.find<PhoneTransactionCtrl>();

class SmartphoneGridTile extends StatelessWidget {
  final SmartphoneEntity smartphone;
  final int index;
  const SmartphoneGridTile(
      {super.key, required this.smartphone, required this.index});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        context.go(AppNamedRoutes.toSmartPhoneDetails);
        _phoneTransactionCtrl.clearSelectedShop(smartphone);
      },
      child: SizedBox(
        height: 170,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.05),
                  borderRadius: index.isEven
                      ? const BorderRadius.only(
                          topRight: Radius.circular(5),
                          bottomRight: Radius.circular(5),
                        )
                      : const BorderRadius.only(
                          topLeft: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                        ),
                ),
                child: Center(
                  child: Hero(
                    tag: smartphone.id,
                    child: CachedNetworkImage(
                      imageUrl: generateImageUrl(smartphone.imageUrl),
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: colorScheme.primary.withOpacity(0.1),
                        highlightColor: colorScheme.primary.withOpacity(0.2),
                        child: Container(
                          color: colorScheme.primary.withOpacity(0.1),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5, left: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${smartphone.ram} ~ ${smartphone.storage}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 9,
                        ),
                  ),
                  Text(
                    smartphone.name,
                    style: bodyMedium(textTheme).copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
