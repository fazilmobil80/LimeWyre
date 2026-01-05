import 'dart:developer';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:limewyre/models/user_model.dart';
import 'package:limewyre/services/api_mutations.dart';
import 'package:limewyre/services/api_queries.dart';
import 'package:limewyre/utils/global_variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final box = Hive.box('limewyreCache');
  RxString authStatus = AuthStatus.initial.obs;
  RxBool isLoading = false.obs;
  RxString authError = ''.obs;

  Future checkAuth() async {
    // logOut();
    isLoading.value = true;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isSignedIn = prefs.getBool('isSignedIn') ?? false;
      if (isSignedIn) {
        currentUserId = prefs.getString('userId') ?? '';
        currentUserEmail = prefs.getString('userEmail') ?? '';
        await getCurrentUser(email: currentUserEmail);
        Get.offAllNamed('/home');
      } else {
        logOut();
        Get.offAllNamed('/auth');
      }
    } catch (e) {
      logOut();
      log('Error in checkAuth :$e');
    } finally {
      isLoading.value = false;
    }
  }

  Future getCurrentUser({required String email}) async {
    try {
      final data = await ApiQueries().getApiQueries(
        request: ApiQueries.getCurrentUser,
        input: {'user_email_id': email},
        label: 'GetCurrentUserDetails',
      );
      final UserResponse userdata = UserResponse.fromJson(data);
      currentUser = userdata.data.items.first;
      currentUserId = currentUser!.userId;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userId', currentUser!.userId);
      // log('user == ${currentUser!.toJson()}');
    } catch (e) {
      log('Error getting user details :$e');
    }
  }

  Future<void> startSignIn({required String email}) async {
    isLoading.value = true;
    authError.value = '';
    try {
      final result = await Amplify.Auth.signIn(
        username: email,
        options: SignInOptions(
          pluginOptions: CognitoSignInPluginOptions(
            authFlowType: AuthenticationFlowType.customAuthWithoutSrp,
          ),
        ),
      );
      _handleNextStep(result, email);
    } on UserNotFoundException {
      await signUpAndStart(email);
    } on AuthException catch (e) {
      log("startSignIn error → $e");
      if (e.toString().contains('Error: NOT_AUTHORIZED : Kindly Sigup')) {
        await signUpAndStart(email);
      } else {
        authError.value = e.message;
        Fluttertoast.showToast(
          msg: e.recoverySuggestion ?? 'Sign In Error',
          backgroundColor: Colors.red,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// STEP 2: Auto Sign Up → then Start Sign In
  Future<void> signUpAndStart(String email) async {
    try {
      await Amplify.Auth.signUp(
        username: email,
        password: "Limwwyre@061628",
        options: SignUpOptions(
          userAttributes: {AuthUserAttributeKey.email: email},
        ),
      );

      // After signup, start sign-in automatically
      await startSignIn(email: email);
    } catch (e) {
      log("signUp error → $e");
    }
  }

  Future<void> verifyOtp({required String otp, required String email}) async {
    if (otp.isEmpty) {
      authError.value = 'Enter OTP';
      return;
    }
    isLoading.value = true;
    try {
      final result = await Amplify.Auth.confirmSignIn(confirmationValue: otp);
      _handleNextStep(result, email);
    } on AuthException catch (e) {
      log("verifyOtp error: $e");
      authError.value = e.message;
      isLoading.value = false;
    }
  }

  /// Handles Cognito SignIn next states
  void _handleNextStep(SignInResult result, String email) async {
    final step = result.nextStep.signInStep;
    if (step == AuthSignInStep.confirmSignInWithCustomChallenge) {
      authStatus.value = AuthStatus.otp;
    } else if (step == AuthSignInStep.done) {
      await getCurrentUser(email: email);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      currentUserEmail = email;
      prefs.setString('userEmail', email);
      isLoading.value = false;
      Get.offAllNamed('/home');
    } else {
      isLoading.value = false;
      log('Unhandled signInStep → $step');
    }
  }

  Future<void> logOut() async {
    isLoading.value = true;
    await Amplify.Auth.signOut();
    currentUserEmail = '';
    currentUserId = '';
    currentUser = null;
    box.clear();
    authStatus.value = AuthStatus.initial;
    Get.offAllNamed("/auth");
    isLoading.value = false;
  }

  RxBool deletingAccount = false.obs;
  Future deleteAccount() async {
    deletingAccount.value = true;
    try {
      var data = await ApiMutations().apiMutations(
        request: ApiMutations.deleteMyAccount,
        input: {},
      );
      if (data == 'SUCCESS') {
        Get.find<AuthController>().logOut();
        Fluttertoast.showToast(msg: 'Account deleted successfully!');
      } else {
        Fluttertoast.showToast(msg: '$data', backgroundColor: Colors.red);
      }
    } catch (e) {
      log('Error deleting account: $e');
    } finally {
      deletingAccount.value = false;
    }
  }
}

class AuthStatus {
  static const initial = 'INITIAL';
  static const otp = 'OTP';
}
