import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:kaisa/core/widgets/custom_filled_btn.dart';

import '../../../../shared/shared_ctrl.dart';
import '../../../../theme/text_scheme.dart';
import '../../../authentication/domain/entity/auth_user.dart';
import '../../../authentication/presentation/controller/authrepo_controller.dart';

final _authCtrl = Get.find<AuthController>();

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;

    final userData = Get.find<SharedCtrl>().userData;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: bodyMedium(textTheme).copyWith(fontSize: 13),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const SizedBox(height: 20),
              Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 51.5,
                      backgroundColor: color.primary,
                      child: CircleAvatar(
                        backgroundColor: color.surface,
                        radius: 50,
                        child: CachedNetworkImage(
                          imageUrl: userData.imgUrl,
                          height: 80,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    leading: const SizedBox(
                      width: 50,
                      height: 50,
                      child: Icon(
                        Icons.person,
                        size: 30,
                      ),
                    ),
                    title: Text(
                      'Name',
                      style: bodyMedium(textTheme),
                    ),
                    subtitle: Text(
                      userData.fullName,
                      style: bodyRegular(textTheme),
                    ),
                  ),
                  ListTile(
                    leading: const SizedBox(
                      width: 50,
                      height: 50,
                      child: Icon(
                        Icons.email_rounded,
                        size: 30,
                      ),
                    ),
                    title: Text(
                      'Email',
                      style: bodyMedium(textTheme),
                    ),
                    subtitle: Text(
                      userData.email,
                      style: bodyRegular(textTheme),
                    ),
                  ),
                  ListTile(
                    leading: const SizedBox(
                      width: 50,
                      height: 50,
                      child: Icon(
                        Icons.location_pin,
                        size: 30,
                      ),
                    ),
                    title: Text(
                      'Shop Location',
                      style: bodyMedium(textTheme),
                    ),
                    subtitle: Text(
                      userData.shop,
                      style: bodyRegular(textTheme),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),

          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CustomFilledBtn(
                  title: 'Sign Out',
                  onPressed: () => signOut(context),
                  pad: 0,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: FilledButton(
                  onPressed: () => _deleteAccount(context),
                  style: FilledButton.styleFrom(
                    backgroundColor: color.error,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    minimumSize: const Size.fromHeight(50),
                    textStyle: textTheme.labelMedium,
                  ),
                  child: const Text(
                    'Delete Account',
                  ),
                ),
              )
            ],
          )

          // delete account button
        ],
      ),
    );
  }

  Future<void> signOut(BuildContext context) async {
    await _authCtrl.signOut();

    if (_authCtrl.currentUser == AuthUser.empty) {
      // ignore: use_build_context_synchronously
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  void _deleteAccount(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text('Are you sure you want to delete your account?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _authCtrl.deleteAccount();

                if (_authCtrl.currentUser == AuthUser.empty) {
                  // ignore: use_build_context_synchronously
                  Navigator.popUntil(context, (route) => route.isFirst);
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
