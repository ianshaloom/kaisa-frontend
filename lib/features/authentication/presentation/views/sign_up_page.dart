// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/widgets/custom_filled_btn.dart';
import '../../../../../core/widgets/snacks.dart';
import '../../../../../theme/text_scheme.dart';
import '../controller/authrepo_controller.dart';
import '../widgets/custom_textfields.dart';

// SECTION: Register Page
/* -------------------------------------------------------------------------- */
class SignUpPage extends StatelessWidget {
  SignUpPage({
    super.key,
  });

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: const Text('Create Account'),
            titleTextStyle: textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 25,
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                _cleanUp();
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
                  style: bodyDefault(textTheme).copyWith(
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
              child: _buildRegisterForm(context),
            ),
          ),
        ],
      ),
    );
  }

  void _cleanUp() {
    addressController.clear();
    emailController.clear();
    passwordController.clear();
  }

  Widget _buildRegisterForm(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Form(
      key: formKey,
      child: Column(
        children: [
          NormalTextFormField(
            controller: fullNameController,
            needsValidation: true,
            labelText: 'Full Name',
            errorText: 'Please enter your full name',
            prefixIcon: const Icon(Icons.person_outline),
          ),
          const SizedBox(height: 15),
          NormalTextFormField(
            controller: addressController,
            needsValidation: true,
            labelText: 'Shop Location',
            errorText: 'Please enter shop location',
            prefixIcon: const Icon(Icons.location_on_outlined),
          ),
          const SizedBox(height: 15),
          EmailTextFormField(controller: emailController),
          const SizedBox(height: 15),
          PassWordTextFormField(controller: passwordController),
          const SizedBox(height: 15),
          CustomFilledBtn(
            onPressed: () async {
              FocusScope.of(context).unfocus();
              final form = formKey.currentState!;

              if (form.validate()) {
                final String fullName = fullNameController.text.trim();
                final String email = emailController.text.trim();
                final String password = passwordController.text.trim();
                final String address = addressController.text.trim();

                await _signUp(context, fullName, email, password, address);

                addressController.clear();
                fullNameController.clear();
                emailController.clear();
                passwordController.clear();
              }
            },
            title: 'Sign Up',
            pad: 0.0,
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
          const SizedBox(height: 70),
        ],
      ),
    );
  }

/* -------------------------- Sign Up Page Members ------------------------- */
  Future _signUp(
    BuildContext context,
    String fullname,
    String email,
    String password,
    String address,
  ) async {
    final controller = Get.find<AuthRepoController>();
    final color = Theme.of(context).colorScheme;
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

    await controller.createUser(
      fullName: fullname,
      address: address,
      email: email,
      password: password,

    );

    if (controller.createdUser.isNotEmpty) {
      clearControllers();
      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      Navigator.pop(context);

      _instance.showSnackBar(
        context: context,
        message: controller.createdUserFailure[0].errorMessage,
      );
    }
  }

  void clearControllers() {
    emailController.clear();
    passwordController.clear();
    addressController.clear();
  }
}

final Snack _instance = Snack();
