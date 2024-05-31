import 'dart:math';

import 'package:fclashv2/models/clash/proxies.dart';
import 'package:flutter/material.dart';

class Utils {
  static const _unit = ["B", "KB", "MB", "GB", "TB"];

  /// byte -> human-readable format
  static String parseByte(double b, {String? suffix, int fixed = 1}) {
    suffix = suffix ?? "";
    if (b < 1024.0) return "${b.toStringAsFixed(fixed)}${_unit[0]}$suffix";
    final int i = (log(b) / log(1024)).floor();
    return "${(b / pow(1024, i)).toStringAsFixed(fixed)}${_unit[i]}$suffix";
  }

  /// delay -> color
  static Color parseDelay(int? delay) {
    delay ??= delayInfinity;
    return delay >= 1000
        ? Colors.red
        : delay >= 800
            ? Colors.yellow
            : delay >= 600
                ? Colors.orange
                : delay >= 400
                    ? Colors.blue
                    : Colors.green;
  }
}
