import 'package:flutter/material.dart';
import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/snacks.dart';
import '../controller/phone_transaction_ctrl.dart';

final _ctrl = Get.find<PhoneTransactionCtrl>();

class SendScan extends StatelessWidget {
  const SendScan({super.key});

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
        onDispose: () {
          debugPrint("Barcode scanner disposed!");
        },
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
        ),
        onDetect: (BarcodeCapture capture) {
          /// The row string scanned barcode value
          final String? scannedValue = capture.barcodes.first.rawValue;

          if (scannedValue == null) {
            _popAndShowError(context, 'Invalid IMEI');
            return;
          }
        },
        validator: (value) {
          if (value.barcodes.isEmpty) {
            return false;
          }

          if (!(value.barcodes.first.rawValue?.length == 15)) {
            return false;
          }

          _popPage(context, value.barcodes.first.rawValue!);
          return true;
        },
      ),
    );
  }

  Future<void> _popPage(
    BuildContext context,
    String scannedValue,
  ) async {
    Navigator.of(context).pop();
    _ctrl.barcode.value = scannedValue;
  }

  // pop the current screen, and show snackbar error
  Future<void> _popAndShowError(BuildContext context, String message) async {
    Navigator.of(context).pop();
    final snack = Snack();
    snack.showSnackBar(context: context, message: message);
  }
}
