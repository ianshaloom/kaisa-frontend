import 'dart:async';

import 'package:get/get.dart';
import 'package:kaisa/features/homepage/presentation/controller/homepagectrl.dart';

import 'features/authentication/presentation/controller/authrepo_controller_binding.dart';
import 'features/phonetransaction/presentation/controller/phonetransit_bind.dart';

FutureOr<void> init() async {
  AuthRepoBinding().dependencies();

  Get.lazyPut(
    () => HomePageCtrl(),
  );

  PhoneTransitBind().dependencies();
}
