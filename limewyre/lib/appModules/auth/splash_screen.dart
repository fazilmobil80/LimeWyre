import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:limewyre/appModules/auth/auth_controller.dart';
import 'package:limewyre/utils/const_page.dart';
import 'package:limewyre/utils/global_variables.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashScreen extends StatelessWidget {
  final AuthController controller = Get.find<AuthController>();
  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () async {
      controller.checkAuth();
    });
    return Scaffold(
      backgroundColor: ColorConst.primaryColor,
      body: SizedBox(
        height: h,
        width: w,
        child: Stack(
          children: [
            Positioned(
              top: 1,
              bottom: 1,
              right: 1,
              left: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white12),
                      borderRadius: BorderRadius.circular(25),
                      image: DecorationImage(
                        image: AssetImage('assets/logo.png'),
                      ),
                    ),
                    // child:
                    // Image(
                    //   image:AssetImage('assets/logo.png'),
                    //   width: 100,
                    // ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'LimeWyre',
                    style: Get.textTheme.titleLarge!.copyWith(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  // const SizedBox(height: 30),

                  // Text(
                  //   'Your smart memory companion',
                  //   style: Get.textTheme.titleLarge!.copyWith(
                  //     fontSize: 15,
                  //     color: Colors.grey.shade800,
                  //   ),
                  // ),
                ],
              ),
            ),
            Positioned(
              bottom: h * 0.2,
              left: 1,
              right: 1,
              child: Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
