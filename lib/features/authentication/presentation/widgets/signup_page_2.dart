// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaisa/core/widgets/custom_outllined_btn.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../core/widgets/custom_filled_btn.dart';
import '../../../../core/widgets/snacks.dart';
import '../../../../theme/text_scheme.dart';
import '../controller/authrepo_controller.dart';
import 'custom_textfields.dart';

final _ctrl = Get.find<AuthController>();
final Snack _instance = Snack();

class SignupPage2 extends StatelessWidget {
  final TextEditingController emailController = TextEditingController(
    text: _ctrl.email,
  );
  final TextEditingController passwordController = TextEditingController(
    text: _ctrl.password,
  );
  final TextEditingController codeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SignupPage2({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          EmailTextFormField(controller: emailController),
          const SizedBox(height: 15),
          PassWordTextFormField(controller: passwordController),
          const SizedBox(height: 15),
          ActivateTextFormField(controller: codeController),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: CustomOutlinedBtn(
                    title: 'Back', onPressed: previousPage, pad: 0),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 5,
                child: CustomFilledBtn(
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    final form = _formKey.currentState!;

                    if (form.validate()) {
                      final String email = emailController.text.trim();
                      final String password = passwordController.text.trim();
                      final int code = int.parse(codeController.text.trim());

                      _ctrl.saveDataPage2(
                        email: email,
                        code: code,
                        password: password,
                      );

                      await signingUp(context);
                    }
                  },
                  title: 'Sign Up',
                  pad: 0.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                  text: 'By creating an account,  you agree to our ',
                  style: textTheme.labelMedium,
                ),
                TextSpan(
                  text: ' Terms & Condition',
                  style: textTheme.labelMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: ' and ',
                  style: textTheme.labelMedium,
                ),
                TextSpan(
                  text: 'Privacy Policy.*',
                  style: textTheme.labelMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget progressMessage(BuildContext context, String data) {
    final textTheme = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.primary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(0),
      ),
      child: Text(
        data,
        style: bodyMedium(textTheme).copyWith(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: color.surface,
        ),
      ),
    );
  }

  Future signingUp(BuildContext context) async {
    final color = Theme.of(context).colorScheme;
    showDialog(
      barrierColor: color.primary.withOpacity(0.2),
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: SizedBox(
          height: 100,
          width: 300,
          child: Column(
            children: [
              LoadingAnimationWidget.fourRotatingDots(
                color: color.primary,
                size: 50,
              ),
              Obx(() {
                if (_ctrl.isCheckingQualification.value) {
                  return progressMessage(
                      context, 'Verifying activation code...');
                }

                if (_ctrl.isSigningUp.value) {
                  return progressMessage(context, 'Creating account...');
                }

                return progressMessage(context, 'Please wait...');
              }),
            ],
          ),
        ),
      ),
    );

    await _checkQualification(
      _ctrl.phoneNumber,
      context,
    );
  }

// check if number qualify for registration
  Future<void> _checkQualification(
      String phoneNumber, BuildContext context) async {
    await _ctrl.checkQualification();

    if (!_ctrl.isQualified.value) {
      Navigator.pop(context);
      _instance.showSnackBar(
        context: context,
        message: 'Please use a correct activation code',
      );
    } else {
      await _signUp(context);
    }
  }

  Future _signUp(BuildContext context) async {
    await _ctrl.createUser();

    if (_ctrl.createdUser.isNotEmpty) {
      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      Navigator.pop(context);
      _instance.showSnackBar(
        context: context,
        message: _ctrl.createdUserFailure[0].errorMessage,
      );
    }
  }

  void previousPage() {
    _ctrl.switchPage(0);
  }
}
