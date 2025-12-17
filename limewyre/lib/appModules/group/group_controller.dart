import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:limewyre/models/group_members_model.dart';
import 'package:limewyre/models/groups_model.dart';
import 'package:limewyre/services/api_mutations.dart';
import 'package:limewyre/services/api_queries.dart';
import 'package:limewyre/utils/global_variables.dart';

class GroupController extends GetxController {
  @override
  void onInit() {
    listGroups();
    super.onInit();
  }

  RxInt selectedIndex = 0.obs;
  RxList<GroupModel> groups = <GroupModel>[].obs;

  RxBool isGroupsLoading = false.obs;
  Future listGroups() async {
    isGroupsLoading.value = true;
    try {
      final data = await ApiQueries().getApiQueries(
        request: ApiQueries.listGroups,
        input: {'limit': 101, 'next_token': 'undefined'},
        label: 'ListGroups',
      );
      GroupListModel groupData = GroupListModel.fromJson(data);
      groups.value = groupData.data.items;
      groups.removeWhere((e) => e.groupName == currentUserEmail);
      groups.sort((a, b) => b.groupCreatedOn.compareTo(a.groupCreatedOn));
    } catch (e) {
      log('Error listing groups :$e');
    } finally {
      isGroupsLoading.value = false;
    }
  }

  RxBool isCreating = false.obs;
  Future createGroup({required String groupName}) async {
    isCreating.value = true;
    try {
      final data = await ApiMutations().apiMutations(
        request: ApiMutations.createGroups,
        input: {'group_name': groupName},
      );
      if (data == 'SUCCESS') {
        Fluttertoast.showToast(msg: 'Group created');
        Get.back();
        listGroups();
      } else {
        Fluttertoast.showToast(msg: data, backgroundColor: Colors.red);
      }
    } catch (e) {
      log('Error creating group :$e');
    } finally {
      isCreating.value = false;
    }
  }

  RxBool membersLoading = false.obs;
  RxList<GroupMember> groupMembers = <GroupMember>[].obs;
  Future listMembers(String groupId) async {
    membersLoading.value = true;
    groupMembers.clear();
    try {
      final data = await ApiQueries().getApiQueries(
        request: ApiQueries.listGroupUsers,
        input: {'group_id': groupId},
        label: 'ListGroupUsers',
      );
      if (data['status'] == 'SUCCESS') {
        groupMembers.value = GroupMembersResponse.fromJson(data['data']).items;
        groupMembers.sort((a, b) {
          if (a.userEmailId == currentUserEmail) return -1;
          if (b.userEmailId == currentUserEmail) return 1;
          return 0;
        });
      } else {
        log('GROUP MEMBERS ERROR == ${data['error']}');
      }
    } catch (e) {
      log('Error listing group members :$e');
    } finally {
      membersLoading.value = false;
    }
  }

  RxBool inviting = false.obs;
  Future inviteMember({required String groupId, required String email}) async {
    inviting.value = true;
    try {
      var data = await ApiMutations().apiMutations(
        request: ApiMutations.inviteMember,
        input: {'group_id': groupId, 'invitie_email_id': email},
      );
      if (data == 'SUCCESS') {
        listMembers(groupId);
        Fluttertoast.showToast(msg: '$email invited to the group');
      } else {
        Fluttertoast.showToast(msg: '$data', backgroundColor: Colors.red);
      }
    } catch (e) {
      log('Error inviting member : $e');
    } finally {
      inviting.value = false;
    }
  }

  RxBool removingMember = false.obs;
  Future removeMember({
    required String groupId,
    required String userEmail,
    required String userId,
  }) async {
    removingMember.value = true;
    try {
      var data = await ApiMutations().apiMutations(
        request: ApiMutations.removeUserFromGroup,
        input: {'remove_user_id': userId, 'group_id': groupId},
      );
      if (data == 'SUCCESS') {
        Get.back();
        listMembers(groupId);
        Fluttertoast.showToast(msg: '$userEmail removed from the group');
      } else {
        Fluttertoast.showToast(msg: '$data', backgroundColor: Colors.red);
      }
    } catch (e) {
      log('Error inviting member : $e');
    } finally {
      removingMember.value = false;
    }
  }

  RxBool leavingGroup = false.obs;
  Future leaveGroup({required String groupId}) async {
    leavingGroup.value = true;
    try {
      var data = await ApiMutations().apiMutations(
        request: ApiMutations.leaveGroup,
        input: {'group_id': groupId},
      );
      if (data == 'SUCCESS') {
        await listGroups();
        Get.back();
        Get.back();
        Fluttertoast.showToast(msg: 'Successfully left the group!');
      } else {
        Fluttertoast.showToast(msg: '$data', backgroundColor: Colors.red);
      }
    } catch (e) {
      log('Error inviting member : $e');
    } finally {
      leavingGroup.value = false;
    }
  }

  RxBool transferringOwnerShip = false.obs;
  Future transferOwnerShip({
    required String newUserId,
    required String groupId,
  }) async {
    transferringOwnerShip.value = true;
    try {
      var data = await ApiMutations().apiMutations(
        request: ApiMutations.transferOwnership,
        input: {'new_owner_user_id': newUserId, 'group_id': groupId},
      );
      if (data == 'SUCCESS') {
        Get.back();
        await listMembers(groupId);
        Fluttertoast.showToast(msg: 'Ownership changed successfully!');
      } else {
        Fluttertoast.showToast(msg: '$data', backgroundColor: Colors.red);
      }
    } catch (e) {
      log('Error transferring ownership: $e');
    } finally {
      transferringOwnerShip.value = false;
    }
  }

  RxBool removingGroup = false.obs;
  Future removeGroup({required String groupId}) async {
    removingGroup.value = true;
    try {
      var data = await ApiMutations().apiMutations(
        request: ApiMutations.removeGroup,
        input: {'group_id': groupId},
      );
      if (data == 'SUCCESS') {
        Get.back();
        Get.back();
        await listGroups();
        Fluttertoast.showToast(msg: 'Group deleted successfully!');
      } else {
        Fluttertoast.showToast(msg: '$data', backgroundColor: Colors.red);
      }
    } catch (e) {
      log('Error removing group: $e');
    } finally {
      removingGroup.value = false;
    }
  }
}
