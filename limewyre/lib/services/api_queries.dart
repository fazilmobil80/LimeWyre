import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';

class ApiQueries {
  Future getApiQueries({
    required String request,
    required Map<String, dynamic> input,
    required String label,
  }) async {
    var res = Amplify.API.query(
      request: GraphQLRequest(document: request, variables: {'input': input}),
    );
    var response = await res.response;
    if (!response.hasErrors) {
      Map<String, dynamic> jsonData = jsonDecode(response.data);
      Map<String, dynamic> data = jsonDecode(jsonData[label]);
      return {'status': 'SUCCESS', 'data': data['data']};
    }
    return {'status': 'ERROR', 'error': response.errors.first.message};
  }

  static const getCurrentUser = r'''
  query GetCurrentUserDetails($input: GetCurrentUserDetailsInput) {
    GetCurrentUserDetails(input: $input)
  }''';

  static const listGroups = r'''
  query ListGroups($input: ListGroupsInput) {
    ListGroups(input: $input)
  }''';

  static const listGroupUsers = r'''
  query ListGroupUsers($input: ListGroupUsersInput) {
    ListGroupUsers(input: $input)
  }''';
}
