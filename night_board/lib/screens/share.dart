import 'package:social_share_plugin/social_share_plugin.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

class Share extends StatefulWidget {

  @override
  _Share createState() => _Share();
}

class _Share extends State<Share> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  /// initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await SocialSharePlugin.platformVersion;
    } on PlatformException {
      platformVersion = 'Error';
    }
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Share on Social Media'),
        ),
        body: Column(
          children: <Widget>[
            Center(
              child: Text(''),
            ),
            RaisedButton(
              child: Text('Instagram'),
              onPressed: () async {
                File file = await ImagePicker.pickImage(source: ImageSource.gallery);
                await SocialSharePlugin.shareToFeedInstagram(path: file.path);
              },
            ),
            RaisedButton(
              child: Text('Facebook'),
              onPressed: () async {
                File file = await ImagePicker.pickImage(source: ImageSource.gallery);
                await SocialSharePlugin.shareToFeedFacebook(path: file.path,
                    onSuccess: (_) {
                      print('FACEBOOK SUCCESS');
                      return;
                    },
                    onCancel: () {
                      print('FACEBOOK CANCELLED');
                      return;
                    },
                    onError: (error) {
                      print('FACEBOOK ERROR $error');
                      return;
                    });
              },
            ),
            ///unable to test; no twitter account
            RaisedButton(
              child: Text('Twitter'),
              onPressed: () async {
                String url = 'https://flutter.dev/';
                final text =
                    'Brought to you by Flutter!';
                final result = await SocialSharePlugin.shareToTwitterLink(
                    text: text,
                    url: url,
                    onSuccess: (_) {
                      print('TWITTER SUCCESS');
                      return;
                    },
                    onCancel: () {
                      print('TWITTER CANCELLED');
                      return;
                    });
                print(result);
              },
            ),
          ],
        ),
      ),
    );
  }
}
