import 'dart:async';

import 'package:kaisa/shared/shared_ctrl_bind.dart';

import 'features/authentication/presentation/controller/authrepo_controller_binding.dart';

FutureOr<void> init() async {
  AuthRepoBinding().dependencies(); 
  SharedCtrlBind().dependencies();
}
