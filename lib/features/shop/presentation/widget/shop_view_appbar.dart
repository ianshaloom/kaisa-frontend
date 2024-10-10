import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../core/constants/image_path_const.dart';
import '../controller/shop_ctrl.dart';
import 'mbs_filter.dart';

final h = Get.find<ShopCtrl>();

class ShopViewAppbar extends StatelessWidget {
  const ShopViewAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final color1 = color.primary;
    final color2 = color.onSurface.withOpacity(0.3);
    final font = Theme.of(context).textTheme.bodyLarge;

    final font1 = font!.copyWith(
      fontWeight: FontWeight.w900,
      color: color1,
      fontSize: 15,
    );

    final font2 = font.copyWith(
      fontWeight: FontWeight.w900,
      color: color2,
      fontSize: 13.5,
    );

    const double width = 8;

    return Row(
      children: [
        Obx(() {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  h.index.value = 0;
                  _changed();
                  h.shopAnalysis();
                },
                child: Text(
                  'All',
                  style: h.index.value == 0 ? font1 : font2,
                ),
              ),
              const SizedBox(width: width),
              GestureDetector(
                onTap: () {
                  h.index.value = 1;
                  _changed();
                  h.shopAnalysis();
                },
                child: Text(
                  'Watu',
                  style: h.index.value == 1 ? font1 : font2,
                ),
              ),
              const SizedBox(width: width),
              GestureDetector(
                onTap: () {
                  h.index.value = 2;
                  _changed();
                  h.shopAnalysis();
                },
                child: Text(
                  'M-Kopa',
                  style: h.index.value == 2 ? font1 : font2,
                ),
              ),
              const SizedBox(width: width),
              GestureDetector(
                onTap: () {
                  h.index.value = 3;
                  _changed();
                  h.shopAnalysis();
                },
                child: Text(
                  'Onfon',
                  style: h.index.value == 3 ? font1 : font2,
                ),
              ),
            ],
          );
        }),
        const Spacer(),
        IconButton(
          onPressed: () => _showFilterMBS(context),
          // cupertino filter icon
          icon: SvgPicture.asset(filter),
        ),
      ],
    );
  }

  void _changed() {
    if (h.index.value == 0) {
      h.analysis.value = 'All';
    } else if (h.index.value == 1) {
      h.analysis.value = 'Watu';
    } else if (h.index.value == 2) {
      h.analysis.value = 'M-Kopa';
    } else if (h.index.value == 3) {
      h.analysis.value = 'Onfon';
    }
  }

  void _showFilterMBS(BuildContext context) {
    if (!h.isFiltering) {
      h.resetFilterss();
    }
    // show filter
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      builder: (context) {
        return const MbsFilter();
      },
    );
  }
}
