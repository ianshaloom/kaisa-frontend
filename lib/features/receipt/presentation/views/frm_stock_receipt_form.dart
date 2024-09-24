import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/custom_filled_btn.dart';
import '../../../../core/widgets/snacks.dart';
import '../../../../theme/text_scheme.dart';
import '../../domain/entity/receipt_entity.dart';
import '../controller/receipt_ctrl.dart';
import '../widgets/receipt_image.dart';
import '../widgets/seg_buttons.dart';
import 'posting_receipt.dart';

final _rCtrl = Get.find<ReceiptCtrl>();

class FrmStockReceiptForm extends StatelessWidget {
  FrmStockReceiptForm({super.key});

  final TextEditingController _receiptNoCtrl = TextEditingController();
  final TextEditingController _cusNameCtrl = TextEditingController();
  final TextEditingController _cusPhoneCtrl = TextEditingController();
  final TextEditingController _cashPriceCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;

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
        ),
        body: ListView(
          // padding: const EdgeInsets.all(8),
          children: [
            ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: 100,
                  maxHeight: 300,
                ),
                child: ReceiptImage(imei: _rCtrl.imei)),
            const SizedBox(height: 15),
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
                    Row(
                      children: [
                        const Spacer(),
                        Obx(() {
                          return Text(
                            DateFormat.yMMMd().format(_rCtrl.date.value),
                            style:
                                bodyRegular(textTheme).copyWith(fontSize: 13),
                          );
                        }),
                        const SizedBox(width: 5),
                        IconButton(
                          onPressed: () => _showCalendar(context),
                          icon: const Icon(CupertinoIcons.calendar),
                        ),
                      ],
                    ),
                    const SingleChoice(),
                    const SizedBox(height: 10),
                    readOnlyField('IMEI: ${_rCtrl.imei}', context),
                    const SizedBox(height: 15),
                    readOnlyField('Device: ${_rCtrl.deviceDetails}', context),
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
              onPressed: () async {
                postReceipt(context);
              },
              pad: 5,
            ),
          ],
        ));
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
    if (_rCtrl.images.isEmpty || _rCtrl.images.length < 2) {
      Snack().showSnackBar(
          context: context, message: 'Please select at least two images');

      return;
    }

    if (_rCtrl.org.value == Org.none) {
      Snack().showSnackBar(
          context: context, message: 'Please select device loan company');

      return;
    }

    if (_formKey.currentState!.validate()) {
      int cashPrice;
      int receiptNo;
      String customerPhoneNo = _cusPhoneCtrl.text.trim();

      try {
        receiptNo = int.parse(_receiptNoCtrl.text.trim());
      } catch (e) {
        Snack()
            .showSnackBar(context: context, message: 'Invalid receipt number');

        return;
      }

      if (customerPhoneNo.length < 10) {
        Snack().showSnackBar(
            context: context,
            message: 'Phone number must be at least 10 digits');

        return;
      }

      try {
        cashPrice = int.parse(_cashPriceCtrl.text.trim());
      } catch (e) {
        Snack().showSnackBar(context: context, message: 'Invalid cash amount');

        return;
      }

      final customerName = _cusNameCtrl.text.trim().toUpperCase();

      ReceiptEntity receipt = ReceiptEntity(
        imei: int.parse(_rCtrl.imei),
        receiptNo: receiptNo,
        customerName: customerName,
        customerPhoneNo: customerPhoneNo,
        deviceDatails: _rCtrl.deviceDetails,
        cashPrice: cashPrice,
        receiptImgUrl: _rCtrl.downloadUrls,
        shopId: _rCtrl.shopId,
        receiptDate: _rCtrl.date.value,
        addeOn: DateTime.now(),
        smUuid: _rCtrl.smUuid,
        org: _rCtrl.organisation,
      );

      _rCtrl.tReceipt = receipt;

      await toPostingPage(context).then((value) {
        _rCtrl.postReceipt();
      });
    }
  }

  void _showCalendar(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      _rCtrl.date.value = date;
    }
  }

  Future toPostingPage(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PostingReceipt(),
      ),
    );
  }
}
