import 'package:flutter/material.dart';
import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Permission.camera.request();

  runApp(const MyApp());
}

late WebViewController _controller;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeepConnect',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _resumeApp() {
    _controller.evaluateJavascript("onResumeApp();");
  }
  
  void _returnApp() {
    _controller.evaluateJavascript("onReturnApp();");
  }

  Future<bool> _isDeepConnectUrl() async {
    final currentUrl = await _controller.currentUrl();
    String url = currentUrl.toString().substring(0, 29);
    bool isDeepConnectUrl = url == "https://www.deep-matching.com";
    return isDeepConnectUrl;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.resumed:
        print('lifecycle:resumed');
        _resumeApp();
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: _isDeepConnectUrl(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.data ?? true) {
            return Scaffold(
              body: WebView(
                initialUrl: 'https://deep-matching.com',
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) async {
                  _controller = webViewController;
                },
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                  leading: IconButton(
                    onPressed: () {
                      _returnApp();
                    },
                    icon: Icon(Icons.arrow_back_ios),
                  ),
              ),
              body: WebView(
                initialUrl: 'https://deep-matching.com',
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) async {
                  _controller = webViewController;
                },
              ),
            );
          }
        }
    );
  }
}
