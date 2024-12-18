import 'package:get/get.dart';
import 'package:kaisa/core/datasources/firestore/models/kaisa-user/kaisa_user.dart';

import '../../../../core/errors/failure_n_success.dart';
import '../../domain/entity/auth_user.dart';
import '../../domain/usecase/auth_usecase.dart';

class AuthController extends GetxController {
  final AuthUC authUC;

  AuthController(this.authUC);

  // user data
  var fullName = '';
  var email = '';
  var address = ''.obs;
  var phoneNumber = '';
  var password = '';
  var code = 0;

  // switch between pages
  var pageIndex = 0.obs;
  void switchPage(int newPage) {
    pageIndex.value = newPage;
  }

  // temporarily save user data
  void saveDataPage1({
    required String fullName,
    required String address,
    required String phoneNumber,
  }) {
    this.fullName = fullName;
    this.address.value = address;
    this.phoneNumber = phoneNumber;
  }

  void saveDataPage2({
    required String email,
    required int code,
    required String password,
  }) {
    this.email = email;
    this.code = code;
    this.password = password;
  }

  void cleanUp() {
    fullName = '';
    email = '';
    address.value = '';
    phoneNumber = '';
    password = '';
    code = 0;
    pageIndex.value = 0;
  }

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
  Failure? loggedInFailure;
  Future<void> logIn({required String email, required String password}) async {
    isLoggingIn.value = true;

    final userOrFailure = await authUC.logIn(
      email: email,
      password: password,
    );

    userOrFailure.fold(
      (failure) => loggedInFailure = failure,
      (user) async {
        loggedInUser.add(user);
      },
    );

    isLoggingIn.value = false;
  }

// create user
  var createdUser = <AuthUser>[].obs;
  var createdUserFailure = <Failure>[].obs;
  Future<void> createUser() async {
    isSigningUp.value = true;

    final userOrFailure = await authUC.createUser(
      fullName: fullName,
      address: address.value,
      phoneNumber: phoneNumber,
      email: email,
      password: password,
    );

    userOrFailure.fold(
      (failure) => createdUserFailure.add(failure),
      (user) => createdUser.add(user),
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

  var isQualified = false.obs;
  var isCheckingQualification = false.obs;
  var qualificationCheckFailure = <Failure>[].obs;
  //  check if number qualify for registration
  Future<void> checkQualification() async {
    isCheckingQualification.value = true;
    final successOrFailure = await authUC.checkQualification(code);

    successOrFailure.fold(
      (failure) => qualificationCheckFailure.add(failure),
      (success) => isQualified.value = success,
    );

    isCheckingQualification.value = false;
  }

  //  user stream
  Stream<KaisaUser> userStream({required String userId}) {
    return authUC.userStream(userId: userId);
  }

  // delete account
  var accountDeleted = false.obs;
  var isDeletingAccount = false.obs;
  var accountDeletionFailure = <Failure>[].obs;
  Future<void> deleteAccount() async {
    isDeletingAccount.value = true;

    final successOrFailure = await authUC.deleteAccount();

    successOrFailure.fold(
      (failure) => accountDeletionFailure.add(failure),
      (success) => accountDeleted(true),
    );

    isDeletingAccount.value = false;
  }
}
