import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/custom_filled_btn.dart';
import '../../../../core/widgets/custom_outllined_btn.dart';
import '../../../../router/route_names.dart';
import '../controller/authrepo_controller.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    // Brightness brightness = Theme.of(context).brightness;
    return Scaffold(
      // app bar prevent status bar from being transparent
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.surface,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 500,
            child: Center(
              child: Text(
                company,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ),
          const Spacer(),
          Container(
            color: colorScheme.surface,
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: _buildPageButtons(context),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPageButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            child: CustomFilledBtn(
          title: 'Sign In',
          pad: 10,
          onPressed: () => context.go(AppNamedRoutes.toSignIn),
          //onPressed: () {},
        )),
        const SizedBox(width: 10),
        Expanded(
            child: CustomOutlinedBtn(
          title: 'Sign Up',
          pad: 10,
          onPressed: () async {
            final ctrl = Get.find<AuthController>();
            ctrl.address.value = '';
            context.go(AppNamedRoutes.toSignUp);
          },
        )),
      ],
    );
  }
}
