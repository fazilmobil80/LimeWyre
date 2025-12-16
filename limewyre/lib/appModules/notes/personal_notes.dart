import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:limewyre/appModules/notes/notes_controller.dart';
import 'package:limewyre/utils/const_page.dart';
import 'package:limewyre/utils/custom_widgets.dart';
import 'package:limewyre/utils/intent_share.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class PersonalNotes extends StatefulWidget {
  const PersonalNotes({super.key});

  @override
  State<PersonalNotes> createState() => _PersonalNotesState();
}

class _PersonalNotesState extends State<PersonalNotes> {
  final NotesController controller = Get.isRegistered()
      ? Get.find<NotesController>()
      : Get.put(NotesController());

  late final TextEditingController textController;
  late final FocusNode focusNode;
  bool shouldAutofocus = false;

  @override
  void initState() {
    super.initState();

    textController = TextEditingController();
    focusNode = FocusNode();

    if (IntentShare.sharedText != null) {
      textController.text = '${IntentShare.sharedText}\n';
      controller.noteTexts.value = textController.text;
      shouldAutofocus = true;

      /// Clear ONLY after prefilling
      WidgetsBinding.instance.addPostFrameCallback((_) {
        focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (IntentShare.sharedText != null) {
      textController.text = '${IntentShare.sharedText} \n';
    }
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RefreshIndicator(
          onRefresh: () => controller.loadNotes(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Notes',
                    style: Get.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Obx(
                    () => Text(
                      '${controller.noteList.length} Notes',
                      style: Get.textTheme.titleSmall!,
                    ),
                  ),
                ],
              ),
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
                            onPressed: () async => controller.loadNotes(),
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
                    itemCount: controller.noteList.length,
                    itemBuilder: (context, index) {
                      final Map<String, dynamic> note =
                          controller.noteList[index];
                      return _buildNoteCard(
                        noteId: note['note_id'] ?? '',
                        text: note['text'] ?? note['resolved_text'],
                        time: note['created_at'],
                        status: note['status'],
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
    String? status,
  }) {
    bool loading = status == 'LOADING';
    bool failed = status == 'FAILED';
    return Card(
      color: ColorConst.primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Linkify(
                    text: text,
                    style: Get.textTheme.bodyMedium!.copyWith(
                      color: Colors.white,
                    ),
                    onOpen: (link) async {
                      final uri = Uri.parse(link.url);
                      // if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                      // }
                    },
                    linkStyle: Get.textTheme.bodyMedium!.copyWith(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.blue,
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
                            color: failed ? Colors.red : Colors.grey.shade400,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            CustomWidgets().formatNoteTime(time),
                            style: Get.textTheme.bodySmall!.copyWith(
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () async {
                          if (noteId.isEmpty) {
                            controller.loadNotes();
                            return;
                          }
                          bool result = await CustomWidgets.customAlertBox(
                            title: 'Delete note',
                            content:
                                'Are you sure you want to delete this note?',
                          );
                          if (result == true) {
                            controller.deleteNote(noteId);
                          }
                        },
                        child: Icon(Icons.delete, size: 20, color: Colors.red),
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
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: textController,
            focusNode: focusNode,
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
              hintStyle: Get.textTheme.bodyMedium!.copyWith(color: Colors.grey),
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
            textController.clear();
            controller.noteTexts.value = '';
            IntentShare.sharedText = null;
            await controller.createNote(text);
          },

          icon: Icon(Icons.send_rounded),
        ),
      ],
    );
  }
}
