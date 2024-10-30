import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kaisa/core/constants/image_path_const.dart';

import '../../../../core/widgets/custom_filled_btn.dart';
import '../../../../core/widgets/snacks.dart';
import '../../../../theme/text_scheme.dart';
import '../controller/authrepo_controller.dart';
import '../views/mbs_shoplist.dart';
import 'custom_textfields.dart';

final _ctrl = Get.find<AuthController>();

class SignupPage1 extends StatelessWidget {
  final TextEditingController phoneController = TextEditingController(
    text: _ctrl.phoneNumber,
  );
  final TextEditingController fullNameController = TextEditingController(
    text: _ctrl.fullName,
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
          const ShopSelection(),
          const SizedBox(height: 15),
          CustomFilledBtn(
            onPressed: () async {
              FocusScope.of(context).unfocus();
              final form = _formKey.currentState!;

              if (_ctrl.address.isEmpty) {
                Snack().showSnackBar(
                    context: context, message: 'Please select a shop');

                return;
              }

              if (form.validate()) {
                final String fullName = fullNameController.text.trim();
                final String phoneNumber = phoneController.text.trim();
                final String address = _ctrl.address.value;

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

// Component: Normal Text Form Field
class ShopSelection extends StatelessWidget {
  const ShopSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => shopSelection(context),
      child: Container(
        alignment: Alignment.centerLeft,
        color: Colors.transparent,
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(
              location,
              colorFilter: ColorFilter.mode(
                color.primary,
                BlendMode.srcIn,
              ),
              height: 45,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Kaisa Shop',
                  style: bodyMedium(textTheme).copyWith(fontSize: 13),
                ),
                const SizedBox(height: 4),
                Obx(
                  () => _ctrl.address.value.isEmpty
                      ? Text(
                          "Choose a Shop",
                          style: bodyMedium(textTheme).copyWith(
                            color: color.onSurface.withOpacity(0.5),
                          ),
                        )
                      : Text(
                          _ctrl.address.value,
                          style: bodyMedium(textTheme).copyWith(
                            color: color.onSurface,
                          ),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> shopSelection(BuildContext context) async {
    // show full screen dialog
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (context) {
        return const MbsShopList();
      },
    );
  }
}
