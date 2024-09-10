import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/custom_filled_btn.dart';
import '../controller/authrepo_controller.dart';
import 'custom_textfields.dart';

final _ctrl = Get.find<AuthController>();

class SignupPage1 extends StatelessWidget {
  final TextEditingController phoneController = TextEditingController(
    text: _ctrl.phoneNumber,
  );
  final TextEditingController fullNameController = TextEditingController(
    text: _ctrl.fullName,
  );
  final TextEditingController addressController = TextEditingController(
    text: _ctrl.address,
  );
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SignupPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
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
          TelTextFormField(controller: phoneController),
          const SizedBox(height: 15),
          NormalTextFormField(
            controller: addressController,
            needsValidation: true,
            labelText: 'Shop Location',
            errorText: 'Please enter shop location',
            prefixIcon: const Icon(Icons.location_on_outlined),
          ),
          const SizedBox(height: 15),
          CustomFilledBtn(
            onPressed: () async {
              FocusScope.of(context).unfocus();
              final form = _formKey.currentState!;

              if (form.validate()) {
                final String fullName = fullNameController.text.trim();
                final String phoneNumber = phoneController.text.trim();
                final String address = addressController.text.trim();

                _ctrl.saveDataPage1(
                  fullName: fullName,
                  address: address,
                  phoneNumber: phoneNumber,
                );

                _ctrl.switchPage(1);
              }
            },
            title: 'Next',
            pad: 0.0,
          ),
        ],
      ),
    );
  }
}
