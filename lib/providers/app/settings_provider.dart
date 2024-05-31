import 'dart:convert';

import 'package:fclashv2/models/app/settings.dart';
import 'package:fclashv2/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fclashv2/utils/persistence.dart';

part 'settings_provider.g.dart';

@riverpod
class AppSettingsNotifier extends _$AppSettingsNotifier {
  AppSettings build() {
    final cache = Per.prefs.getString("appSettings");
    if (cache == null) {
      final settings = AppSettings.fromJson({});
      Per.prefs.setString("appSettings", jsonEncode(settings.toJson()));
      return settings;
    }
    return AppSettings.fromJson(jsonDecode(cache));
  }

  void updateTheme(MyThemes theme) {
    state = state.copyWith(theme: theme);
    _save();
  }

  void updateThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
    _save();
  }

  void _save() {
    Per.prefs.setString("appSettings", jsonEncode(state.toJson()));
  }
}
