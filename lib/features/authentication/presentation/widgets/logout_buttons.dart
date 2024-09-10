import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/authrepo_controller.dart';

class LogOutButtonOne extends StatelessWidget {
  const LogOutButtonOne({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return IconButton(
      onPressed: () async {
        await controller.signOut();
      },
      icon: const Icon(Icons.logout),
    );
  }
}
