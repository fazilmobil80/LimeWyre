import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:limewyre/amplifyconfiguration.dart';
import 'package:limewyre/appModules/auth/auth_controller.dart';
import 'package:limewyre/utils/app_pages.dart';
import 'package:limewyre/utils/global_variables.dart';
import 'package:limewyre/utils/intent_share.dart';
import 'package:limewyre/utils/theme_controller.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('limewyreCache');
  Get.put(AuthController());
  Get.put(ThemeController());
  initShareListener();
  await _configureAmplify();
  runApp(const MyApp());
}

Future<void> _configureAmplify() async {
  final auth = AmplifyAuthCognito();
  final api = AmplifyAPI();
  final storage = AmplifyStorageS3();

  try {
    await Amplify.addPlugins([auth, api, storage]);
    await Amplify.configure(amplifyconfig);
    // log('Amplify configured ${response}');
    var authSession = await auth.fetchAuthSession();
    log('Amplify configured ${authSession.isSignedIn}');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSignedIn', authSession.isSignedIn);
  } on AmplifyAlreadyConfiguredException {
    log('Amplify already configured');
  } catch (e) {
    log('Amplify configuration error: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LimeWyre',
      theme: themeController.darkTheme,
      initialRoute: '/splash',
      getPages: AppPages().routes,
      builder: (context, child) {
        return child!;
      },
    );
  }
}
