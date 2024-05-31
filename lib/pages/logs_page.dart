import 'package:fclashv2/models/clash/log.dart';
import 'package:fclashv2/providers/clash/logs_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class LogsPage extends ConsumerStatefulWidget {
  const LogsPage({super.key});

  @override
  ConsumerState<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends ConsumerState<LogsPage> {
  List<ClashLog> _cache = [];
  @override
  Widget build(BuildContext context) {
    final _logLevels = LogLevel.values;
    final filteredLogs = ref.watch(filteredLogsProvider);
    final filter = ref.watch(logsFilterNotifierProvider);
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(55),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: TextField(
                      decoration: InputDecoration(border: OutlineInputBorder()),
                      onChanged: (val) => ref
                          .read(logsFilterNotifierProvider.notifier)
                          .updateQuery(val),
                    ),
                  ),
                ),
                ToggleButtons(
                  isSelected: _logLevels.map((l) => l == filter.level).toList(),
                  children: _logLevels.map((l) => Text(l.value)).toList(),
                  onPressed: (idx) => ref
                      .read(logsFilterNotifierProvider.notifier)
                      .updateLevel(_logLevels[idx]),
                )
              ],
            )),
        body: filteredLogs.when(
          loading: () => _buildLogsBoard(_cache),
          error: (_, __) => _buildLogsBoard(_cache),
          data: (logs) {
            _cache = logs;
            return _buildLogsBoard(_cache);
          },
        ));
  }

  Padding _buildLogsBoard(List<ClashLog> logs) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: ListView.separated(
        itemCount: logs.length,
        itemBuilder: (context, idx) {
          final res = logs[idx];
          final payload = res.payload;
          final level = res.level;
          final time = res.time;
          return ListTile(
            leading: Text(level.value),
            title: Text(payload),
            subtitle: Text(DateFormat("hh:mm:ss").format(time)),
          );
        },
        separatorBuilder: (context, _) => Divider(
          thickness: 1,
        ),
      ),
    );
  }
}
