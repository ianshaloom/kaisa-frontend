import 'package:get/get.dart';
import 'package:kaisa/features/shared/data/repository/shared_abs_impl.dart';
import 'package:kaisa/features/shared/domain/usecase/shared_usecase.dart';

import 'shared_ctrl.dart';

class SharedCtrlBind extends Bindings {
  @override
  void dependencies() {
    Get.put(SharedCtrl(SharedUsecase(SharedAbsImpl())));
  }
}
