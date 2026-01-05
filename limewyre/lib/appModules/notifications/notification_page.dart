import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:limewyre/appModules/notifications/notification_controller.dart';
import 'package:limewyre/utils/const_page.dart';

class NotificationsPage extends StatelessWidget {
  final NotificationController controller = Get.isRegistered()
      ? Get.find<NotificationController>()
      : Get.put(NotificationController());
  NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        // actions: [
        //   TextButton(
        //     onPressed: () {},
        //     child: const Text(
        //       "Mark all read",
        //       style: TextStyle(
        //         color: Color(0xff5A4FF3),
        //         fontSize: 14,
        //         fontWeight: FontWeight.w500,
        //       ),
        //     ),
        //   ),
        // ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: controller.newNotifications.isEmpty
            ? Center(
                child: Text(
                  "No new notifications",
                  style: Get.textTheme.bodyMedium!.copyWith(
                    color: Colors.grey.shade500,
                  ),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "New (${controller.newNotifications.length})",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.newNotifications.length,
                      itemBuilder: (context, index) {
                        return _notificationTile(
                          controller.newNotifications[index],
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _notificationTile(Map<String, dynamic> notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: notification['isRead'] ? Colors.grey.shade200 : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xffE2E6ED)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ICON
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: notification['iconBg'].withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              notification['icon'],
              size: 22,
              color: notification['iconBg'],
            ),
          ),

          const SizedBox(width: 12),

          // TEXTS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        notification['title'],
                        style: Get.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (notification['isRead'] == false)
                      Icon(
                        Icons.circle,
                        color: ColorConst.primaryColor,
                        size: 10,
                      ),
                  ],
                ),

                const SizedBox(height: 4),

                // Message
                Text(notification['message'], style: Get.textTheme.bodySmall),

                const SizedBox(height: 8),

                // Time
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      notification['time'],
                      style: Get.textTheme.bodySmall!.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
