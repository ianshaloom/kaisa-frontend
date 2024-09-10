import 'package:get/state_manager.dart';

import '../../../../core/constants/network_const.dart';
import '../../../../core/datasources/firestore/models/kaisa-user/kaisa_user.dart';

class HomePageCtrl extends GetxController {
  KaisaUser userData = KaisaUser.empty;
  var profileImgUrl = profilePictures[3].obs;
}
