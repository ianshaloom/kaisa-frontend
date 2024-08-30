// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../router/route_names.dart';
import '../../../../../core/widgets/custom_filled_btn.dart';
import '../../../../../core/widgets/snacks.dart';
import '../../../../../theme/text_scheme.dart';
import '../widgets/custom_textfields.dart';
import '../controller/authrepo_controller.dart';

//SECTION: Login Page
/* -------------------------------------------------------------------------- */
class SignInPage extends StatelessWidget {
  SignInPage({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            //elevation: Elevation.none,
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: const Text('Hi, Welcome'),
            titleTextStyle: textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 25,
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                emailController.clear();
                passwordController.clear();
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
                  'Please enter your credentials',
                  style: bodyDefault(textTheme).copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    EmailTextFormField(controller: emailController),
                    const SizedBox(height: 25),
                    PassWordTextFormField(controller: passwordController),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () =>
                            context.go(AppNamedRoutes.toForgotPass),
                        child: Text(
                          'Forgot Password?',
                          style: bodyDefaultBold(textTheme).copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    CustomFilledBtn(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        final form = formKey.currentState!;

                        if (form.validate()) {
                          final String email = emailController.text.trim();
                          final String password =
                              passwordController.text.trim();

                          await _signIn(context, email, password);
                        }
                      },
                      title: 'Sign In',
                      pad: 0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Login Page Members
  Future _signIn(BuildContext context, String email, String password) async {
    final color = Theme.of(context).colorScheme;
    final controller = Get.find<AuthRepoController>();
    showDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: SizedBox(
          height: 75,
          width: 75,
          child: CircularProgressIndicator(
            color: color.surface,
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );

    await controller.logIn(email: email, password: password);

    if (controller.loggedInUser.isNotEmpty) {
      clearControllers();
      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      Navigator.pop(context);

      _instance.showSnackBar(
        context: context,
        message: controller.loggedInFailure[0].errorMessage,
      );
    }
  }

  // clear controllers
  void clearControllers() {
    emailController.clear();
    passwordController.clear();
  }
}

final Snack _instance = Snack();
