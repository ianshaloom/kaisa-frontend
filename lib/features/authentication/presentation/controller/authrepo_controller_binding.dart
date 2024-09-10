import 'package:get/get.dart';

import '../../data/provider/network/authentication_ds.dart';
import '../../data/repository/auth_repo_impl.dart';
import '../../domain/usecase/auth_usecase.dart';
import 'authrepo_controller.dart';

class AuthRepoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthUC>(() => AuthUC(AuthRepoImpl(FirebaseAuthentification())));
    Get.lazyPut<AuthController>(() => AuthController(Get.find<AuthUC>()));
  }
}
