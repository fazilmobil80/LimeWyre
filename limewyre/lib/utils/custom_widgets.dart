import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CustomWidgets {
  static Future<bool> customAlertBox({
    required String title,
    required String content,
    bool? barrierDismissible,
    String cancelText = "No, Cancel",
    String confirmText = "Yes, Confirm",
  }) async {
    final result = await Get.dialog(
      barrierDismissible: barrierDismissible ?? false,
      Platform.isIOS
          ? CupertinoAlertDialog(
              title: Text(title),
              content: Text(content, textAlign: TextAlign.center),
              actions: [
                TextButton(
                  onPressed: () => Get.back(result: false),
                  child: Text(cancelText),
                ),
                TextButton(
                  onPressed: () => Get.back(result: true),
                  child: Text(confirmText),
                ),
              ],
            )
          : AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: [
                TextButton(
                  onPressed: () => Get.back(result: false),
                  child: Text(cancelText),
                ),
                TextButton(
                  onPressed: () => Get.back(result: true),
                  child: Text(confirmText),
                ),
              ],
            ),
    );
    return result ?? false;
  }

  String formatNoteTime(int timestampMillis) {
    final DateTime noteTime = DateTime.fromMillisecondsSinceEpoch(
      timestampMillis,
    );
    final DateTime now = DateTime.now();

    final Duration diff = now.difference(noteTime);

    if (diff.inSeconds < 30) {
      return 'Just now';
    }

    if (diff.inMinutes <= 1) {
      return '1 minute ago';
    }

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} minutes ago';
    }

    if (diff.inHours == 1) {
      return '1 hour ago';
    }

    if (diff.inHours < 24) {
      return '${diff.inHours} hours ago';
    }

    final DateTime yesterday = now.subtract(const Duration(days: 1));

    if (noteTime.day == yesterday.day &&
        noteTime.month == yesterday.month &&
        noteTime.year == yesterday.year) {
      return 'yesterday ${DateFormat('hh:mm a').format(noteTime)}';
    }

    if (diff.inDays <= 2) {
      return '${DateFormat('EEEE').format(noteTime)} '
          '${DateFormat('hh:mm a').format(noteTime)}';
    }

    return DateFormat('dd/MM/yy hh:mm a').format(noteTime);
  }
}
