import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:kaisa/theme/text_scheme.dart';

import '../../../../core/constants/image_path_const.dart';
import '../../../../core/utils/utility_methods.dart';
import '../../../../router/route_names.dart';
import '../controller/phone_transaction_ctrl.dart';
import '../widgets/custom_bottomnav.dart';
import '../widgets/shops_list_mbs_dialog.dart';
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
        actions: [
          TextButton(
            onPressed: () => _shopSelectionDialog(context),
            child: Obx(
              () => Text(
                _ptCtrl.isShopEmpty
                    ? 'Select Shop'
                    : _ptCtrl.selectedShopAddress.value,
                style: bodyDefaultBold(textTheme).copyWith(
                  fontSize: 12,
                  color: color.primary,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 11,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Hero(
                  tag: smartphone.id,
                  child: Image(
                      image: NetworkImage(imageUrl(smartphone.imageUrl)))),
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
                        smartphone.name,
                        style: bodyDefaultBold(textTheme).copyWith(
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
                        ListTile(
                          minTileHeight: 10,
                          minLeadingWidth: 10,
                          minVerticalPadding: 7,
                          leading: CircleAvatar(
                            radius: 3,
                            backgroundColor: color.primary,
                          ),
                          title: Obx(
                            () => Text(
                              _ptCtrl.barcode.value.isEmpty
                                  ? 'Scan Barcode to get IMEI'
                                  : _ptCtrl.barcode.value,
                              style: bodyDefaultBold(textTheme).copyWith(
                                fontSize: 12,
                                color: color.primary,
                              ),
                            ),
                          ),
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
      bottomNavigationBar: const CustomBottomNavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          toSendingScan(context);
        },
        child: SvgPicture.asset(
          scanOrder,
          colorFilter: ColorFilter.mode(color.primary, BlendMode.srcIn),
          height: 35,
        ),
      ),
    );
  }

  Future<void> _shopSelectionDialog(BuildContext context) async {
    return await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (context) {
        return const ShopsListDialog();
      },
    );
  }

  Future<void> toSendingScan(BuildContext context) async {
    context.go(AppNamedRoutes.toSendScan);
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