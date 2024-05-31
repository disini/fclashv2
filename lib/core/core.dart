import 'dart:io';

import 'package:flutter/services.dart';

class CoreController {
  static bool vpnEnabled = false;
  static const MethodChannel _channel =
      MethodChannel('cn.mapleafgo/socks_vpn_plugin');

  static Future<void> startVpn() async {
    await _channel.invokeMethod('startVpn');
    vpnEnabled = true;
  }

  static Future<void> stopVpn() async {
    await _channel.invokeMethod('stopVpn');
    vpnEnabled = false;
  }

  static Future<bool?> startService() {
    return _channel.invokeMethod<bool>('startService');
  }

  static Future<bool?> setConfig(String path) {
    return _channel.invokeMethod<bool>('setConfig', {"config": path});
  }

  static Future<bool?> setHomeDir(Directory dir) {
    return _channel.invokeMethod<bool>('setHomeDir', {"dir": dir.path});
  }

  static Future<String?> startRust(String addr) {
    return _channel.invokeMethod<String>('startRust', {"addr": addr});
  }

  static Future<bool?> verifyMMDB(String path) {
    return _channel.invokeMethod<bool>('verifyMMDB', {"path": path});
  }
}
