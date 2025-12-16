import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:limewyre/appModules/group/group_controller.dart';
import 'package:limewyre/appModules/group/group_info.dart';
import 'package:limewyre/appModules/notes/notes_controller.dart';
import 'package:limewyre/models/groups_model.dart';
import 'package:limewyre/utils/const_page.dart';
import 'package:limewyre/utils/custom_widgets.dart';
import 'package:limewyre/utils/global_variables.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class GroupNote extends StatefulWidget {
  final GroupItem group;
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

  final textController = TextEditingController();

  @override
  void initState() {
    noteController.loadGroupNotes(widget.group.groupId);
    groupController.listMembers(widget.group.groupId);
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add note'),
            Obx(
              () => Text(
                groupController.groupMembers.length <= 1
                    ? widget.group.groupName
                    : "${widget.group.groupName} • ${groupController.groupMembers.length} members",
                style: Get.textTheme.bodySmall!.copyWith(color: Colors.grey),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => Get.to(() => GroupInfo(group: widget.group)),
            icon: Icon(Icons.info_outline),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RefreshIndicator(
          color: ColorConst.groupPrimary,
          onRefresh: () async =>
              noteController.loadGroupNotes(widget.group.groupId),
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
                  if (noteController.groupNotes.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('No Notes added!'),
                          TextButton.icon(
                            style: TextButton.styleFrom(
                              foregroundColor: ColorConst.groupPrimary,
                            ),
                            onPressed: () async => noteController
                                .loadGroupNotes(widget.group.groupId),
                            label: const Text('Refresh'),
                            icon: Icon(Icons.refresh),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: noteController.groupNotes.length,
                    itemBuilder: (context, index) {
                      final note = noteController.groupNotes[index];

                      return SizedBox(
                        child: _buildNoteCard(
                          noteId: note['note_id'] ?? '',
                          text: note['text']!,
                          owner: note['owner'] ?? '-N/A-',
                          time: note['created_at'],
                          status: note['status'],
                        ),
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

  Widget _buildNoteCard({
    required String text,
    required int time,
    required String noteId,
    required String owner,
    String? status,
  }) {
    bool loading = status == 'LOADING';
    bool failed = status == 'FAILED';
    bool isOwner = owner == currentUserEmail;
    return Container(
      constraints: BoxConstraints(maxWidth: w * 0.80),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isOwner
            ? ColorConst.groupPrimary.shade600
            : ColorConst.groupPrimary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isOwner ? '~ You' : '@$owner',
                    style: Get.textTheme.bodySmall!.copyWith(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Linkify(
                    text: text,
                    style: Get.textTheme.bodyMedium!.copyWith(
                      color: Colors.white,
                    ),
                    onOpen: (link) async {
                      final uri = Uri.parse(link.url);
                      await launchUrl(uri);
                    },
                    linkStyle: Get.textTheme.bodyMedium!.copyWith(
                      color: ColorConst.primaryColor,
                      decoration: TextDecoration.underline,
                      decorationColor: ColorConst.primaryColor,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            loading
                                ? Icons.access_time
                                : failed
                                ? Icons.error_outline
                                : Icons.done,
                            size: 12,
                            color: failed ? Colors.red : Colors.grey.shade300,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            CustomWidgets().formatNoteTime(time),
                            style: Get.textTheme.bodySmall!.copyWith(
                              color: Colors.grey.shade300,
                            ),
                          ),
                        ],
                      ),
                      if (isOwner)
                        InkWell(
                          onTap: () async {
                            if (noteId.isEmpty) {
                              noteController.loadGroupNotes(
                                widget.group.groupId,
                              );
                              return;
                            }
                            bool result = await CustomWidgets.customAlertBox(
                              title: 'Delete note',
                              content:
                                  'Are you sure you want to delete this note?',
                            );
                            if (result == true) {
                              noteController.deletegroupNote(
                                groupId: widget.group.groupId,
                                noteId: noteId,
                              );
                            }
                          },
                          child: Icon(
                            Icons.delete,
                            size: 20,
                            color: Colors.red,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _notesInput() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              // autofocus: true,
              onChanged: (val) => noteController.noteTexts.value = val,
              onTapOutside: (event) =>
                  FocusManager.instance.primaryFocus!.unfocus(),
              controller: textController,
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              minLines: 1,
              maxLines: 6,
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
              backgroundColor: ColorConst.groupPrimary,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              if (noteController.noteTexts.value.isEmpty) {
                return;
              }
              noteController.createGroupNote(
                groupId: widget.group.groupId,
                text: noteController.noteTexts.value,
              );
              textController.clear();
            },
            icon: Icon(Icons.send_rounded),
          ),
        ],
      ),
    );
  }
}
