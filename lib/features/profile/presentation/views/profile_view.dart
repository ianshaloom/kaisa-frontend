import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kaisa/core/widgets/custom_filled_btn.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../core/constants/network_const.dart';
import '../../../../core/datasources/firestore/crud/kaisa_users_ds.dart';
import '../../../../core/datasources/hive/hive-crud/hive_user_crud.dart';
import '../../../../core/datasources/hive/hive_init.dart';
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

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Spacer(),
            IconButton(
              icon: const Icon(CupertinoIcons.refresh_thin),
              onPressed: () {
                refreshingProfile(context);
              },
            ),
          ],
        ),
        Column(
          children: [
            const SizedBox(height: 20),
            ValueListenableBuilder(
              valueListenable: HiveBoxes.getUserDataBox.listenable(),
              builder: (context, box, child) {
                if (box.isEmpty) {
                  return Center(
                    child: LoadingAnimationWidget.fourRotatingDots(
                      color: Colors.black,
                      size: 50,
                    ),
                  );
                }

                final userData = box.values.first;
                return Column(
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
                            imageUrl: userData.profileImgUrl,
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
                        userData.address,
                        style: bodyRegular(textTheme),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 30),
            Column(
              children: [
                // const Divider(),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Choose profile avatar',
                    style: bodyMedium(textTheme).copyWith(fontSize: 12.5),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...profilePictures.map((avatar) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: GestureDetector(
                          onTap: () async {
                            var userData = await HiveUserDataCrud().getUser();
                            userData.profileImgUrl = avatar;
                            userData.save();
                          },
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(avatar, scale: 1),
                            backgroundColor:
                                Theme.of(context).colorScheme.surface,
                            radius: 30,
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ],
            ),
          ],
        ),

        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: CustomFilledBtn(
                title: 'Sign Out',
                onPressed: () => signOut(context),
                pad: 0,
              ),
            ),
          ],
        )

        // delete account button
      ],
    );
  }

  Future<void> refreshingProfile(BuildContext context) async {
    final color = Theme.of(context).colorScheme;
    showDialog(
      barrierColor: color.primary.withOpacity(0.2),
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: LoadingAnimationWidget.fourRotatingDots(
          color: color.primary,
          size: 50,
        ),
      ),
    );

    final userData =
        await FirestoreUsersDs.fetchUser(userId: _authCtrl.currentUser.id);
    var localUserData = await HiveUserDataCrud().getUser();

    // update local user data
    localUserData.address = userData.address;
    localUserData.email = userData.email;
    localUserData.fullName = userData.fullName;
    localUserData.phoneNumber = userData.phoneNumber;

    localUserData.save();

    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }

  Future<void> signOut(BuildContext context) async {
    await _authCtrl.signOut();

    if (_authCtrl.currentUser == AuthUser.empty) {
      // ignore: use_build_context_synchronously
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }
}
