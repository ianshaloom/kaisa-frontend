import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kaisa/core/constants/image_path_const.dart';
import 'package:kaisa/core/datasources/firestore/models/kaisa-user/kaisa_user.dart';
import 'package:kaisa/theme/text_scheme.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../authentication/domain/entity/auth_user.dart';
import '../../authentication/presentation/controller/authrepo_controller.dart';
import '../../authentication/presentation/views/landingpage.dart';
import '../../authentication/presentation/views/verify_email_page.dart';
import '../../homepage/presentation/views/homepage.dart';
import '../../../shared/shared_ctrl.dart';

class Zleton extends StatelessWidget {
  const Zleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final controller = Get.find<AuthController>();

    return Obx(
      () => controller.emailVerified.value
          ? StreamBuilder(
              stream: controller.user,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  final user = snapshot.data;
                  final isUserEmpty = user != AuthUser.empty;
                  final isEmailVerified = user!.isEmailVerified;

                  if (isUserEmpty) {
                    if (isEmailVerified) {
                      return HomeWrapper(
                        userId: user.id,
                      );
                    } else {
                      return const VerifyEmailPage();
                    }
                  } else {
                    return const LandingPage();
                  }
                } else {
                  return Scaffold(
                    body: Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        size: 50,
                        color: color.primary,
                      ),
                    ),
                  );
                }
              },
            )
          : StreamBuilder(
              stream: controller.user,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  final user = snapshot.data;
                  final isUserEmpty = user != AuthUser.empty;
                  final isEmailVerified = user!.isEmailVerified;

                  if (isUserEmpty) {
                    if (isEmailVerified) {
                      return HomeWrapper(
                        userId: user.id,
                      );
                    } else {
                      return const VerifyEmailPage();
                    }
                  } else {
                    return const LandingPage();
                  }
                } else {
                  return Scaffold(
                    body: Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        size: 50,
                        color: color.primary,
                      ),
                    ),
                  );
                }
              },
            ),
    );
  }
}

class HomeWrapper extends StatelessWidget {
  final String userId;
  const HomeWrapper({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final controller = Get.find<AuthController>();
    final shCtrl = Get.find<SharedCtrl>();

    return StreamBuilder(
      stream: controller.userStream(userId: userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data!;
          final isUserEmpty = user != KaisaUser.empty;

          if (isUserEmpty) {
            // assign user data to shared controller
            shCtrl.userData = user;

            if (user.active) {
              return const HomePage();
            }

            return Scaffold(
              appBar: AppBar(toolbarHeight: 0),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Oops! Your account was deactivated.\nPlease contact support.',
                      textAlign: TextAlign.center,
                      style: bodyRegular(textTheme),
                    ),
                    const SizedBox(height: 30),
                    _launcherButtons(context),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Expanded(
                            child: Divider(),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              'or',
                              style: bodyMedium(textTheme),
                            ),
                          ),
                          const Expanded(
                            child: Divider(),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
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
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(toolbarHeight: 0),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Oops! Looks like you are not registered.\nPlease contact support.',
                      textAlign: TextAlign.center,
                      style: bodyRegular(textTheme),
                    ),
                    const SizedBox(height: 30),
                    _launcherButtons(context),
                  ],
                ),
              ),
            );
          }
        }

        return Scaffold(
          appBar: AppBar(toolbarHeight: 0),
          body: Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              size: 50,
              color: color.primary,
            ),
          ),
        );
      },
    );
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Widget _launcherButtons(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            IconButton(
              onPressed: () {
                _makePhoneCall('0759596626');
              },
              icon: SvgPicture.asset(
                phone,
                height: 30,
                colorFilter: ColorFilter.mode(
                  color.primary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Call',
              style: bodyRegular(textTheme),
            ),
          ],
        ),
        const SizedBox(width: 20),
        Column(
          children: [
            IconButton(
              onPressed: () {
                _launchInBrowser(Uri.parse('https://wa.me/+254759596626'));
              },
              icon: SvgPicture.asset(
                whatsapp,
                height: 30,
                colorFilter: const ColorFilter.mode(
                  Color.fromARGB(255, 0, 138, 5),
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'WhatsApp',
              style: bodyRegular(textTheme),
            ),
          ],
        ),
      ],
    );
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
                final controller = Get.find<AuthController>();
                await controller.deleteAccount();

                if (controller.currentUser == AuthUser.empty) {
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
