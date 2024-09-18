import 'package:flutter/material.dart';
import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/datasources/firestore/models/phone-transaction/phone_transaction.dart';
import '../../../../core/utils/utility_methods.dart';
import '../../../../core/widgets/snacks.dart';
import '../../../../router/route_names.dart';
import '../controller/phone_transaction_ctrl.dart';

final _ctrl = Get.find<PhoneTransactionCtrl>();

class ReceiveScan extends StatelessWidget {
  const ReceiveScan({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      body: AiBarcodeScanner(
        hideGalleryButton: true,
        hideSheetDragHandler: true,
        hideSheetTitle: true,
        cutOutSize: 0,
        cutOutWidth: 330,
        cutOutHeight: 170,
        borderWidth: 10,
        borderRadius: 17,
        borderColor: color.primary,
        errorColor: color.error,
        onDispose: () {
          debugPrint("Barcode scanner disposed!");
        },
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.normal,
          cameraResolution: const Size(1920, 1080),
          formats: [BarcodeFormat.code128],
          detectionTimeoutMs: 0,
        ),
        validator: (value) {
          if (value.barcodes.isEmpty) {
            return false;
          }

          if (!(value.barcodes.first.rawValue?.length == 15)) {
            return false;
          }

          // check if the scanned value matches the selected phone imei
          if ((value.barcodes.first.rawValue !=
                  _ctrl.selectedTransaction.imei) &&
              !_ctrl.isValidated) {
            _ctrl.isValidated = true;
            _popAndShowError(context, "IMEI's do not match, try again");
            return false;
          }

          _ctrl.isValidated
              ? null
              : receiveOrder(context, _ctrl.selectedTransaction);
          return true;
        },
      ),
    );
  }

  Future<void> _toReceivingOrder(BuildContext context) async {
    Navigator.of(context).pop();
    _ctrl.actionFromTH
        ? context.go(AppNamedRoutes.toReceivingOrderTH)
        : context.go(AppNamedRoutes.toReceivingOrder);
  }

  Future<void> receiveOrder(
      BuildContext context, PhoneTransaction transaction) async {
    await _toReceivingOrder(context).then((value) async {
      _ctrl.isValidated = true;

      final order = transaction.copyWith(
        status: 'Delivered',
        receivedAt: todayDateFormatted(),
      );

      _ctrl.beingCompleted = order;

      await _ctrl.completePhoneTransaction();
    });
  }

  // pop the current screen, and show snackbar error
  Future<void> _popAndShowError(BuildContext context, String message) async {
    Navigator.of(context).pop();
    final snack = Snack();
    snack.showSnackBar(context: context, message: message);
  }
}
