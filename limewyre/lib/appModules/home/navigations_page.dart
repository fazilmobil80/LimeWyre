import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:limewyre/appModules/home/home_controller.dart';
import 'package:limewyre/appModules/notifications/notification_page.dart';
import 'package:limewyre/utils/const_page.dart';

class NavigationsPage extends StatelessWidget {
  final HomeController controller = Get.isRegistered()
      ? Get.find<HomeController>()
      : Get.put(HomeController());
  NavigationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.black,
        elevation: 1,
        title: Obx(
          () => Text(
            controller.homePages[controller.selectedIndex.value]['title'],
          ),
        ),
        actions: [
          // InkWell(
          //   onTap: () => Get.to(() => PricingPage()),
          //   child: Container(
          //     padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          //     margin: EdgeInsets.symmetric(vertical: 10),
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(8),
          //       color: Colors.amber,
          //     ),
          //     child: Row(
          //       children: [
          //         Icon(Iconsax.crown1, size: 15, color: Colors.white),
          //         const SizedBox(width: 5),
          //         Text(
          //           'Upgrade',
          //           style: Get.textTheme.bodyMedium!.copyWith(
          //             color: Colors.white,
          //             fontWeight: FontWeight.bold,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          IconButton(
            onPressed: () => Get.to(() => NotificationsPage()),
            // onPressed: () async {
            //   await controller.createCustomNotes();
            // },
            icon: Icon(Icons.notifications_rounded),
          ),
        ],
      ),
      body: Obx(() {
        return controller.homePages[controller.selectedIndex.value]['page'];
      }),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(controller.homePages.length, (index) {
              final item = controller.homePages[index];
              return _buildNavItem(item['icon'], item['label'], index);
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = controller.selectedIndex.value == index;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          HapticFeedback.lightImpact();
          controller.selectedIndex.value = index;
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected
                  ? controller.homePages[index]['color'] ??
                        ColorConst.primaryColor
                  : Colors.grey,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected
                    ? controller.homePages[index]['color'] ??
                          ColorConst.primaryColor
                    : Colors.grey,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
