import 'package:get/get.dart';

import '../../../../core/errors/failure_n_success.dart';
import '../../domain/entity/auth_user.dart';
import '../../domain/usecase/auth_usecase.dart';

class AuthRepoController extends GetxController {
  final AuthUC authUC;

  AuthRepoController(this.authUC);

  // user data
  var fullName = '';
  var email = '';
  var address = '';

  // current user
  AuthUser get currentUser => authUC.currentUser;

  // Stream user
  Stream<AuthUser> get user => authUC.user;

  // is loggin in
  var isLoggingIn = false.obs;
  var isSigningUp = false.obs;

  var isResettingPassword = false.obs;
  var isLoggingOut = false.obs;

  // log in
  var loggedInUser = <AuthUser>[].obs;
  var loggedInFailure = <Failure>[].obs;
  Future<void> logIn({required String email, required String password}) async {
    isLoggingIn.value = true;

    final userOrFailure = await authUC.logIn(
      email: email,
      password: password,
    );

    userOrFailure.fold(
      (failure) => loggedInFailure.add(failure),
      (user) async {
        loggedInUser.add(user);
      },
    );

    isLoggingIn.value = false;
  }

// create user
  var createdUser = <AuthUser>[].obs;
  var createdUserFailure = <Failure>[].obs;
  Future<void> createUser({
    required String fullName,
    required String address,
    required String email,
    required String password,
  }) async {
    isSigningUp.value = true;

    final userOrFailure = await authUC.createUser(
      fullName: fullName,
      address: address,
      email: email,
      password: password,
    );

    userOrFailure.fold(
      (failure) => createdUserFailure.add(failure),
      (user) async {
        createdUser.add(user);
        // await saveIsarUser(user, false);
      },
    );

    isSigningUp.value = false;
  }

  // send password reset link
  var resetLinkSent = false.obs;
  var resetLinkFailure = <Failure>[].obs;
  Future<void> sendPasswordResetLink({required String email}) async {
    isResettingPassword(false);

    final successOrFailure = await authUC.resetPassword(email: email);

    successOrFailure.fold(
      (failure) => resetLinkFailure.add(failure),
      (success) => resetLinkSent(true),
    );
  }

  // verify email
  var emailVerified = false.obs;
  var isVerifyingEmail = false.obs;
  var emailVerificationFailure = <Failure>[].obs;
  Future<void> verifyEmail() async {
    isVerifyingEmail.value = true;

    final successOrFailure = await authUC.verifyEmail();

    successOrFailure.fold(
      (failure) => emailVerificationFailure.add(failure),
      (success) => {},
    );

    isVerifyingEmail.value = false;
  }

  // sign out
  Future<void> signOut() async {
    final successOrFailure = await authUC.signOut();

    successOrFailure.fold(
      (failure) {
        // print('Failure: $failure');
      },
      (success) {
        isLoggingOut.value = false;
        // print('Success: ${success.successContent}');
      },
    );
  }

  deleteUser() {}

}
