import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:limewyre/appModules/notes/notes_controller.dart';
import 'package:limewyre/utils/const_page.dart';
import 'package:limewyre/utils/custom_widgets.dart';
import 'package:limewyre/utils/global_variables.dart';
import 'package:url_launcher/url_launcher.dart';

class NoteCard extends StatefulWidget {
  final Map<String, dynamic> note;
  final String status;
  final String? groupId;

  const NoteCard({
    super.key,
    required this.note,
    required this.status,
    this.groupId,
  });

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<NotesController>()
        ? Get.find<NotesController>()
        : Get.put(NotesController());

    bool loading = widget.status == 'LOADING';
    bool failed = widget.status == 'FAILED';
    bool isGroup = widget.groupId != null;
    bool isOwner = widget.note['owner'] == currentUserEmail;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          margin: EdgeInsets.only(
            bottom: 10,
            left: isGroup && isOwner ? 20 : 0,
            right: !isGroup
                ? 0
                : isGroup && isOwner
                ? 0
                : 20,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  // Animated side bar
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Container(
                        width: 5,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              isGroup
                                  ? ColorConst.groupPrimary
                                  : ColorConst.primaryColor,
                              (isGroup
                                      ? ColorConst.groupPrimary
                                      : ColorConst.primaryColor)
                                  .withValues(alpha: 0.6),
                            ],
                            stops: [0.0, value],
                          ),
                        ),
                      );
                    },
                  ),
                  // Content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Owner badge for group notes
                          if (isGroup)
                            widget.note['owner'] == currentUserEmail
                                ? const SizedBox.shrink()
                                : TweenAnimationBuilder<double>(
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeOut,
                                    tween: Tween(begin: 0.0, end: 1.0),
                                    builder: (context, value, child) {
                                      return Transform.translate(
                                        offset: Offset(0, 10 * (1 - value)),
                                        child: Opacity(
                                          opacity: value,
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                        bottom: 8.0,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: ColorConst.groupPrimary
                                            .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: ColorConst.groupPrimary
                                              .withValues(alpha: 0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.person_pin,
                                            size: 15,
                                            color: ColorConst.groupPrimary,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            "${widget.note['owner'].split('@').first.toString().capitalize}",
                                            style: Get.textTheme.bodySmall!
                                                .copyWith(
                                                  color:
                                                      ColorConst.groupPrimary,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 11,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                          TweenAnimationBuilder<double>(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeOut,
                            tween: Tween(begin: 0.0, end: 1.0),
                            builder: (context, value, child) {
                              return Transform.translate(
                                offset: Offset(0, 15 * (1 - value)),
                                child: Opacity(opacity: value, child: child),
                              );
                            },
                            child: Linkify(
                              text:
                                  widget.note['text'] ??
                                  widget.note['resolved_text'] ??
                                  '',
                              style: Get.textTheme.bodyMedium!.copyWith(
                                height: 1.5,
                                color: Colors.grey.shade800,
                              ),
                              onOpen: (link) async {
                                final uri = Uri.parse(link.url);
                                await launchUrl(uri);
                              },
                              linkStyle: Get.textTheme.bodyMedium!.copyWith(
                                color: Colors.blue.shade600,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.blue.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Footer with timestamp and actions
                          TweenAnimationBuilder<double>(
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeOut,
                            tween: Tween(begin: 0.0, end: 1.0),
                            builder: (context, value, child) {
                              return Opacity(opacity: value, child: child);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      child: Icon(
                                        loading
                                            ? Icons.access_time
                                            : failed
                                            ? Icons.error_outline
                                            : Icons.done,
                                        key: ValueKey(widget.status),
                                        size: 14,
                                        color: failed
                                            ? Colors.red.shade400
                                            : loading
                                            ? Colors.amber.shade600
                                            : Colors.grey.shade400,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      CustomWidgets().formatNoteTime(
                                        widget.note['created_at'],
                                      ),
                                      style: Get.textTheme.bodySmall!.copyWith(
                                        color: failed
                                            ? Colors.red.shade400
                                            : loading
                                            ? Colors.amber.shade600
                                            : Colors.grey.shade500,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                                if (widget.note['owner'] == currentUserEmail)
                                  AnimatedOpacity(
                                    duration: const Duration(milliseconds: 300),
                                    opacity: loading ? 0.3 : 1.0,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: PopupMenuButton(
                                        // padding: EdgeInsets.zero,
                                        enabled: !loading,
                                        menuPadding: EdgeInsets.zero,
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        elevation: 8,
                                        icon: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.more_horiz,
                                            color: Colors.grey.shade700,
                                            size: 20,
                                          ),
                                        ),
                                        itemBuilder: (context) => [
                                          PopupMenuItem(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 8,
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(
                                                    8,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue.shade50,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  child: Icon(
                                                    Icons.edit_outlined,
                                                    size: 18,
                                                    color: Colors.blue.shade600,
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Text(
                                                  'Edit',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey.shade800,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            onTap: () async {
                                              controller.textController.text =
                                                  widget.note['text'] ??
                                                  widget
                                                      .note['resolved_text'] ??
                                                  '';
                                              controller.noteTexts.value =
                                                  widget.note['text'] ??
                                                  widget
                                                      .note['resolved_text'] ??
                                                  '';
                                              controller.editingNoteId =
                                                  widget.note['note_id'];
                                              controller.focusNode
                                                  .requestFocus();
                                              controller.isEditingNote.value =
                                                  true;
                                            },
                                          ),
                                          PopupMenuItem(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 8,
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(
                                                    8,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.red.shade50,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  child: Icon(
                                                    Icons.delete_outline,
                                                    size: 18,
                                                    color: Colors.red.shade600,
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.red.shade600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            onTap: () async {
                                              bool result =
                                                  await CustomWidgets.customAlertBox(
                                                    title: 'Delete note',
                                                    content:
                                                        'Are you sure you want to delete this note?',
                                                  );
                                              if (result == true) {
                                                controller.deleteNote(
                                                  noteId:
                                                      widget.note['note_id'],
                                                  groupId: widget.groupId,
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
