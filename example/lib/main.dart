import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_ad_plugin/flutter_ad_plugin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    Map<String ,dynamic> platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // try {
    //   platformVersion = await FlutterAdPlugin.platformVersion;
    // } on PlatformException {
    //  // platformVersion = 'Failed to get platform version.';
    // }
    try {
      platformVersion = await FlutterAdPlugin.init;
    } on PlatformException {
     // platformVersion = 'Failed to init.';
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      //_platformVersion = platformVersion[''];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('Running on: $_platformVersion\n'),

              IconButton(icon: Icon(
                Icons.backup,
              ), onPressed:() async {
                try {
                  await FlutterAdPlugin.jumpAdList;
                } on PlatformException {
                  // platformVersion = 'Failed to init.';
                }

              })
            ],
          ),
        ),
      ),
    );
  }
}
