// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../theme/text_scheme.dart';
import '../controller/authrepo_controller.dart';
import '../widgets/signup_page_1.dart';
import '../widgets/signup_page_2.dart';

final _ctrl = Get.find<AuthController>();

class SignUpPage extends StatelessWidget {
  const SignUpPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: const Text('Create Account'),
            scrolledUnderElevation: 0,
            titleTextStyle: textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 25,
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                _ctrl.cleanUp();
                FocusScope.of(context).unfocus();
                Navigator.pop(context);
              },
            ),
            bottom: PreferredSize(
              preferredSize:
                  const Size.fromHeight(30.0), // Set your desired height
              child: Container(
                margin: const EdgeInsets.only(
                  left: 16,
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Please enter your details.',
                  style: bodyMedium(textTheme).copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            sliver: SliverToBoxAdapter(
              child: Obx(
                () => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                  child: _ctrl.pageIndex.value == 0
                      ? SignupPage1()
                      : SignupPage2(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
