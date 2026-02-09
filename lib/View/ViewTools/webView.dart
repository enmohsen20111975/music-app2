import 'dart:async';

import 'package:Khotab_Encyclopedia/Controllers/playercontroller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class viewWebPage extends GetView<PlayerController> {
  final String webUrl;
  final _webViewController = Completer<WebViewController>();
  String _htmlContent = '';
  var webcontroller = WebViewController();
  String jsScrollingCode = '''
      await new Promise(resolve => {
        let totalHeight = 0;
        let distance = 100;
        let timer = setInterval(() => {
          let scrollHeight = document.body.scrollHeight;
          window.scrollBy(0, distance);
          totalHeight += distance;

          if(totalHeight >= scrollHeight){
            clearInterval(timer);
            resolve();
          }
        }, 200);
      });
    ''';
  viewWebPage(this.webUrl);

  @override
  Widget build(BuildContext context) {
    webcontroller.clearCache();
    webcontroller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onPageFinished: (url) async {
            final cont = await _webViewController.future;
            final html =
                await cont.runJavaScriptReturningResult(jsScrollingCode);

            _htmlContent = html.toString();
            print(html);
          },
        ),
      )
      ..loadRequest(Uri.parse(webUrl));

    return Visibility(
        child: Scaffold(
      body: WebViewWidget(
        controller: webcontroller,
      ),
    ));
  }
}
