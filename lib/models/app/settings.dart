import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fclashv2/themes/themes.dart';

part 'settings.freezed.dart';
part 'settings.g.dart';

@freezed
class AppSettings with _$AppSettings {
  factory AppSettings({
    @JsonKey(defaultValue: MyThemes.blue) required MyThemes theme,
    @JsonKey(defaultValue: ThemeMode.system) required ThemeMode themeMode,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, Object?> json) =>
      _$AppSettingsFromJson(json);
}
