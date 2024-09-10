// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/widgets/custom_filled_btn.dart';
import '../../../../../theme/text_scheme.dart';
import '../../../../core/widgets/snacks.dart';
import '../controller/authrepo_controller.dart';
import '../widgets/custom_textfields.dart';

// SECTION: Forgot Password Page
/* -------------------------------------------------------------------------- */
class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: const Text('Forgot Password'),
            centerTitle: true,
            titleTextStyle: textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 25,
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                emailController.clear();
                Navigator.pop(context);
              },
            ),
            bottom: PreferredSize(
              preferredSize:
                  const Size.fromHeight(55.0), // Set your desired height
              child: Container(
                margin: const EdgeInsets.only(left: 16, right: 5),
                alignment: Alignment.centerLeft,
                child: Text(
                  'No problem at all, enter your email '
                  'address to receive a password reset link',
                  style: bodyMedium(textTheme).copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            // flexibleSpace: Align(
            //   alignment: Alignment.bottomLeft,
            //   child:
            // ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.03),
            sliver: SliverToBoxAdapter(
              child: Form(
                key: formKey,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 0),
                      EmailTextFormField(
                        controller: emailController,
                      ),
                      const SizedBox(height: 20),
                      CustomFilledBtn(
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          if (formKey.currentState!.validate()) {
                            await _sendPasswordResetLink(
                              emailController.text,
                              context,
                            ).then((value) => Navigator.pop(context));
                          }
                        },
                        title: 'Send reset link',
                        pad: 0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendPasswordResetLink(
      String email, BuildContext context) async {
    final controller = Get.find<AuthController>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: Dialog(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: const Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16.0),
                Text('Sending Reset Link...'),
              ],
            ),
          ),
        ),
      ),
    );

    await controller.sendPasswordResetLink(email: email);

    if (controller.resetLinkSent.value) {
      clearControllers();
      Navigator.pop(context);
      _instance.showSnackBar(
          context: context, message: 'Password Reset Link Sent Successfully');
    } else {
      Navigator.pop(context);
      _instance.showSnackBar(
        context: context,
        message: controller.resetLinkFailure[0].errorMessage,
      );
    }
  }

  void clearControllers() {
    emailController.clear();
  }
}

final Snack _instance = Snack();
