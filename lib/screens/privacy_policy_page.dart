import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PrivacyPolicyPage extends StatefulWidget {
   PrivacyPolicyPage({this.url,this.title,super.key});
  String? url;
  String? title;

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  late InAppWebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    WebUri webUrl = WebUri.uri(UriData.fromString(widget.url!).uri);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: webUrl),
        initialOptions: InAppWebViewGroupOptions(
          android: AndroidInAppWebViewOptions(),
          ios: IOSInAppWebViewOptions(),
        ),
        onWebViewCreated: (controller) {
          _webViewController = controller;
        },
      ),
    );
  }
}
