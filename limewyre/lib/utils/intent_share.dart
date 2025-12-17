import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

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

// const _shareChannel = MethodChannel('limewyre/share');

StreamSubscription? _shareSub;

void initShareListener() {
  // App already running / background
  _shareSub = ReceiveSharingIntent.instance.getMediaStream().listen((value) {
    _handleSharedMedia(value);
  });
  // _handleSharedMedia,
  // onError: (err) {
  //   log('Share stream error: $err');
  // },
  // );

  // Cold start (VERY IMPORTANT for iOS)
  ReceiveSharingIntent.instance.getInitialMedia().then((value) {
    if (value.isNotEmpty) {
      _handleSharedMedia(value);
      ReceiveSharingIntent.instance.reset();
    }
  });
}

void disposeShareListener() {
  _shareSub?.cancel();
}

void _handleSharedMedia(List<SharedMediaFile> files) {
  if (files.isEmpty) return;

  // For simplicity, we only handle the first file's path as text.. check the f.type for handling different types.

  final paths = files.map((f) => f.path).toList();

  IntentShare.setFromShare(text: paths.first, files: paths);

  log('Shared files received: $paths');

  _navigateToNotePage();
}

void _navigateToNotePage() {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (Get.currentRoute != '/splash') {
      Get.offAllNamed('/splash', arguments: {'fromShare': true});
    }
  });
}
