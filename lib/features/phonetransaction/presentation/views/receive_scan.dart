import 'package:flutter/material.dart';
import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/datasources/firestore/models/phone-transaction/phone_transaction.dart';
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

          // check if the scanned value matches the selected phone imei
          if (value.barcodes.first.rawValue !=
              _ctrl.selectedTransaction.imeis) {
            _popAndShowError(context, 'Invalid IMEI');
            return false;
          }

          receiveOrder(context, _ctrl.selectedTransaction);
          return true;
        },
      ),
    );
  }

  Future<void> _toReceivingOrder(BuildContext context) async {
    Navigator.of(context).pop();
    _ctrl.actionFromTH ? context.go(AppNamedRoutes.toReceivingOrderTH) :
    context.go(AppNamedRoutes.toReceivingOrder);
  }

  Future<void> receiveOrder(
      BuildContext context, PhoneTransaction transaction) async {
    await _toReceivingOrder(context).then((value) async {
      final order = transaction.copyWith(
        transferId: transaction.transferId,
        status: 'Delivered',
        senderId: transaction.senderId,
        senderName: transaction.senderName,
        senderAddress: transaction.senderAddress,
        receivedAt: DateTime.now(),
        receiverId: transaction.receiverId,
        receiverName: transaction.receiverName,
        receiverAddress: transaction.receiverAddress,
        phoneName: transaction.phoneName,
        ram: transaction.ram,
        storage: transaction.storage,
        createdAt: transaction.createdAt,
        participants: transaction.participants,
        processedBy: transaction.receiverName,
      );

      _ctrl.beingCompleted = order;

      await _ctrl.completePhoneTransaction().then((value) {
        _ctrl.fetchPhoneTransactions();
      });
    });
  }

  // pop the current screen, and show snackbar error
  Future<void> _popAndShowError(BuildContext context, String message) async {
    Navigator.of(context).pop();
    final snack = Snack();
    snack.showSnackBar(context: context, message: message);
  }
}
