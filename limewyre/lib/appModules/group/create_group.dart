import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:limewyre/appModules/group/group_controller.dart';
import 'package:limewyre/utils/const_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CreateGroupDialog extends StatelessWidget {
  final TextEditingController _groupNameController = TextEditingController();
  final controller = Get.find<GroupController>();
  CreateGroupDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final formkey = GlobalKey<FormState>();
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create New Group',
              style: Get.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Form(
              key: formkey,
              child: TextFormField(
                controller: _groupNameController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                maxLength: 20,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Group name cannot be empty';
                  }
                  return null;
                },
                onTapOutside: (event) =>
                    FocusManager.instance.primaryFocus!.unfocus(),
                decoration: InputDecoration(
                  labelText: 'Group Name',
                  labelStyle: Get.textTheme.bodyMedium!.copyWith(
                    color: Colors.grey,
                  ),
                  hintText: 'Enter group name',
                  hintStyle: Get.textTheme.bodyMedium!.copyWith(
                    color: Colors.grey,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: ColorConst.groupPrimary),
                  ),
                  prefixIcon: const Icon(Icons.group),
                ),
                autofocus: true,
                textCapitalization: TextCapitalization.words,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text(
                    'CANCEL',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Obx(
                  () => ElevatedButton(
                    onPressed: controller.isCreating.value
                        ? null
                        : () {
                            final groupName = _groupNameController.text.trim();
                            if (formkey.currentState!.validate()) {
                              controller.createGroup(groupName: groupName);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: controller.isCreating.value
                        ? LoadingAnimationWidget.staggeredDotsWave(
                            color: ColorConst.groupPrimary,
                            size: 20,
                          )
                        : const Text(
                            'CREATE',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Example usage:
// To show this dialog, use:
// final groupName = await showDialog<String>(
//   context: context,
//   builder: (context) => const CreateGroupDialog(),
// );
// if (groupName != null) {
//   // Handle group creation with the returned group name
//   print('Group created: $groupName');
// }
