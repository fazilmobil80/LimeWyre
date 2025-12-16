import 'package:get/get.dart';
import 'package:limewyre/appModules/auth/login_page.dart';
import 'package:limewyre/appModules/auth/splash_screen.dart';
import 'package:limewyre/appModules/home/navigations_page.dart';

class AppPages {
  final routes = [
    GetPage(name: '/splash', page: () => SplashScreen()),
    GetPage(name: '/auth', page: () => LoginPage()),
    GetPage(name: '/home', page: () => NavigationsPage()),
  ];
}
