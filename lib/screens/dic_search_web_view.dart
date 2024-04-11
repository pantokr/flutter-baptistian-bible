import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DicSearchWebView extends StatefulWidget {
  final url;
  final title;
  const DicSearchWebView({super.key, this.url, this.title});

  @override
  State<DicSearchWebView> createState() => _DicSearchWebViewState();
}

class _DicSearchWebViewState extends State<DicSearchWebView> {
  WebViewController? _webViewController;
  String url = '';
  String title = '';
  @override
  void initState() {
    super.initState();

    _webViewController = WebViewController()
      ..loadRequest(Uri.parse(widget.url))
      ..setJavaScriptMode(JavaScriptMode.unrestricted);

    url = widget.url;
    title = widget.title;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: WebViewWidget(controller: _webViewController!),
    );
  }
}
