import 'dart:async';

import 'package:get/get.dart';
import 'package:kaisa/features/homepage/presentation/controller/homepagectrl.dart';
import 'package:kaisa/features/shared/presentation/controller/shared_ctrl_bind.dart';

import 'features/authentication/presentation/controller/authrepo_controller_binding.dart';
import 'features/phonetransaction/presentation/controller/phonetransit_bind.dart';
import 'features/receipt/presentation/controller/receipt_ctrl_bind.dart';
import 'features/stock/presentation/controller/stock_ctrl_bind.dart';

FutureOr<void> init() async {
  AuthRepoBinding().dependencies();
  SharedCtrlBind().dependencies();
  PhoneTransitBind().dependencies();
  StockCtrlBind().dependencies();
  ReceiptCtrlBind().dependencies();

  Get.lazyPut(
    () => HomePageCtrl(),
  );
}
