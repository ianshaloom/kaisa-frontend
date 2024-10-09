import 'package:get/state_manager.dart';


class HomePageCtrl extends GetxController {
 
  var navIndex = 0.obs;
  void navOnPressed(int i) {
    navIndex.value = i;
  }

  bool get isHome => navIndex.value == 0;
  bool get isAnalysis => navIndex.value == 2;



}




