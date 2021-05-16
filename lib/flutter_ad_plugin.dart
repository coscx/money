
import 'dart:async';

import 'package:flutter/services.dart';

class FlutterAdPlugin {

  final MethodChannel _methodChannel;
  final EventChannel _eventChannel;
  static FlutterAdPlugin _instance;

  factory FlutterAdPlugin() {
    if (_instance == null) {
      final MethodChannel methodChannel = const MethodChannel('flutter_ad_plugin');
      final EventChannel eventChannel = const EventChannel('flutter_ad_plugin_event');
      _instance = FlutterAdPlugin.private(methodChannel, eventChannel);
    }
    return _instance;
  }
  FlutterAdPlugin.private(this._methodChannel, this._eventChannel);

  Stream<dynamic> _listener;

  Stream<dynamic> get onBroadcast {
    if (_listener == null) {
      _listener = _eventChannel.receiveBroadcastStream().map((event) {
        return event;
      });
    }
    return _listener;
  }


   Future< Map<String ,dynamic>> get platformVersion async {
    var version = await _methodChannel.invokeMethod('getPlatformVersion', {
      'cid': "cid",
    });
    return Map.from(version);
  }
   Future< Map<String ,dynamic>> get init async {
    var version = await _methodChannel.invokeMethod('init', {
    'cid': "cid",
    });
    return Map.from(version) ;
  }
   Future< Map<String ,dynamic>> get jumpAdList async {
    var version = await _methodChannel.invokeMethod('jumpAdList', {
      'cid': "cid",
    });
    return Map.from(version) ;
  }
}
