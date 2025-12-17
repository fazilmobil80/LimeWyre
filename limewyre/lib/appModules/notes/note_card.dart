import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:limewyre/appModules/notes/notes_controller.dart';
import 'package:limewyre/utils/const_page.dart';
import 'package:limewyre/utils/custom_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class NoteCard extends StatelessWidget {
  final NotesController controller = Get.isRegistered()
      ? Get.find<NotesController>()
      : Get.put(NotesController());
  final Map<String, dynamic> note;
  final String status;
  final String? groupId;

  NoteCard({super.key, required this.note, required this.status, this.groupId});

  @override
  Widget build(BuildContext context) {
    bool loading = status == 'LOADING';
    bool failed = status == 'FAILED';
    bool isGroup = groupId != null;
    return Card(
      color: isGroup ? ColorConst.groupPrimary : Colors.white,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Linkify(
                    text: note['text'] ?? note['resolved_text'] ?? '',
                    style: Get.textTheme.bodyMedium!.copyWith(
                      color: isGroup ? Colors.white : Colors.black,
                    ),
                    onOpen: (link) async {
                      final uri = Uri.parse(link.url);
                      await launchUrl(uri);
                    },
                    linkStyle: Get.textTheme.bodyMedium!.copyWith(
                      color: isGroup ? ColorConst.primaryColor : Colors.blue,
                      decoration: TextDecoration.underline,
                      decorationColor: isGroup
                          ? ColorConst.primaryColor
                          : Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            loading
                                ? Icons.access_time
                                : failed
                                ? Icons.error_outline
                                : Icons.done,
                            size: 12,
                            color: failed
                                ? Colors.red
                                : isGroup
                                ? Colors.grey.shade300
                                : Colors.grey.shade400,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            CustomWidgets().formatNoteTime(note['created_at']),
                            style: Get.textTheme.bodySmall!.copyWith(
                              color: isGroup
                                  ? Colors.grey.shade300
                                  : Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                      // if (!loading)
                      PopupMenuButton(
                        tooltip: 'More options',
                        menuPadding: EdgeInsets.zero,
                        color: Colors.white,
                        icon: isGroup
                            ? Icon(
                                Icons.more_vert,
                                color: loading
                                    ? ColorConst.groupPrimary
                                    : Colors.grey.shade300,
                              )
                            : Icon(
                                Icons.more_vert,
                                color: loading
                                    ? Colors.white
                                    : Colors.grey.shade600,
                              ),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: ListTile(
                              leading: Icon(Icons.edit),
                              title: Text('Edit'),
                              onTap: () async {
                                Get.back();
                                controller.textController.text =
                                    note['text'] ?? note['resolved_text'] ?? '';
                                controller.noteTexts.value =
                                    note['text'] ?? note['resolved_text'] ?? '';
                                controller.editingNoteId = note['note_id'];
                                controller.focusNode.requestFocus();
                                controller.isEditingNote.value = true;
                              },
                            ),
                          ),

                          PopupMenuItem(
                            child: ListTile(
                              leading: Icon(Icons.delete, color: Colors.red),
                              title: Text('Delete'),
                              onTap: () async {
                                Get.back();
                                bool
                                result = await CustomWidgets.customAlertBox(
                                  title: 'Delete note',
                                  content:
                                      'Are you sure you want to delete this note?',
                                );
                                if (result == true) {
                                  controller.deleteNote(
                                    noteId: note['note_id'],
                                    groupId: groupId,
                                  );
                                }
                              },
                            ),
                          ),
                        ],
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
}
