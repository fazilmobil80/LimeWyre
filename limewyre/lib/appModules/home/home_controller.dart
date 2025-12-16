import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:limewyre/appModules/ai/ask_ai_page.dart';
import 'package:limewyre/appModules/group/groups_page.dart';
import 'package:limewyre/appModules/notes/personal_notes.dart';
import 'package:limewyre/appModules/profile/profile_page.dart';
import 'package:limewyre/utils/const_page.dart';

class HomeController extends GetxController {
  RxInt selectedIndex = 0.obs;

  RxList homePages = [
    {
      'label': 'Add',
      'title': 'Add a personal note',
      'icon': Icons.add,
      'page': PersonalNotes(),
    },
    {
      'label': 'Ask',
      'title': 'Ask from your notes',
      'icon': Icons.auto_awesome,
      'page': AskAiPage(),
    },
    {
      'label': 'Groups',
      'title': 'Your Groups',
      'icon': Icons.group_outlined,
      'page': GroupsPage(),
      'color': ColorConst.groupPrimary,
    },
    {
      'label': 'Profile',
      'title': 'Profile',
      'icon': Icons.person,
      'page': ProfilePage(),
    },
  ].obs;
}
