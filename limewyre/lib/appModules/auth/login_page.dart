import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:limewyre/appModules/auth/auth_controller.dart';
import 'package:limewyre/utils/const_page.dart';
import 'package:limewyre/utils/global_variables.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class LoginPage extends StatelessWidget {
  final emailController = TextEditingController();
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: ColorConst.primaryColor,
      body: SingleChildScrollView(
        child: SizedBox(
          height: h,
          width: w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: Colors.white12),
                      image: DecorationImage(
                        image: AssetImage('assets/logo.png'),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    "LimeWyre",
                    style: const TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Your smart memory companion",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              Obx(() {
                final formkey = GlobalKey<FormState>();
                return Container(
                  width: w * 0.9,
                  padding: const EdgeInsets.symmetric(
                    vertical: 25,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    border: Border.all(color: Colors.white24),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Email Address",
                        style: Get.textTheme.bodyMedium!.copyWith(
                          // fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),

                      Form(
                        key: formkey,
                        child: TextFormField(
                          readOnly:
                              controller.authStatus.value == AuthStatus.otp,
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: Colors.white,
                          style: Get.textTheme.bodyMedium!.copyWith(
                            color: Colors.white,
                          ),
                          onTapOutside: (event) =>
                              FocusManager.instance.primaryFocus!.unfocus(),
                          decoration: InputDecoration(
                            fillColor: Colors.white.withValues(alpha: 0.1),
                            filled: true,
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              color: Colors.white54,
                            ),
                            suffixIcon: Obx(() {
                              if (controller.authStatus.value ==
                                  AuthStatus.initial) {
                                return SizedBox.shrink();
                              }
                              return TextButton(
                                onPressed: () {
                                  controller.authStatus.value =
                                      AuthStatus.initial;
                                },
                                child: Text('Edit'),
                              );
                            }),
                            labelText: "Enter your email",
                            labelStyle: Get.textTheme.bodySmall!.copyWith(
                              color: Colors.white54,
                              fontWeight: FontWeight.bold,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white.withValues(alpha: 0.3),
                              ),
                              borderRadius: BorderRadius.circular(w * 0.03),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(w * 0.03),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(w * 0.03),
                              borderSide: BorderSide(
                                color: Get.theme.primaryColor,
                              ),
                            ),
                          ),
                          // onChanged: (value) {
                          //   controller.authStatus.value = AuthStatus.initial;
                          // },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (!RegExp(
                              r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
                            ).hasMatch(value!)) {
                              return "Please enter a valid Email ID";
                            }
                            return null;
                          },
                        ),
                      ),

                      const SizedBox(height: 20),
                      if (controller.authStatus.value == AuthStatus.otp)
                        OtpWidget(
                          controller: controller,
                          email: emailController.text.trim().toLowerCase(),
                        ),
                      Obx(
                        () => ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorConst.primaryColor,
                            foregroundColor: ColorConst.backgroundColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            fixedSize: Size.fromWidth(w),
                          ),
                          onPressed: () {
                            if (!formkey.currentState!.validate()) {
                              return;
                            }
                            if (controller.authStatus.value ==
                                AuthStatus.initial) {
                              controller.startSignIn(
                                email: emailController.text
                                    .trim()
                                    .toLowerCase(),
                              );
                            } else {
                              // controller.verifyOtp(
                              //   otp: otpController.text.trim(),
                              //   email: emailController.text
                              //       .trim()
                              //       .toLowerCase(),
                              // );
                            }
                          },
                          child: controller.isLoading.value
                              ? LoadingAnimationWidget.staggeredDotsWave(
                                  color: Colors.white,
                                  size: 20,
                                )
                              : Text(
                                  controller.authStatus.value == AuthStatus.otp
                                      ? "Get started"
                                      : "Send OTP",
                                ),
                        ),
                      ),

                      Obx(() {
                        if (controller.authError.value.isEmpty) {
                          return const SizedBox(height: 20);
                        }
                        return Padding(
                          padding: const EdgeInsets.all(12),
                          child: Center(
                            child: Text(
                              controller.authError.value,
                              textAlign: TextAlign.center,
                              style: Get.textTheme.bodySmall!.copyWith(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        );
                      }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lock_outline,
                            size: 16,
                            color: Colors.white54,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Your notes are private",
                            style: Get.textTheme.bodySmall!.copyWith(
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class OtpWidget extends StatelessWidget {
  final otpController = TextEditingController();
  final focusNode = FocusNode();
  final AuthController controller;
  final String email;
  OtpWidget({super.key, required this.controller, required this.email});

  @override
  Widget build(BuildContext context) {
    focusNode.requestFocus();
    print(focusNode.canRequestFocus);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Enter OTP",
          style: Get.textTheme.bodyMedium!.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 60,
          child: PinCodeTextField(
            backgroundColor: Colors.transparent,
            focusNode: focusNode,
            enablePinAutofill: true,
            appContext: context,
            length: 6,
            animationType: AnimationType.fade,
            textStyle: Get.textTheme.bodyMedium!.copyWith(color: Colors.white),
            pinTheme: PinTheme(
              inactiveBorderWidth: 1,
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(3),
              fieldHeight: 40,
              fieldWidth: 40,
              selectedColor: ColorConst.primaryColor,
              activeColor: ColorConst.primaryColor,
              activeBorderWidth: 1,
              inactiveColor: Colors.white.withValues(alpha: 0.3),
            ),
            controller: otpController,
            keyboardType: TextInputType.number,
            onCompleted: (v) {
              FocusManager.instance.primaryFocus!.unfocus();
              controller.verifyOtp(
                otp: otpController.text.trim(),
                email: email,
              );
            },
            beforeTextPaste: (text) => true,
          ),
        ),
      ],
    );
  }
}
