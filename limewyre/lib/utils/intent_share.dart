import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class IntentShare {
  static String? sharedText;
  static List<String>? sharedFiles;
  static bool cameFromShare = false;

  static void setFromShare({String? text, List<String>? files}) {
    sharedText = text;
    sharedFiles = files;
    cameFromShare = true;
  }

  static void clear() {
    sharedText = null;
    sharedFiles = null;
    cameFromShare = false;
  }
}

const _shareChannel = MethodChannel('limewyre/share');

void initShareListener() {
  _shareChannel.setMethodCallHandler((call) async {
    if (call.method == 'sharedData') {
      final Map data = Map.from(call.arguments);

      final type = data['type'];
      final value = data['value'];

      if (type == 'text') {
        IntentShare.setFromShare(text: value);
      } else if (type == 'file') {
        IntentShare.setFromShare(files: [value]);
      } else if (type == 'files') {
        IntentShare.setFromShare(files: List<String>.from(value));
      }
      _navigateToNotePage();
    }
  });
}

void _navigateToNotePage() {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    // Navigator.of(context).popUntil((route) => route.isFirst);
    Get.toNamed('/splash', arguments: {'fromShare': true});
  });
}
