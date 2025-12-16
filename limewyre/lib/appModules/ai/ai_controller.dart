import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:limewyre/services/api_service.dart';
import 'package:limewyre/utils/global_variables.dart';

class AiController extends GetxController {
  final ScrollController scrollController = ScrollController();
  void scrollToBottom() {
    if (!scrollController.hasClients) return;
    Future.delayed(Duration(milliseconds: 200), () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  final suggestions = [
    "What were my Bangalore trip ideas?",
    "What books did I want to read?",
    "What are my startup ideas?",
    "What did I plan for my meeting?",
  ];

  RxList aiChat = [].obs;
  RxString messageText = ''.obs;

  Future queryQuestions({required String question}) async {
    List ids = [
      currentUser!.userEmailId,
      currentUserId,
      ...currentUser!.groupIds,
    ];
    aiChat.add({'text': question});
    scrollToBottom();
    aiChat.add({'text': 'is_thinking'});
    final res = await ApiService().queryQuestion(ids: ids, question: question);
    if (res.isOk) {
      aiChat.removeLast();
      aiChat.add({'text': res.body['answer'], 'source': res.body['source']});
      scrollToBottom();
      log('QUERY == ${res.body}');
    } else {
      aiChat.removeLast();
      aiChat.add({'text': ''});
      log("Error getting queries : ${res.statusText}'}");
    }
    aiChat.refresh();
  }
}
