import 'package:flutter/material.dart';
import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:get/get.dart';

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
        errorColor: color.error,
        onDispose: () {
          debugPrint("Barcode scanner disposed!");
        },
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
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
          _ctrl.isValidated
              ? null
              : _popPage(context, value.barcodes.first.rawValue!);
          return true;
        },
      ),
    );
  }

  Future<void> _popPage(
    BuildContext context,
    String scannedValue,
  ) async {
    _ctrl.isValidated = true;
    Navigator.of(context).pop();
    _ctrl.barcode.value = scannedValue;
  }
}
