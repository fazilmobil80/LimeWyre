import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:limewyre/appModules/group/group_controller.dart';
import 'package:limewyre/appModules/group/group_info.dart';
import 'package:limewyre/appModules/notes/note_card.dart';
import 'package:limewyre/appModules/notes/notes_controller.dart';
import 'package:limewyre/models/groups_model.dart';
import 'package:limewyre/utils/const_page.dart';
import 'package:limewyre/utils/global_variables.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class GroupNote extends StatefulWidget {
  final GroupModel group;
  const GroupNote({super.key, required this.group});

  @override
  State<GroupNote> createState() => _GroupNoteState();
}

class _GroupNoteState extends State<GroupNote> {
  final NotesController noteController = Get.isRegistered()
      ? Get.find<NotesController>()
      : Get.put(NotesController());
  final GroupController groupController = Get.isRegistered()
      ? Get.find<GroupController>()
      : Get.put(GroupController());

  @override
  void initState() {
    noteController.textController = TextEditingController();
    noteController.loadNotes(widget.group.groupId);
    groupController.listMembers(widget.group.groupId);
    noteController.clearNoteEditing();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.black,
        elevation: 1,
        leadingWidth: 50,
        title: InkWell(
          onTap: () => Get.to(() => GroupInfo(group: widget.group)),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.group.groupName),
                    Obx(() {
                      return Text(
                        groupController.membersLoading.value
                            ? 'Loading members...'
                            : groupController.groupMembers
                                  .map(
                                    (m) => m.userEmailId == currentUserEmail
                                        ? "You"
                                        : m.userEmailId
                                              .split('@')
                                              .first
                                              .capitalize,
                                  )
                                  .join(', '),
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: Get.textTheme.bodySmall!.copyWith(
                          color: Colors.grey,
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RefreshIndicator(
          color: ColorConst.groupPrimary,
          onRefresh: () async {
            noteController.isLoading.value = true;
            await noteController.listNotes(widget.group.groupId);
            noteController.isLoading.value = false;
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Obx(() {
                  if (noteController.isLoading.value) {
                    return Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: ColorConst.groupPrimary,
                        size: 25,
                      ),
                    );
                  }
                  if (noteController.noteList.isEmpty) {
                    return Center(child: _emptyNote());
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: noteController.noteList.length,
                    itemBuilder: (context, index) {
                      final note = noteController.noteList[index];
                      return NoteCard(
                        note: note,
                        status: note['status'] ?? 'SUCCESS',
                        groupId: widget.group.groupId,
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
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Obx(() {
            if (noteController.isEditingNote.value) {
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
                      noteController.clearNoteEditing();
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
                  focusNode: noteController.focusNode,
                  onChanged: (val) => noteController.noteTexts.value = val,
                  onTapOutside: (event) =>
                      FocusManager.instance.primaryFocus!.unfocus(),
                  controller: noteController.textController,
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  minLines: 1,
                  maxLines: 6,
                  maxLength: 2500,
                  style: Get.textTheme.bodyMedium,
                  decoration: InputDecoration(
                    counterText: '',
                    fillColor: Colors.grey.shade100,
                    hintText: "Add a note in ${widget.group.groupName}...",
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
                  backgroundColor: ColorConst.groupPrimary,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  final text = noteController.noteTexts.value.trim();
                  if (text.isEmpty) return;
                  noteController.textController.clear();
                  noteController.noteTexts.value = '';
                  if (noteController.isEditingNote.value) {
                    await noteController.editNote(
                      newText: text,
                      noteId: noteController.editingNoteId!,
                      groupId: widget.group.groupId,
                    );
                    noteController.isEditingNote.value = false;
                    noteController.editingNoteId = null;
                  } else {
                    await noteController.createNote(
                      text: text,
                      groupId: widget.group.groupId,
                    );
                  }
                },
                icon: Icon(Icons.send_rounded),
              ),
            ],
          ),
        ],
      ),
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
              noteController.focusNode.requestFocus();
            },
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
            'No notes yet',
            style: Get.textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 6),

          Text(
            'Start adding you thoughts and moments..',
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
