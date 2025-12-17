import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:limewyre/appModules/notes/note_card.dart';
import 'package:limewyre/appModules/notes/notes_controller.dart';
import 'package:limewyre/utils/const_page.dart';
import 'package:limewyre/utils/intent_share.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class PersonalNotes extends StatefulWidget {
  const PersonalNotes({super.key});

  @override
  State<PersonalNotes> createState() => _PersonalNotesState();
}

class _PersonalNotesState extends State<PersonalNotes> {
  final NotesController controller = Get.isRegistered()
      ? Get.find<NotesController>()
      : Get.put(NotesController());

  @override
  void initState() {
    super.initState();
    controller.loadNotes(null);
    controller.textController = TextEditingController();
    controller.clearNoteEditing();
    if (IntentShare.sharedText != null) {
      controller.textController.text = '${IntentShare.sharedText}\n';
      controller.noteTexts.value = controller.textController.text;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.focusNode.requestFocus();
      });
    }
  }

  // @override
  // void dispose() {
  //   // controller.textController.dispose();
  //   controller.focusNode.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    if (IntentShare.sharedText != null) {
      controller.textController.text = '${IntentShare.sharedText} \n';
    }
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RefreshIndicator(
          onRefresh: () async {
            controller.isLoading.value = true;
            await controller.listNotes(null);
            controller.isLoading.value = false;
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              // Text(
              //   'Recent Notes',
              //   style: Get.textTheme.titleMedium!.copyWith(
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              //     const SizedBox(height: 5),
              //     Obx(
              //       () => Text(
              //         '${controller.noteList.length} Notes',
              //         style: Get.textTheme.titleSmall!,
              //       ),
              //     ),
              //   ],
              // ),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: ColorConst.primaryColor,
                        size: 25,
                      ),
                    );
                  }
                  if (controller.noteList.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('No Notes added!'),
                          TextButton.icon(
                            style: TextButton.styleFrom(
                              foregroundColor: ColorConst.primaryColor,
                            ),
                            onPressed: () async {
                              controller.isLoading.value = true;
                              await controller.listNotes(null);
                              controller.isLoading.value = false;
                            },
                            label: const Text('Refresh'),
                            icon: Icon(Icons.refresh),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: controller.noteList.length,
                    itemBuilder: (context, index) {
                      final Map<String, dynamic> note =
                          controller.noteList[index];
                      return NoteCard(
                        note: note,
                        status: note['status'] ?? 'SUCCESS',
                      );
                    },
                  );
                }),
              ),
              _notesInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _notesInput() {
    return Column(
      children: [
        Obx(() {
          if (controller.isEditingNote.value) {
            return Row(
              children: [
                Icon(Icons.edit, size: 16, color: ColorConst.primaryColor),
                const SizedBox(width: 6),
                Text(
                  'Editing Note',
                  style: Get.textTheme.bodyMedium!.copyWith(
                    color: ColorConst.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    controller.clearNoteEditing();
                  },
                  child: Text(
                    'Cancel',
                    style: Get.textTheme.bodyMedium!.copyWith(
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            );
          }
          return SizedBox.shrink();
        }),

        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller.textController,
                focusNode: controller.focusNode,
                onTapOutside: (event) =>
                    FocusManager.instance.primaryFocus!.unfocus(),
                onChanged: (val) => controller.noteTexts.value = val,
                minLines: 1,
                maxLines: 6,
                textInputAction: TextInputAction.newline,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.multiline,
                style: Get.textTheme.bodyMedium,
                decoration: InputDecoration(
                  fillColor: Colors.grey.shade100,
                  hintText: "Type your note...",
                  hintStyle: Get.textTheme.bodyMedium!.copyWith(
                    color: Colors.grey,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              style: IconButton.styleFrom(
                backgroundColor: ColorConst.primaryColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                final text = controller.noteTexts.value.trim();
                if (text.isEmpty) return;
                controller.textController.clear();
                controller.noteTexts.value = '';
                IntentShare.sharedText = null;
                if (controller.isEditingNote.value) {
                  await controller.editNote(
                    newText: text,
                    noteId: controller.editingNoteId!,
                  );
                  controller.isEditingNote.value = false;
                  controller.editingNoteId = null;
                } else {
                  await controller.createNote(text: text);
                }
              },

              icon: Icon(Icons.send_rounded),
            ),
          ],
        ),
      ],
    );
  }
}
