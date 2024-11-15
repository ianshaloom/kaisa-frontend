import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../theme/text_scheme.dart';
import '../../f_receipt_ctrl.dart';

class SingleChoice extends StatelessWidget {
  const SingleChoice({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final ctrl = Get.find<FReceiptCtrl>();

    return Obx(() {
      return SegmentedButton<Org>(
        style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        showSelectedIcon: false,
        segments: <ButtonSegment<Org>>[
          ButtonSegment<Org>(
            value: Org.none,
            label: Text(
              'None',
              style: bodyRegular(textTheme),
            ),
          ),
          ButtonSegment<Org>(
            value: Org.watu,
            label: Text(
              'Watu',
              style: bodyRegular(textTheme),
            ),
          ),
          ButtonSegment<Org>(
            value: Org.mkopa,
            label: Text(
              'Mkopa',
              style: bodyRegular(textTheme),
            ),
          ),
          ButtonSegment<Org>(
            value: Org.onfon,
            label: Text(
              'Onfon',
              style: bodyRegular(textTheme),
            ),
          ),
          ButtonSegment<Org>(
            value: Org.other,
            label: Text(
              'Other',
              style: bodyRegular(textTheme),
            ),
          ),
        ],
        selected: <Org>{ctrl.org.value},
        onSelectionChanged: (Set<Org> newSelection) {
          ctrl.org.value = newSelection.first;
        },
      );
    });
  }
}
