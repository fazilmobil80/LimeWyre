import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:limewyre/appModules/group/create_group.dart';
import 'package:limewyre/appModules/group/group_controller.dart';
import 'package:limewyre/appModules/group/group_note.dart';
import 'package:limewyre/models/groups_model.dart';
import 'package:limewyre/utils/const_page.dart';
import 'package:limewyre/utils/global_variables.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class GroupsPage extends StatelessWidget {
  final GroupController controller = Get.isRegistered()
      ? Get.find<GroupController>()
      : Get.put(GroupController());
  GroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorConst.groupPrimary,
        ),
        onPressed: () =>
            Get.dialog(barrierDismissible: false, CreateGroupDialog()),
        icon: Icon(Icons.group_add_outlined),
        label: const Text('Create group'),
      ),
      body: RefreshIndicator(
        color: ColorConst.groupPrimary,
        onRefresh: () async => await controller.listGroups(),
        child: Obx(() {
          if (controller.isGroupsLoading.value) {
            return Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: ColorConst.groupPrimary,
                size: 25,
              ),
            );
          }
          if (controller.groups.isEmpty) {
            return Center(child: _emptyGroups());
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: controller.groups.length,
            itemBuilder: (context, index) {
              final group = controller.groups[index];
              return _groupCard(group: group);
            },
          );
        }),
      ),
    );
  }

  Widget _groupCard({required GroupModel group}) {
    bool isowner = group.groupOwnerEmailId == currentUserEmail;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ColorConst.groupPrimary.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        onTap: () => Get.to(() => GroupNote(group: group)),
        contentPadding: EdgeInsets.zero,
        leading: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: const Color(0xFFE0FCE4),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.group, size: 28, color: Color(0xFF22C55E)),
        ),
        title: Row(
          children: [
            Text(
              group.groupName,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              style: Get.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            // if (isowner) ...[
            //   const SizedBox(width: 5),
            //   Container(
            //     padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            //     decoration: BoxDecoration(
            //       color: ColorConst.groupPrimary.withValues(alpha: 0.1),
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //     child: Text(
            //       'Owner',
            //       style: Get.textTheme.bodySmall!.copyWith(
            //         color: ColorConst.groupPrimary,
            //         fontWeight: FontWeight.w500,
            //       ),
            //     ),
            //   ),
            // ],
          ],
        ),
        subtitle: Text(
          group.totalMembers == 1
              ? '${group.totalMembers} member'
              : '${group.totalMembers} members',
          style: Get.textTheme.bodySmall!.copyWith(color: Colors.grey),
        ),
        trailing: isowner
            ? Icon(Iconsax.star1, size: 25, color: ColorConst.groupPrimary)
            : null,
      ),
    );
  }

  Widget _emptyGroups() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () =>
                Get.dialog(barrierDismissible: false, CreateGroupDialog()),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: ColorConst.groupPrimary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.post_add_rounded,
                size: 36,
                color: ColorConst.groupPrimary,
              ),
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'No Groups added',
            style: Get.textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 6),

          Text(
            'Create groups and start collaborating with your people',
            textAlign: TextAlign.center,
            style: Get.textTheme.bodyMedium!.copyWith(
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
