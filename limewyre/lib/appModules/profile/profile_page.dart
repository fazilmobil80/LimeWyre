import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:limewyre/appModules/auth/auth_controller.dart';
// import 'package:limewyre/appModules/price/pricing_page.dart';
import 'package:limewyre/utils/custom_widgets.dart';
import 'package:limewyre/utils/global_variables.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = currentUser!;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Avatar
                  Container(
                    height: 90,
                    width: 90,
                    decoration: const BoxDecoration(
                      color: Color(0xff5A4FF3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),

                  const SizedBox(height: 16),
                  Text(
                    user.userEmailId,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),

                  // Free Plan
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Text(
                  //       user.userPaidSource == 'FREE'
                  //           ? 'Free plan'
                  //           : user.userPaidSource,
                  //       style: TextStyle(color: Colors.grey, fontSize: 14),
                  //     ),
                  //     SizedBox(width: 4),
                  //     Icon(Iconsax.crown1, size: 16, color: Colors.orange),
                  //   ],
                  // ),

                  // const SizedBox(height: 24),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  //     _buildStat(user.totalNotesCount.toString(), "Notes"),
                  //     _buildStat(
                  //       user.groupNotesCount.toString(),
                  //       "Group Notes",
                  //     ),
                  //     _buildStat(
                  //       DateTime.now()
                  //           .difference(
                  //             DateTime.fromMillisecondsSinceEpoch(
                  //               user.userCreatedOn,
                  //             ),
                  //           )
                  //           .inDays
                  //           .toString(),
                  //       "Days",
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _buildSettingTile(
              onTap: () async {
                String url = "https://www.privacyandpolicy.limewyre.com/";
                Uri uri = Uri.parse(url);
                await launchUrl(uri);
              },
              icon: Icons.lock_outline,
              title: "Privacy & Security",
            ),
            // _buildSettingTile(
            //   icon: Iconsax.crown1,
            //   title: "Subscription",
            //   onTap: () => Get.to(() => PricingPage()),
            // ),
            Obx(() {
              final auth = Get.find<AuthController>();
              return auth.deletingAccount.value
                  ? LoadingAnimationWidget.staggeredDotsWave(
                      color: Colors.grey,
                      size: 25,
                    )
                  : _buildSettingTile(
                      onTap: () async {
                        bool result = await CustomWidgets.customAlertBox(
                          title: 'Delete account?',
                          content:
                              'Are you sure you want to delete your account?',
                        );
                        if (result == true) {
                          auth.deleteAccount();
                        }
                      },
                      icon: Iconsax.profile_delete,
                      title: "Delete Account",
                      color: Colors.red,
                    );
            }),
            // Logout
            Obx(() {
              final auth = Get.find<AuthController>();
              return auth.isLoading.value
                  ? LoadingAnimationWidget.staggeredDotsWave(
                      color: Colors.grey,
                      size: 25,
                    )
                  : _buildSettingTile(
                      onTap: () async {
                        bool result = await CustomWidgets.customAlertBox(
                          title: 'Logout?',
                          content: 'Are you sure you want to logout?',
                        );
                        if (result == true) {
                          auth.logOut();
                        }
                      },
                      icon: Icons.logout,
                      title: "Logout",
                      color: Colors.red,
                    );
            }),
            const SizedBox(height: 10),
            Text(
              'Version: $appVersion',
              style: Get.textTheme.bodySmall!.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // static Widget _buildStat(String value, String label) {
  //   return Column(
  //     children: [
  //       Text(
  //         value,
  //         style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
  //       ),
  //       const SizedBox(height: 4),
  //       Text(label, style: const TextStyle(color: Colors.grey)),
  //     ],
  //   );
  // }

  static Widget _buildSettingTile({
    required IconData icon,
    required String title,
    Color? color,
    Function()? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: color ?? Colors.black),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: color ?? Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(Icons.arrow_right, size: 20, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
