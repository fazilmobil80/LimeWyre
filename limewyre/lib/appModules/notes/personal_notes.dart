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
                    return Center(child: _emptyNote());
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
                maxLength: 2500,
                textInputAction: TextInputAction.newline,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.multiline,
                style: Get.textTheme.bodyMedium,
                decoration: InputDecoration(
                  counterText: '',
                  fillColor: Colors.grey.shade100,
                  hintText: "Add a personal note...",
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

  Widget _emptyNote() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              controller.focusNode.requestFocus();
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: ColorConst.primaryColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.post_add_rounded,
                size: 36,
                color: ColorConst.primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'No notes yet',
            style: Get.textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 6),

          Text(
            'Start adding your thoughts and moments..',
            textAlign: TextAlign.center,
            style: Get.textTheme.bodyMedium!.copyWith(
              color: Colors.grey.shade500,
            ),
          ),
          // const SizedBox(height: 24),

          // ElevatedButton.icon(
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: ColorConst.primaryColor,
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(12),
          //     ),
          //     elevation: 0,
          //   ),
          //   onPressed: () {},
          //   icon: const Icon(Icons.add),
          //   label: const Text(
          //     'Add Note',
          //     style: TextStyle(fontWeight: FontWeight.w600),
          //   ),
          // ),
        ],
      ),
    );
  }
}
