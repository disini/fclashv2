import 'dart:convert';

import 'package:fclashv2/models/clash/log.dart';
import 'package:fclashv2/models/clash/log_filter.dart';
import 'package:fclashv2/utils/api.dart';
import 'package:fuzzywuzzy/ratios/partial_ratio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';

part 'logs_provider.g.dart';

@riverpod
class LogsNotifier extends _$LogsNotifier {
  @override
  List<ClashLog> build() {
    final channel =
        WebSocketChannel.connect(Uri.parse("${Api.wsAddress}/logs"));
    channel.stream.listen((rawJson) {
      final log = ClashLog.fromJson(jsonDecode(rawJson));
      state = [log, ...state];
    }, cancelOnError: false);
    return [];
  }
}

@riverpod
class LogsFilterNotifier extends _$LogsFilterNotifier {
  LogFilter build() {
    return LogFilter();
  }

  void updateLevel(LogLevel l) => state = state.copyWith(level: l);

  void updateQuery(String q) => state = state.copyWith(query: q);
}

@riverpod
Future<List<ClashLog>> filteredLogs(FilteredLogsRef ref) async {
  final filter = ref.watch(logsFilterNotifierProvider);
  final logs = ref
      .watch(logsNotifierProvider)
      .where((log) =>
          filter.level == LogLevel.all ? true : log.level == filter.level)
      .toList();
  var didDisposed = false;
  ref.onDispose(() => didDisposed = true);
  await Future<void>.delayed(const Duration(milliseconds: 500));
  if (didDisposed) {
    throw Exception("Canceled");
  }
  if (filter.query.trim().isEmpty) {
    return logs;
  }
  return extractAll(
      ratio: PartialRatio(),
      cutoff: 80,
      query: filter.query,
      choices: logs,
      getter: (log) => log.payload).map((res) => res.choice).toList();
}
