import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaisa/theme/text_scheme.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/utils/utility_methods.dart';
import '../controller/phone_transaction_ctrl.dart';
import '../widgets/description_tile.dart';

final _ptCtrl = Get.find<PhoneTransactionCtrl>();

class SmartphoneDetailPage extends StatelessWidget {
  const SmartphoneDetailPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final smartphone = _ptCtrl.selectedPhone;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 11,
            child: Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Hero(
                tag: smartphone.id,
                child: CachedNetworkImage(
                  imageUrl: generateImageUrl(smartphone.imageUrl),
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: color.primary.withOpacity(0.1),
                    highlightColor: color.primary.withOpacity(0.2),
                    child: Container(
                      color: color.primary.withOpacity(0.1),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 9,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                color: color.onSurface.withOpacity(0.05),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '${smartphone.name} features',
                        style: bodyBold(textTheme).copyWith(
                          fontSize: 14,
                          color: color.primary,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.only(top: 5),
                      children: [
                        DescriptionTile(
                          description: 'RAM ${smartphone.ram}',
                        ),
                        DescriptionTile(
                          description: 'Internal Storage ${smartphone.storage}',
                        ),
                        DescriptionTile(
                          description: 'Battery ${smartphone.battery}',
                        ),
                        DescriptionTile(
                          description: 'Main Camera ${smartphone.mainCamera}',
                        ),
                        DescriptionTile(
                          description: 'Front Camera ${smartphone.frontCamera}',
                        ),
                        DescriptionTile(
                          description: 'Display ${smartphone.display}',
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}




/*

Expanded(
              flex: 9,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        margin: const EdgeInsets.only(right: 5, top: 10),
                        decoration: BoxDecoration(
                          color: color.onSurface.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 5, top: 10, bottom: 5),
                                    decoration: BoxDecoration(
                                      color: color.primary,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 10, top: 10, bottom: 5),
                                    decoration: BoxDecoration(
                                      color: color.onSurface,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              margin: const EdgeInsets.only(
                                left: 5,
                                top: 5,
                              ),
                              decoration: BoxDecoration(
                                color: color.onSurfaceVariant.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
*/