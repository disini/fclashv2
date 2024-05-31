import 'dart:convert';

import 'package:fclashv2/models/clash/connections.dart';
import 'package:fclashv2/providers/clash/connections_provider.dart';
import 'package:fclashv2/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class connectionsPage extends ConsumerStatefulWidget {
  const connectionsPage({super.key});

  @override
  ConsumerState<connectionsPage> createState() => _connectionsPageState();
}

class _connectionsPageState extends ConsumerState<connectionsPage> {
  late final horScrollController = ScrollController();
  List<ClashConnection> _cache = [];
  @override
  Widget build(BuildContext context) {
    final filteredconnectionsections = ref.watch(filteredConnectionsProvider);
    //final unfilteredConnections = ref.watch(connectionsNotifierProvider);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                  onChanged: (val) {
                    ref
                        .read(connectionsFilterNotifierProvider.notifier)
                        .updateQuery(val);
                  },
                ),
              ),
              const SizedBox(width: 5),
              IconButton(
                onPressed: ref
                    .read(connectionsNotifierProvider.notifier)
                    .killAllConnections,
                icon: Icon(Icons.cancel_rounded),
              ),
            ],
          ),
        ),
      ),
      body: filteredconnectionsections.when(
        loading: () {
          return _buildConnectionsBoard(horScrollController, _cache, ref);
        },
        error: (error, stack) {
          return _buildConnectionsBoard(horScrollController, _cache, ref);
        },
        data: (connections) {
          _cache = connections;
          return _buildConnectionsBoard(horScrollController, _cache, ref);
        },
      ),
    );
  }

  LayoutBuilder _buildConnectionsBoard(ScrollController horScrollController,
      List<ClashConnection> connections, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Scrollbar(
          controller: horScrollController,
          child: SingleChildScrollView(
            controller: horScrollController,
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: Table(
                  border: const TableBorder(
                    verticalInside: BorderSide(width: 0.05),
                  ),
                  columnWidths: const {
                    0: FixedColumnWidth(40),
                    1: FixedColumnWidth(40),
                    2: FixedColumnWidth(90),
                    3: FixedColumnWidth(90),
                    4: FixedColumnWidth(200),
                    5: FixedColumnWidth(80),
                    6: FixedColumnWidth(150),
                    7: FixedColumnWidth(390),
                    8: FixedColumnWidth(110),
                    9: FixedColumnWidth(110),
                    10: FixedColumnWidth(95),
                    11: FixedColumnWidth(95),
                    12: FixedColumnWidth(80),
                    13: FixedColumnWidth(90),
                    14: FixedColumnWidth(90),
                    15: FixedColumnWidth(110),
                    16: FixedColumnWidth(120),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: () {
                    List<TableRow> children = [
                      TableRow(
                          children: [
                        "详情",
                        "关闭",
                        "类型",
                        "进程",
                        "主机",
                        "嗅探域名",
                        "规则",
                        "链路",
                        "下载速度",
                        "上传速度",
                        "下载量",
                        "上传量",
                        "连接时间",
                        "源地址",
                        "源端口",
                        "目标地址",
                        "入站用户"
                      ].map((e) => Center(child: _Text(e))).toList())
                    ];
                    for (var i = 0; i < (connections.length); i++) {
                      final c = connections[i];
                      children.add(TableRow(
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer
                                  .withOpacity(i.isOdd ? 0.6 : 1)),
                          children: [
                            IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        final navi = Navigator.of(context);
                                        return AlertDialog(
                                          title: Align(
                                            alignment: Alignment.centerLeft,
                                            child: IconButton(
                                                onPressed: () => navi.pop(),
                                                icon: const Icon(
                                                    Icons.arrow_back)),
                                          ),
                                          alignment: Alignment.center,
                                          content: _Text(
                                            const JsonEncoder.withIndent('  ')
                                                .convert(c),
                                          ),
                                        );
                                      });
                                },
                                icon: const Icon(Icons.info)),
                            IconButton(
                                onPressed: () => ref
                                    .read(connectionsNotifierProvider.notifier)
                                    .killSingleConnection(c.id ?? ""),
                                icon: const Icon(Icons.cancel)),
                            _Text(
                                "${c.metadata?.type}(${c.metadata?.network})"),
                            _Text(c.metadata?.process),
                            _Text(c.metadata?.host),
                            _Text(c.metadata?.sniffHost),
                            _Text("${c.rule}::${c.rulePayload}"),
                            _Text(c.chains?.join("::")),
                            _Text(Utils.parseByte(
                                _getSpeed(
                                  c.download,
                                  c.start,
                                ),
                                suffix: "/s")),
                            _Text(Utils.parseByte(_getSpeed(c.upload, c.start),
                                suffix: "/s")),
                            _Text(Utils.parseByte(c.download?.toDouble() ?? 0)),
                            _Text(Utils.parseByte(c.upload?.toDouble() ?? 0)),
                            _Text(DateTime.now().difference(c.start!).inHours <
                                    1
                                ? DateTime.now()
                                            .difference(
                                                c.start ?? DateTime.now())
                                            .inMinutes <
                                        1
                                    ? "${DateTime.now().difference(c.start ?? DateTime.now()).inSeconds}秒"
                                    : "${DateTime.now().difference(c.start ?? DateTime.now()).inMinutes}分钟"
                                : "${DateTime.now().difference(c.start ?? DateTime.now()).inHours}小时"),
                            _Text(c.metadata?.sourceIP),
                            _Text(c.metadata?.sourcePort),
                            _Text(c.metadata?.remoteDestination),
                            _Text(c.metadata?.inboundName),
                          ]
                              .map((e) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Center(child: e)))
                              .toList()));
                    }
                    return children;
                  }(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _getSpeed(int? byte, DateTime? start) {
    byte ??= 0;
    final now = DateTime.now();
    final period = now.difference(start ?? now).inSeconds;
    if (period == 0) return 0.0;
    return byte.toDouble() / period;
  }
}

class _Text extends StatelessWidget {
  _Text(
    this.text,
  );
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Text(text ?? "-");
  }
}
