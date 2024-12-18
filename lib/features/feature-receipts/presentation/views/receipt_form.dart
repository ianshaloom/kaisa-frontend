import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/constants/image_path_const.dart';
import '../../../../core/utils/utility_methods.dart';
import '../../../../core/widgets/custom_filled_btn.dart';
import '../../../../core/widgets/snacks.dart';
import '../../../../theme/text_scheme.dart';
import '../../../stock/presentation/widgets/mbs_stock_items.dart.dart';
import '../../f_receipt.dart';
import '../../f_receipt_ctrl.dart';
import '../widgets/receipt_image.dart';
import '../widgets/seg_buttons.dart';
import 'posting_receipt.dart';

class ReceiptForm extends StatelessWidget {
  ReceiptForm({super.key});

  final TextEditingController _receiptNoCtrl = TextEditingController();
  final TextEditingController _cusNameCtrl = TextEditingController();
  final TextEditingController _cusPhoneCtrl = TextEditingController();
  final TextEditingController _cashPriceCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;

    final rCtrl = Get.find<FReceiptCtrl>();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(CupertinoIcons.back),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => _stockItemSelectionDialog(context),
            child: Obx(
              () => Text(
                rCtrl.imeiz.value.isEmpty
                    ? 'Select Device'
                    : rCtrl.deviceDetailsz.value,
                style: bodyBold(textTheme).copyWith(
                  fontSize: 11,
                  color: color.primary,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        // padding: const EdgeInsets.all(8),
        children: [
          ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: 100,
                maxHeight: 300,
              ),
              child: ReceiptImage()),
          const SizedBox(height: 5),
          Divider(
            thickness: 10,
            color: color.onSurface.withOpacity(0.05),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  Obx(
                    () => readOnlyField('IMEI: ${rCtrl.imeiz.value}', context),
                  ),
                  const SizedBox(height: 5),
                  Obx(
                    () => readOnlyField(
                        'Device: ${rCtrl.deviceDetailsz.value}', context),
                  ),
                  const SizedBox(height: 5),
                  const SingleChoice(),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () => _showCalendar(context),
                          icon: SvgPicture.asset(
                            calendar,
                            colorFilter: ColorFilter.mode(
                              color.onSurface.withOpacity(0.5),
                              BlendMode.srcIn,
                            ),
                            height: 50,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Receipt Date',
                              style:
                                  bodyRegular(textTheme).copyWith(fontSize: 11),
                            ),
                            const SizedBox(width: 5),
                            Obx(
                              () => rCtrl.date.isEmpty
                                  ? Text(
                                      "Choose a Date",
                                      style: bodyMedium(textTheme).copyWith(
                                        color: color.onSurface.withOpacity(0.5),
                                      ),
                                    )
                                  : Text(
                                      newDate(rCtrl.date.first),
                                      style: bodyMedium(textTheme).copyWith(
                                        color: color.onSurface,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _receiptNoCtrl,
                    keyboardType: TextInputType.number,
                    autocorrect: false,
                    textInputAction: TextInputAction.next,
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                    decoration: InputDecoration(
                      labelText: 'Receipt Number',
                      labelStyle: bodyRegular(textTheme).copyWith(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Receipt number is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _cusNameCtrl,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    autocorrect: false,
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                    decoration: InputDecoration(
                      labelText: 'Customer Name',
                      labelStyle: bodyRegular(textTheme).copyWith(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Customer name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _cusPhoneCtrl,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    autocorrect: false,
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                    decoration: InputDecoration(
                      labelText: 'Customer Phone Number',
                      labelStyle: bodyRegular(textTheme).copyWith(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Phone number is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _cashPriceCtrl,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    autocorrect: false,
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                    decoration: InputDecoration(
                      labelText: 'Cash Price',
                      labelStyle: bodyRegular(textTheme).copyWith(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Cash price is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
          Divider(
            thickness: 10,
            color: color.onSurface.withOpacity(0.05),
          ),
          CustomFilledBtn(
            title: 'Post Receipt',
            onPressed: () => postReceipt(context),
            pad: 5,
          ),
        ],
      ),
    );
  }

  void _stockItemSelectionDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (context) => const MbsStockItems(),
    );
  }

  Widget readOnlyField(
    String labelText,
    BuildContext context,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;

    return Container(
      height: 50,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: color.onSurface.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        labelText,
        style: bodyRegular(textTheme).copyWith(fontSize: 13),
      ),
    );
  }

  void postReceipt(BuildContext context) async {
    final rCtrl = Get.find<FReceiptCtrl>();

    if (rCtrl.imeiz.value.isEmpty || rCtrl.deviceDetailsz.value.isEmpty) {
      Snack().showSnackBar(context: context, message: 'Please select a device');

      return;
    }

    if (rCtrl.images.isEmpty || rCtrl.images.length < 2) {
      Snack().showSnackBar(
          context: context, message: 'Please select at least two images');

      return;
    }

    if (rCtrl.org.value == Org.none) {
      Snack().showSnackBar(
          context: context, message: 'Please select device loan company');

      return;
    }

    if (rCtrl.date.isEmpty) {
      Snack().showSnackBar(
          context: context, message: 'Please select receipt date');

      return;
    }

    if (_formKey.currentState!.validate()) {
      int cashPrice;
      int receiptNo;
      String customerPhoneNo = _cusPhoneCtrl.text.trim();

      if (customerPhoneNo.length < 10) {
        Snack().showSnackBar(
            context: context,
            message: 'Phone number must be at least 10 digits');

        return;
      }

      try {
        receiptNo = int.parse(_receiptNoCtrl.text.trim());
      } catch (e) {
        Snack()
            .showSnackBar(context: context, message: 'Invalid receipt number');

        return;
      }

      try {
        cashPrice = int.parse(_cashPriceCtrl.text.trim());
      } catch (e) {
        Snack().showSnackBar(context: context, message: 'Invalid cash amount');

        return;
      }

      final customerName = _cusNameCtrl.text.trim().toUpperCase();

      final imei = int.parse(rCtrl.imeiz.value);
      final deviceDetails = rCtrl.deviceDetailsz.value;
      final downloadUrls = rCtrl.downloadUrls;
      final shopId = rCtrl.shopId;
      final receiptDate = rCtrl.date.first;
      final smUuid = rCtrl.smUuid;
      final org = rCtrl.organisation;

      ReceiptEntity receipt = ReceiptEntity(
        imei: imei,
        receiptNo: receiptNo,
        customerName: customerName,
        customerPhoneNo: customerPhoneNo,
        deviceDatails: deviceDetails,
        cashPrice: cashPrice,
        receiptImgUrl: downloadUrls,
        shopId: shopId,
        receiptDate: receiptDate,
        addeOn: DateTime.now(),
        smUuid: smUuid,
        org: org,
      );

      rCtrl.tReceipt = receipt;

      await toPostingPage(context);
    }
  }

  void _showCalendar(BuildContext context) async {
    final rCtrl = Get.find<FReceiptCtrl>();

    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      rCtrl.date.assign(date);
    }
  }

  Future toPostingPage(BuildContext context) async {
    final rCtrl = Get.find<FReceiptCtrl>();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PostingReceipt(),
      ),
    );

    rCtrl.postReceipt();
  }
}
