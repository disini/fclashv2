import 'package:fclashv2/models/clash/log.dart';

class LogFilter {
  final LogLevel level;
  final String query;

  LogFilter({this.level = LogLevel.all, this.query = ""});

  LogFilter copyWith({LogLevel? level, String? query}) => LogFilter(
        level: level ?? this.level,
        query: query ?? this.query,
      );
}
