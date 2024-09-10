// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../core/widgets/custom_outllined_btn.dart';
import '../../../../../core/widgets/snacks.dart';
import '../../../../../core/widgets/custom_filled_btn.dart';
import '../../../../../theme/text_scheme.dart';
import '../controller/authrepo_controller.dart';

// SECTION: Verify Email Page
/* -------------------------------------------------------------------------- */
class VerifyEmailPage extends StatelessWidget {
  const VerifyEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: const Text('Check Your Mail'),
            centerTitle: true,
            titleTextStyle: textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 25,
            ),
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 20,
              ),
            ),
            bottom: PreferredSize(
              preferredSize:
                  const Size.fromHeight(75.0), // Set your desired height
              child: Container(
                margin: const EdgeInsets.only(left: 16, right: 5),
                alignment: Alignment.centerLeft,
                child: Text(
                  'We,ve sent a verification email to verify your email address.'
                  'You might wanna check your spam if you cant find it.',
                  style: bodyMedium(textTheme).copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.03),
            sliver: SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                child: const CountdownTimer(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Component: Counter Timer Text Widget
class CountdownTimer extends StatefulWidget {
  const CountdownTimer({super.key});

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  final controller = Get.find<AuthController>();

  int _secondsRemaining = 59;
  late Timer _timer1;
  late Timer _timer2;
  bool _isTimerActive = true;
  bool _isEmailVerified = false;

  @override
  void initState() {
    super.initState();
    startCountdown();
    if (!_isEmailVerified) {
      _timer2 = Timer.periodic(const Duration(seconds: 3), (timer) {
        _checkEmailVerification();
      });
    }
  }

  @override
  void dispose() {
    _timer1.cancel();
    _timer2.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = DateFormat('mm : ss').format(
      DateTime(0, 0, 0, 0, 0, _secondsRemaining),
    );
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Container(
          height: 180,
          alignment: Alignment.center,
          child: Text(
            formattedTime,
            style: textTheme.titleLarge!.copyWith(
              fontSize: 32,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        CustomFilledBtn(
          onPressed: _isTimerActive
              ? () {}
              : () {
                  setState(() {
                    _secondsRemaining = 59;
                    _isTimerActive = true;
                  });
                  startCountdown();
                },
          title: 'Resend verification email',
          pad: 0,
        ),
        const SizedBox(height: 27),
        CustomOutlinedBtn(
          onPressed: () async {
            final c = Get.find<AuthController>();
            await c.signOut();
          },
          title: 'Cancel',
          pad: 0,
        ),
      ],
    );
  }

  void startCountdown() async {
    // send email verification
    await sendEmail();

    // start countdown
    _timer1 = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer1.cancel();
          _isTimerActive = false;
        }
      });
    });
  }

  Future _checkEmailVerification() async {
    final user = controller.currentUser;
    if (user.isEmailVerified) {
      _isEmailVerified = true;
      _cleanUp();
      controller.emailVerified(true);
    }
  }

  Future sendEmail() async {
    await controller.verifyEmail();

    if (controller.emailVerificationFailure.isNotEmpty) {
      _cleanUp();
      _errorSnack(controller.emailVerificationFailure[0].errorMessage);
    }
  }

  void _errorSnack(String message) {
    Snack().showSnackBar(context: context, message: message);
  }

  void _cleanUp() {
    _timer1.cancel();
    _timer2.cancel();
  }
}
