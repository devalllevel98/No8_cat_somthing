import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
class WebViewScreen extends StatelessWidget {
  final String initialUrl;
  WebViewScreen({required this.initialUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 40),
        child: WebView(
          initialUrl: initialUrl,
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest request) {
            if (request.url.contains("//t.me") || request.url.contains("//chat")) {
              print(request.url);
               launch(request.url, forceSafariVC: false, forceWebView: false);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      ),
    );
  }
}
// webview_flutter: ^2.0.13 