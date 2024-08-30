import 'package:hive_flutter/hive_flutter.dart';
import 'package:kaisa/core/constants/constants.dart';

import 'hive-models/user-data-model/hive_user_data_model.dart';

class DatabaseInit {
  // register all adapters here
  static Future<void> registerAdapters() async {
    Hive.registerAdapter(UserDataHiveAdapter());
  }

  static Future<void> initFlutter([String? subDir]) async {
    Hive.init(subDir);

    await Hive.openBox<UserDataHive>(userDataBox, path: subDir);
  }
}

class HiveBoxes {
  static Box<UserDataHive> get getUserDataBox =>
      Hive.box<UserDataHive>(userDataBox);
}

class GetMeFromHive {
  // get user data
  static UserDataHive get getUserData =>
      HiveBoxes.getUserDataBox.values.first;
}
