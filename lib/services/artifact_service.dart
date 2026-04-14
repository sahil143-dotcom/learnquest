// ─── artifact_service.dart ────────────────────────────────────────────────────
// Orchestrates communication between Flutter and artifact (HTML) pages.
// Loads HTML from assets and injects JS data bridge.

import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../models/artifact_models.dart';

class ArtifactService {
  // Load an HTML artifact from assets and optionally inject data
  Future<String> loadArtifactHtml(ArtifactType type, {Map<String, dynamic>? data}) async {
    final raw = await rootBundle.loadString(type.assetPath);
    if (data != null) {
      return _injectData(raw, data);
    }
    return raw;
  }

  // Inject a JSON data object into the HTML before BODY closes
  String _injectData(String html, Map<String, dynamic> data) {
    final jsonStr = _mapToJs(data);
    final script = '<script>window.LEARNQUEST_DATA = $jsonStr;</script>';
    return html.replaceFirst('</body>', '$script</body>');
  }

  String _mapToJs(Map<String, dynamic> map) {
    final parts = map.entries.map((e) {
      final val = e.value is String ? '"${e.value}"' : e.value.toString();
      return '"${e.key}": $val';
    });
    return '{${parts.join(', ')}}';
  }

  // Configure a WebViewController with standard settings
  WebViewController buildController({
    required String htmlContent,
    JavaScriptMode jsMode = JavaScriptMode.unrestricted,
    WebResourceErrorCallback? onError,
  }) {
    final controller = WebViewController()
      ..setJavaScriptMode(jsMode)
      ..loadHtmlString(htmlContent);

    if (onError != null) {
      controller.setNavigationDelegate(
        NavigationDelegate(onWebResourceError: onError),
      );
    }

    return controller;
  }
}
