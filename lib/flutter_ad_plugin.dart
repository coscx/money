
import 'dart:async';

import 'package:flutter/services.dart';

class FlutterAdPlugin {
  static const MethodChannel _channel =
      const MethodChannel('flutter_ad_plugin');

  static Future< Map<String ,dynamic>> get platformVersion async {
    var version = await _channel.invokeMethod('getPlatformVersion', {
      'cid': "cid",
    });
    return Map.from(version);
  }
  static Future< Map<String ,dynamic>> get init async {
    var version = await _channel.invokeMethod('init', {
    'cid': "cid",
    });
    return Map.from(version) ;
  }
  static Future< Map<String ,dynamic>> get jumpAdList async {
    var version = await _channel.invokeMethod('jumpAdList', {
      'cid': "cid",
    });
    return Map.from(version) ;
  }
}
