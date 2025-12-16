import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:limewyre/appModules/group/group_controller.dart';
import 'package:limewyre/appModules/group/invite_member.dart';
import 'package:limewyre/models/groups_model.dart';
import 'package:limewyre/utils/const_page.dart';
import 'package:limewyre/utils/custom_widgets.dart';
import 'package:limewyre/utils/global_variables.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class GroupInfo extends StatelessWidget {
  final GroupController controller = Get.find<GroupController>();
  final GroupItem group;

  GroupInfo({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(leadingWidth: 50, title: Text('Group info')),
      body: Obx(() {
        return SingleChildScrollView(
          child: Column(
            children: [headerSection(w), membersSection(), _actions()],
          ),
        );
      }),
    );
  }

  Widget headerSection(double w) {
    return Container(
      width: w,
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Group Avatar
          CircleAvatar(
            radius: 50,
            backgroundColor: ColorConst.groupPrimary,
            child: Icon(Icons.groups_2, color: Colors.white, size: 50),
          ),
          const SizedBox(height: 16),
          Text(
            group.groupName,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          Text(
            'Group • ${controller.groupMembers.length} members',
            style: Get.textTheme.bodySmall!.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(
            'Created on • ${DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(group.userCreatedOn))}',
            style: Get.textTheme.bodySmall!.copyWith(color: Colors.grey),
          ),
          // const SizedBox(height: 8),
          // Text(
          //   'Created by • ${group.userEmailId == currentUserEmail ? 'You' : group.userEmailId}',
          //   style: Get.textTheme.bodySmall!.copyWith(color: Colors.grey),
          // ),

          // const SizedBox(height: 8),
          // Text(
          //   'Notes • 5 notes',
          //   style: Get.textTheme.bodySmall!.copyWith(color: Colors.grey),
          // ),
        ],
      ),
    );
  }

  Widget membersSection() {
    return Card(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '${controller.groupMembers.length} members',
              style: Get.textTheme.bodySmall,
            ),
          ),
          if (group.userRole == 'OWNER')
            Obx(
              () => ListTile(
                onTap: () async => Get.dialog(
                  barrierDismissible: false,
                  InviteMember(groupId: group.groupId),
                ),
                leading: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorConst.groupPrimary,
                  ),
                  child: const Icon(Icons.person_add, color: Colors.white),
                ),
                title: Row(
                  children: [
                    Text(
                      'Invite Member',
                      style: Get.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (controller.inviting.value)
                      LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.grey,
                        size: 15,
                      ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 10),
          Obx(() {
            if (controller.membersLoading.value) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.grey,
                    size: 25,
                  ),
                ),
              );
            }
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.groupMembers.length,
              itemBuilder: (context, index) {
                final item = controller.groupMembers[index];
                bool isGroupOwner = group.userRole == 'OWNER';
                bool isActive = item.userStatus == 'ACTIVE';
                return ListTile(
                  onTap: !isGroupOwner || item.userEmailId == currentUserEmail
                      ? null
                      : () => Get.dialog(
                          _userInfo(
                            userEmail: item.userEmailId,
                            userId: item.userId,
                          ),
                        ),
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundColor: isActive
                        ? ColorConst.groupPrimary
                        : Colors.grey,
                    child: Text(
                      item.userEmailId[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.userEmailId == currentUserEmail
                              ? 'You'
                              : item.userEmailId,
                          style: Get.textTheme.bodyMedium!.copyWith(
                            color: !isActive ? Colors.grey : null,
                          ),
                        ),
                      ),
                      item.userRole == 'OWNER'
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: ColorConst.groupPrimary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Owner',
                                style: Get.textTheme.bodySmall!.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : group.userRole == 'OWNER'
                          ? Icon(Icons.arrow_right, size: 25)
                          : SizedBox.shrink(),
                    ],
                  ),
                  subtitle: isActive
                      ? null
                      : Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 15,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'Invitation pending',
                              style: Get.textTheme.bodySmall!.copyWith(
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _actions() {
    return Card(
      color: Colors.white,
      child: Obx(() {
        if (controller.membersLoading.value) {
          return SizedBox.shrink();
        }
        return Column(
          children: [
            ListTile(
              onTap: controller.leavingGroup.value
                  ? null
                  : () async {
                      bool result = await CustomWidgets.customAlertBox(
                        title: 'Leave group',
                        content: 'Are you sure you want to leave this group?',
                      );
                      if (result == true) {
                        if (group.userRole == 'OWNER') {
                          Fluttertoast.showToast(
                            msg:
                                'Transfer your ownership to other user before exiting the group.',
                            backgroundColor: Colors.red,
                          );
                          return;
                        }
                        controller.leaveGroup(groupId: group.groupId);
                      }
                    },
              leading: Icon(Icons.login_outlined, color: Colors.red, size: 25),
              title: Text(
                'Leave group',
                style: Get.textTheme.bodyMedium!.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (group.userRole == 'OWNER')
              ListTile(
                onTap: controller.removingGroup.value
                    ? null
                    : () async {
                        bool result = await CustomWidgets.customAlertBox(
                          title: 'Delete Group',
                          content:
                              'Are you sure you want to delete this group?',
                        );
                        if (result == true) {
                          controller.removeGroup(groupId: group.groupId);
                        }
                      },
                leading: Icon(Icons.delete_forever, color: Colors.red),
                title: Row(
                  children: [
                    controller.removingGroup.value
                        ? LoadingAnimationWidget.staggeredDotsWave(
                            color: Colors.red,
                            size: 20,
                          )
                        : Text(
                            'Delete group',
                            style: Get.textTheme.bodyMedium!.copyWith(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ],
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _userInfo({required String userEmail, required String userId}) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Username
          Text(
            userEmail,
            style: Get.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w600,
              color: ColorConst.groupPrimary,
            ),
          ),

          const SizedBox(height: 16),
          const Divider(height: 1),

          // Remove Member
          Obx(
            () => InkWell(
              onTap: controller.removingMember.value
                  ? null
                  : () async {
                      bool result = await CustomWidgets.customAlertBox(
                        title: 'Remove member',
                        content: 'Are you sure you want to remove $userEmail?',
                      );
                      if (result == true) {
                        controller.removeMember(
                          groupId: group.groupId,
                          userId: userId,
                          userEmail: userEmail.trim().toLowerCase(),
                        );
                      }
                    },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  children: [
                    Icon(Icons.delete_forever, size: 20, color: Colors.red),
                    const SizedBox(width: 5),
                    Text(
                      'Remove member',
                      style: Get.textTheme.bodyMedium!.copyWith(
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (controller.removingMember.value)
                      LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.grey,
                        size: 15,
                      ),
                  ],
                ),
              ),
            ),
          ),

          // Make Owner
          Obx(
            () => InkWell(
              onTap: controller.transferringOwnerShip.value
                  ? null
                  : () async {
                      bool result = await CustomWidgets.customAlertBox(
                        title: 'Make Owner',
                        content:
                            'Are you sure you want to make $userEmail the owner?',
                      );
                      if (result == true) {
                        controller.transferOwnerShip(
                          groupId: group.groupId,
                          newUserId: userId,
                        );
                      }
                    },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  children: [
                    Icon(Icons.person, size: 20),
                    const SizedBox(width: 5),
                    Text('Make group Owner', style: Get.textTheme.bodyMedium),
                    const SizedBox(width: 10),
                    if (controller.transferringOwnerShip.value)
                      LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.grey,
                        size: 15,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
