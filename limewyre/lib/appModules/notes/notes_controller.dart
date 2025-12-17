import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:limewyre/services/api_service.dart';
import 'package:limewyre/utils/global_variables.dart';

class NotesController extends GetxController {
  final box = Hive.box('limewyreCache');
  @override
  void onInit() {
    loadNotes(null);
    super.onInit();
  }

  RxString noteTexts = ''.obs;
  TextEditingController textController = TextEditingController();
  FocusNode focusNode = FocusNode();
  RxBool isEditingNote = false.obs;
  String? editingNoteId;

  void clearNoteEditing() {
    isEditingNote.value = false;
    editingNoteId = null;
    textController.clear();
    noteTexts.value = '';
  }

  final RxList noteList = [].obs;
  RxBool isLoading = false.obs;
  Future<void> loadNotes(String? groupId) async {
    final cachedNotes = box.get(groupId ?? 'notes');
    if (cachedNotes != null) {
      final cachedData = jsonDecode(cachedNotes);
      noteList.value = cachedData;
    }
    listNotes(groupId);
  }

  Future<void> listNotes(String? groupId) async {
    final response = await ApiService().listNotes(
      uid: groupId ?? currentUserEmail,
      userEmail: currentUserEmail,
    );
    if (response.isOk) {
      noteList.value = response.body['notes'];
      noteList.sort((a, b) => b['created_at'].compareTo(a['created_at']));
      box.put(groupId ?? 'notes', jsonEncode(noteList));
    } else {
      log(
        "Error loading notes : ${response.statusText ?? 'Failed to load notes'}",
      );
    }
  }

  Future<void> createNote({required String text, String? groupId}) async {
    noteList.insert(0, {
      'text': text,
      'created_at': DateTime.now().millisecondsSinceEpoch,
      'status': 'LOADING',
      'owner': currentUserEmail,
    });
    final res = await ApiService().createNote(
      uid: groupId ?? currentUserEmail,
      text: text,
      email: currentUserEmail,
    );
    if (res.isOk) {
      listNotes(groupId);
      noteList[0]['status'] = 'SUCCESS';
    } else {
      noteList[0]['status'] = 'FAILED';
      log("Error creating notes : ${res.statusText}");
    }
    noteTexts.value = '';
    noteList.refresh();
  }

  Future<void> editNote({
    required String noteId,
    required String newText,
    String? groupId,
  }) async {
    final index = noteList.indexWhere(
      (element) => element['note_id'] == noteId,
    );
    if (index != -1) {
      noteList[index]['text'] = newText;
      noteList[index]['status'] = 'LOADING';
      noteList.refresh();
    }
    final res = await ApiService().editNote(
      uid: groupId ?? currentUserEmail,
      noteId: noteId,
      newText: newText,
    );
    if (res.isOk) {
      Fluttertoast.showToast(msg: 'Note edited');
      listNotes(groupId);
    } else {
      if (index != -1) {
        noteList[index]['status'] = 'FAILED';
        noteList.refresh();
      }
      log("Error editing notes : ${res.statusText}");
    }
  }

  Future<void> deleteNote({required String noteId, String? groupId}) async {
    final res = await ApiService().deleteNote(
      uid: groupId ?? currentUserEmail,
      noteId: noteId,
    );
    if (res.isOk) {
      Fluttertoast.showToast(msg: 'Note deleted');
      noteList.removeWhere((element) => element['note_id'] == noteId);
    } else {
      log("Error deleting notes : ${res.statusText}'}");
    }
  }
}
