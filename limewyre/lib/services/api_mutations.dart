import 'dart:developer';

import 'package:amplify_flutter/amplify_flutter.dart';

class ApiMutations {
  Future apiMutations({
    required String request,
    required Map<String, dynamic> input,
  }) async {
    var response = Amplify.API.query(
      request: GraphQLRequest(document: request, variables: {'input': input}),
    );
    var res = await response.response;
    if (!res.hasErrors) {
      log('SUCCESS == ${res.data}');
      return 'SUCCESS';
    } else {
      log('ERROR == ${res.errors}');
      return res.errors.first.message;
    }
  }

  static const createGroups = r'''
  mutation CreateGroup($input: CreateGroupInput) {
    CreateGroup(input: $input)
  }''';

  static const inviteMember = r'''
  mutation InviteMember($input: InviteMemberInput) {
    InviteMember(input: $input)
  }''';

  static const leaveGroup = r'''
  mutation LeaveGroup($input: LeaveGroupInput) {
    LeaveGroup(input: $input)
  }''';

  static const removeUserFromGroup = r'''
  mutation RemoveUserFromGroup($input: RemoveUserFromGroupInput) {
    RemoveUserFromGroup(input: $input)
  }''';

  static const transferOwnership = r'''
  mutation TransferOwnership($input: TransferOwnershipInput) {
    TransferOwnership(input: $input)
  }''';

  static const removeGroup = r'''
  mutation RemoveGroup($input: RemoveGroupInput) {
    RemoveGroup(input: $input)
  }''';

  static const deleteMyAccount = r'''
  mutation DeleteMyAccount {
    DeleteMyAccount
  }''';
}
