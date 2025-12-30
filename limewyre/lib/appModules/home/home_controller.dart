import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:limewyre/appModules/ai/ask_ai_page.dart';
import 'package:limewyre/appModules/group/groups_page.dart';
import 'package:limewyre/appModules/notes/personal_notes.dart';
import 'package:limewyre/appModules/profile/profile_page.dart';
import 'package:limewyre/services/api_service.dart';
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
      'title': 'Query from your notes',
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

  Future<void> createCustomNotes() async {
    final List<String> sampleNotes = [
      "Test offline note creation and sync behavior.",
      "Discussion: Should Ask AI prioritize recent notes over older ones?",
      "UX note: Group notes need better visual separation from personal notes.",
    ];

    for (int i = 0; i < sampleNotes.length; i++) {
      final res = await ApiService().createNote(
        uid: '13755cba-2c7f-48d2-8786-0b0c01b8bfd2',
        text: sampleNotes[i],
        email: 'fazil@mobil80.com',
      );
      if (res.isOk) {
        print('Added $i: ${sampleNotes[i]}');
      } else {
        print('Failed to add note: ${res.body}');
      }
    }
  }
}
