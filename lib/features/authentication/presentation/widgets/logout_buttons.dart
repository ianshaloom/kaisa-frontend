import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/authrepo_controller.dart';

class LogOutButtonOne extends StatelessWidget {
  const LogOutButtonOne({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthRepoController>();

    return IconButton(
      onPressed: () async {
        await controller.signOut();
        await controller.deleteUser();
      },
      icon: const Icon(Icons.logout),
    );
  }
}
