import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaisa/theme/text_scheme.dart';

import '../../../../core/widgets/custom_filled_btn.dart';
import '../../../receipt/presentation/controller/receipt_ctrl.dart';
import '../../../receipt/presentation/widgets/mbs_receipt_view.dart';
import '../../../../shared/shared_ctrl.dart';
import '../controller/stock_ctrl.dart';
import 'mbs_shoplist.dart';

final _sCtrl = Get.find<StockCtrl>();
final _shCtrl = Get.find<SharedCtrl>();
final _rCtrl = Get.find<ReceiptCtrl>();

class MbsMenuStockItem extends StatelessWidget {
  final bool sold;
  const MbsMenuStockItem({super.key, required this.sold});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    ShapeBorder shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    );

    return sold
        ? SingleChildScrollView(
            child: Container(
              height: 123,
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  ListTile(
                    onTap: () => toReceitView(context).then(
                      (value) => _rCtrl.fetchReceipt(),
                    ),
                    leading: const Icon(Icons.receipt),
                    title: Text(
                      'View Receipt',
                      style: bodyMedium(textTheme),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                    ),
                    shape: shape,
                  ),
                  const Spacer(),
                  CustomFilledBtn(
                    title: 'Cancel',
                    pad: 0,
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 2),
                ],
              ),
            ),
          )
        : SingleChildScrollView(
            child: Container(
              height: 123,
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  ListTile(
                    onTap: () => showShopListDialog(context),
                    leading: const Icon(Icons.send),
                    title: Text(
                      'Send as Order',
                      style: bodyMedium(textTheme),
                    ),
                    shape: shape,
                  ),
                  const Spacer(),
                  CustomFilledBtn(
                    title: 'Cancel',
                    pad: 0,
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 2),
                ],
              ),
            ),
          );
  }

  void showShopListDialog(BuildContext context) {
    // pop the current dialog
    Navigator.pop(context);

    // reset controller
    _sCtrl.reset1();
    _shCtrl.reset();

    // fetch user's shop list
    _shCtrl.fetchUsers();

    // show full screen dialog
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (context) {
        return const MbsShopList();
      },
    );
  }

  Future<void> toReceitView(BuildContext context) async {
    Navigator.pop(context);

    // show full screen dialog
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (context) {
        return const MbsReceiptView();
      },
    );
  }
}
