import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';

class WebView extends StatefulWidget {
  @override
  WebViewState createState() => WebViewState();
}

class WebViewState extends State<WebView> {
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: 'https://deep-matching.com',
    );
  }
}