// ─── web_bridge.dart ─────────────────────────────────────────────────────────
// Registers named JS channels so WebView pages can call back into Flutter.
// Usage: add WebBridge.channels(ref, context) to your WebViewController.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../providers/user_provider.dart';

class WebBridge {
  static void registerChannels(
    WebViewController controller,
    WidgetRef ref,
    BuildContext context,
  ) {
    controller.addJavaScriptChannel(
      'Flutter',
      onMessageReceived: (msg) => _handleMessage(msg.message, ref, context),
    );
  }

  static void _handleMessage(String msg, WidgetRef ref, BuildContext context) {
    if (msg.startsWith('xp:')) {
      final amount = int.tryParse(msg.split(':').last) ?? 0;
      ref.read(userProgressProvider.notifier).addXP(amount);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('+$amount XP earned! 🎉'),
          backgroundColor: const Color(0xFF6C63FF),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    } else if (msg == 'quiz:complete') {
      ref.read(userProgressProvider.notifier).addXP(200);
    }
  }
}
