import 'package:get/get.dart';

class ApiService extends GetConnect {
  ApiService() {
    httpClient.baseUrl = "https://api.limewyre.com";
    httpClient.addRequestModifier<dynamic>((request) {
      request.headers['Content-Type'] = 'application/json';
      return request;
    });
  }

  Future<Response> listNotes({
    required String uid,
    required String userEmail,
  }) async {
    final body = {
      "command": "queryRAG",
      "unique_id": uid,
      "index_name": "limewyre-notes-index",
      "owner": userEmail,
    };
    return post("/listFromDB", body);
  }

  Future<Response> createNote({
    required String uid,
    required String text,
    required String email,
  }) async {
    final body = {
      "command": "embedAndUpsert",
      "index_name": "limewyre-notes-index",
      "unique_id": uid,
      "owner": email,
      "text": text,
    };
    return post("/insertToDB", body);
  }

  Future<Response> deleteNote({
    required String uid,
    required String noteId,
  }) async {
    final body = {
      "command": "deleteNote",
      "unique_id": uid,
      "note_id": noteId,
      "index_name": "limewyre-notes-index",
    };
    return post("/deleteFromDB", body);
  }

  Future<Response> editNote({
    required String uid,
    required String noteId,
    required String newText,
  }) async {
    final body = {
      "command": "updateNotes",
      "index_name": "limewyre-notes-index",
      "unique_id": uid,
      "note_id": noteId,
      "text": newText,
    };
    return post("/updateFromDB", body);
  }

  Future<Response> queryQuestion({
    required List ids,
    required String question,
  }) async {
    final body = {
      "command": "queryRAG",
      "unique_ids": ids,
      "index_name": "limewyre-notes-index",
      "question": question,
    };
    return post("/queryFromDB", body);
  }
}
