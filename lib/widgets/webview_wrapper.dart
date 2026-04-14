// ─── webview_wrapper.dart ─────────────────────────────────────────────────────
// Reusable WebView widget that loads an asset HTML artifact,
// shows ArtifactLoader while loading, and registers the JS bridge.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../models/artifact_models.dart';
import '../services/artifact_service.dart';
import '../services/web_bridge.dart';
import 'artifact_loader.dart';

class WebViewWrapper extends ConsumerStatefulWidget {
  final ArtifactType type;
  final Map<String, dynamic>? injectedData;

  const WebViewWrapper({
    super.key,
    required this.type,
    this.injectedData,
  });

  @override
  ConsumerState<WebViewWrapper> createState() => _WebViewWrapperState();
}

class _WebViewWrapperState extends ConsumerState<WebViewWrapper> {
  WebViewController? _controller;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  Future<void> _initWebView() async {
    final service = ArtifactService();
    final html = await service.loadArtifactHtml(
      widget.type,
      data: widget.injectedData,
    );

    final controller = service.buildController(htmlContent: html);

    if (!mounted) return;
    WebBridge.registerChannels(controller, ref, context);

    controller.setNavigationDelegate(
      NavigationDelegate(
        onPageFinished: (_) {
          if (mounted) setState(() => _loading = false);
        },
      ),
    );

    if (mounted) {
      setState(() => _controller = controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return ArtifactLoader(
          title: widget.type.title, emoji: widget.type.emoji);
    }
    return Stack(
      children: [
        WebViewWidget(controller: _controller!),
        if (_loading)
          Positioned.fill(
            child: Container(
              color: Colors.white,
              child: ArtifactLoader(
                  title: widget.type.title, emoji: widget.type.emoji),
            ),
          ),
      ],
    );
  }
}
