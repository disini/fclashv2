import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'log.freezed.dart';
part 'log.g.dart';

@JsonEnum(valueField: "value")
enum LogLevel {
  all("all"),
  info("info"),
  warning("warning"),
  error("error");

  final String value;

  const LogLevel(this.value);
}

@freezed
class ClashLog with _$ClashLog {
  factory ClashLog({
    @JsonKey(name: "payload") required String payload,
    @JsonKey(
        includeToJson: false,
        includeFromJson: true,
        fromJson: ClashLog._handleTime)
    required DateTime time,
    @JsonKey(name: "type") required LogLevel level,
  }) = _ClashLog;

  factory ClashLog.fromJson(Map<String, Object?> json) =>
      _$ClashLogFromJson(json);

  static _handleTime(_) => DateTime.now();
}
