import 'package:flutter/material.dart';
import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Permission.camera.request();

  runApp(const MyApp());
}

late WebViewController _controller;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  final MaterialColor materialWhite = const MaterialColor(
    0xFFFFFFFF,
    const <int, Color>{
      50: const Color(0xFFFFFFFF),
      100: const Color(0xFFFFFFFF),
      200: const Color(0xFFFFFFFF),
      300: const Color(0xFFFFFFFF),
      400: const Color(0xFFFFFFFF),
      500: const Color(0xFFFFFFFF),
      600: const Color(0xFFFFFFFF),
      700: const Color(0xFFFFFFFF),
      800: const Color(0xFFFFFFFF),
      900: const Color(0xFFFFFFFF),
    },
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeepConnect',
      theme: ThemeData(
        primarySwatch: materialWhite,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _launchUrl(String url) async {
    final Uri _url = Uri.parse(url);
    if (await canLaunchUrl(_url)) {
      await launchUrl(_url);
    }
  }

  Future<void> _resumeApp() async {
    await _controller.evaluateJavascript("onResumeApp();");
  }
  
  Future<void> _returnApp() async {
    await _controller.evaluateJavascript("onReturnApp();");
  }

  Future<bool> _isDeepConnectUrl() async {
    final currentUrl = await _controller.currentUrl();
    String url = currentUrl.toString().substring(0, 29);
    return url == "https://www.deep-matching.com";
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.resumed:
        print('lifecycle:resumed');
        await _resumeApp();
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        initialUrl: 'https://deep-matching.com',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) async {
          _controller = webViewController;
        },
        navigationDelegate: (NavigationRequest request) {
          String wwwUrl = request.url.toString().substring(0, 29);
          String url = request.url.toString().substring(0, 25);
          bool isDeepConnectUrl = wwwUrl == 'https://www.deep-matching.com' || url == 'https://deep-matching.com';
          if (isDeepConnectUrl) {
            return NavigationDecision.navigate;
          } else {
            _launchUrl(request.url);
            return NavigationDecision.prevent;
          }
        },
      ),
    );
  }
}
