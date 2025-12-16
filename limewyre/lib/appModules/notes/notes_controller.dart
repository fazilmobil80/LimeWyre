import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:limewyre/services/api_service.dart';
import 'package:limewyre/utils/global_variables.dart';

class NotesController extends GetxController {
  @override
  void onInit() {
    loadNotes();
    super.onInit();
  }

  RxString noteTexts = ''.obs;

  final RxList noteList = [].obs;
  RxBool isLoading = false.obs;
  Future<void> loadNotes() async {
    // noteList.clear();
    isLoading.value = true;
    final response = await ApiService().listNotes(
      uid: currentUserEmail,
      userEmail: currentUserEmail,
    );
    if (response.isOk) {
      log('NOTE RESPONCE === ${response.body}');
      noteList.value = response.body['notes'];
      noteList.sort((a, b) => b['created_at'].compareTo(a['created_at']));
    } else {
      log(
        "Error loading notes : ${response.statusText ?? 'Failed to load notes'}",
      );
    }
    isLoading.value = false;
  }

  Future<void> createNote(String text) async {
    noteList.insert(0, {
      'text': text,
      'created_at': DateTime.now().millisecondsSinceEpoch,
      'status': 'LOADING',
      'owner': currentUserEmail,
    });
    final res = await ApiService().createNote(
      uid: currentUserId,
      text: text,
      email: currentUserEmail,
    );
    if (res.isOk) {
      log('NOTE RESPONCE === ${res.body}');
      noteList[0]['status'] = 'SUCCESS';
    } else {
      noteList[0]['status'] = 'FAILED';
      log("Error creating notes : ${res.statusText}");
    }
    noteTexts.value = '';
    noteList.refresh();
  }

  Future<void> deleteNote(String noteId) async {
    final res = await ApiService().deleteNote(
      uid: currentUserEmail,
      noteId: noteId,
    );
    if (res.isOk) {
      log('DELETE === ${res.body}');
      Fluttertoast.showToast(msg: 'Note deleted');
      noteList.removeWhere((element) => element['note_id'] == noteId);
      // loadNotes();
    } else {
      log("Error deleting notes : ${res.statusText}'}");
    }
  }

  //-----------GROUPS-----------------

  final RxList groupNotes = [].obs;
  Future<void> loadGroupNotes(String groupId) async {
    groupNotes.clear();
    isLoading.value = true;
    final response = await ApiService().listNotes(
      uid: groupId,
      userEmail: currentUserEmail,
    );
    log('GROUP NOTES === ${response.body}');
    if (response.isOk) {
      groupNotes.value = response.body['notes'];
      groupNotes.sort((a, b) => b['created_at'].compareTo(a['created_at']));
    } else {
      log(
        "Error loading group notes : ${response.statusText ?? 'Failed to load notes'}",
      );
    }
    isLoading.value = false;
  }

  Future<void> createGroupNote({
    required String groupId,
    required String text,
  }) async {
    groupNotes.insert(0, {
      'text': text,
      'created_at': DateTime.now().millisecondsSinceEpoch,
      'status': 'LOADING',
      'owner': currentUserEmail,
    });
    final res = await ApiService().createNote(
      uid: groupId,
      text: text,
      email: currentUserEmail,
    );
    if (res.isOk) {
      log('CREATED GROUP NOTE === ${res.body}');
      groupNotes[0]['status'] = 'SUCCESS';
    } else {
      groupNotes[0]['status'] = 'FAILED';
      log("Error creating group notes : ${res.statusText}");
    }
    noteTexts.value = '';
    groupNotes.refresh();
  }

  Future<void> deletegroupNote({
    required String groupId,
    required String noteId,
  }) async {
    final res = await ApiService().deleteNote(uid: groupId, noteId: noteId);
    if (res.isOk) {
      Fluttertoast.showToast(msg: 'Note deleted');
      groupNotes.removeWhere((element) => element['note_id'] == noteId);
      // loadNotes();
    } else {
      log("Error deleting group notes : ${res.statusText}'}");
    }
  }
}
