import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class FullScreenVideoPage extends StatefulWidget {

  final String youtubeVideoId;
  FullScreenVideoPage({required this.youtubeVideoId});

  @override
  _FullScreenVideoPageState createState() => _FullScreenVideoPageState();
}

class _FullScreenVideoPageState extends State<FullScreenVideoPage> {

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition for WebView to launch external apps
    if (WebView.platform == SurfaceAndroidWebView()) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  void launchYouTubeApp() async {
    final url = 'https://www.youtube.com/watch?v=${widget.youtubeVideoId}';
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        initialUrl: 'https://www.youtube.com/embed/${widget.youtubeVideoId}?autoplay=1',
        javascriptMode: JavascriptMode.unrestricted,
        navigationDelegate: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            // Launch YouTube app for YouTube URLs
            launchYouTubeApp();
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
        gestureNavigationEnabled: true,
      ),
    );
  }
}
