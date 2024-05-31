library themes;

import 'package:fclashv2/themes/blue.dart';
import 'package:fclashv2/themes/red_wine.dart';
import 'package:flutter/material.dart';
export 'package:fclashv2/themes/red_wine.dart';
export 'package:fclashv2/themes/blue.dart';

abstract class GetTheme {
  ThemeData get light;
  ThemeData get dark;
  const GetTheme();
}

enum MyThemes {
  blue(Colors.blue),
  red(Colors.red);

  final Color color;

  const MyThemes(this.color);

  GetTheme get theme {
    switch (this) {
      case blue:
        return Blue();
      case red:
        return RedWine();
      default:
        return Blue();
    }
  }
}
