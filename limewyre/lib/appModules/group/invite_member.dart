import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:limewyre/appModules/group/group_controller.dart';
import 'package:limewyre/utils/const_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class InviteMember extends StatelessWidget {
  final TextEditingController memberEmail = TextEditingController();
  final controller = Get.find<GroupController>();
  final String groupId;
  InviteMember({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    final formkey = GlobalKey<FormState>();
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Invite Member',
              style: Get.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Form(
              key: formkey,
              child: TextFormField(
                controller: memberEmail,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (!RegExp(
                    r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
                  ).hasMatch(value!)) {
                    return "Please enter a valid Email ID";
                  }
                  return null;
                },
                onTapOutside: (event) =>
                    FocusManager.instance.primaryFocus!.unfocus(),
                decoration: InputDecoration(
                  labelText: 'Email ID',
                  labelStyle: Get.textTheme.bodyMedium!.copyWith(
                    color: Colors.grey,
                  ),
                  hintText: 'Enter Invitie Email ID',
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
                            final email = memberEmail.text.trim().toLowerCase();
                            if (formkey.currentState!.validate()) {
                              controller.inviteMember(
                                groupId: groupId,
                                email: email,
                              );
                            }
                            Get.back();
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
                            'INVITE',
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
