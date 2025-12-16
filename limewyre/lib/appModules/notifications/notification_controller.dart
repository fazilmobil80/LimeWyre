import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:limewyre/utils/const_page.dart';

class NotificationController extends GetxController {
  List newNotifications = [
    {
      'icon': Icons.done_all,
      'iconBg': ColorConst.primaryColor,
      'title': "Note Saved",
      'message':
          'Your note "Bangalore trip ideas" has been saved successfully.',
      'time': "2 min ago",
      'isRead': false,
    },
    {
      'icon': Icons.person,
      'iconBg': ColorConst.groupPrimary,
      'title': "New Group Member",
      'message': 'Rhea joined "Product Team" group.',
      'time': "1 hour ago",
      'isRead': false,
    },
    {
      'icon': Iconsax.crown1,
      'iconBg': Colors.amber,
      'title': "Upgrade to Pro",
      'message': 'Get unlimited notes and AI queries. Limited time offer!',
      'time': "3 hours ago",
      'isRead': false,
    },
    {
      'icon': Icons.auto_awesome,
      'iconBg': ColorConst.secondaryColor,
      'title': "AI Response Ready",
      'message':
          'Your question "What are my startup ideas?" has been answered.',
      'time': "5 hours ago",
      'isRead': true,
    },
    {
      'icon': Icons.person,
      'iconBg': ColorConst.groupPrimary,
      'title': "Group Note Added",
      'message': 'New note added to "Weekend Travelers" group.',
      'time': "1 day ago",
      'isRead': true,
    },
  ];
}
