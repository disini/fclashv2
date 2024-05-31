import 'dart:convert';

import 'package:fclashv2/models/clash/connections.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:fclashv2/utils/api.dart';
import 'package:fuzzywuzzy/ratios/partial_ratio.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connections_provider.g.dart';

@riverpod
class ConnectionsNotifier extends _$ConnectionsNotifier {
  @override
  Stream<ClashConnections> build() async* {
    final channel =
        WebSocketChannel.connect(Uri.parse("${Api.wsAddress}/connections"));
    await for (var rawJson in channel.stream) {
      yield ClashConnections.fromJson(jsonDecode(rawJson));
    }
  }

  Future<void> killAllConnections() async =>
      await Api.req.delete("/connections");

  Future<void> killSingleConnection(String id) async =>
      await Api.req.delete("/connections/$id");
}

@riverpod
class ConnectionsFilterNotifier extends _$ConnectionsFilterNotifier {
  @override
  String build() {
    return "";
  }

  void updateQuery(String q) => state = q;
}

@riverpod
Future<List<ClashConnection>> filteredConnections(
    FilteredConnectionsRef ref) async {
  final rowConnections = ref.watch(connectionsNotifierProvider);
  final filter = ref.watch(connectionsFilterNotifierProvider);
  var didDisposed = false;
  ref.onDispose(() => didDisposed = true);
  await Future<void>.delayed(const Duration(milliseconds: 500));
  if (didDisposed) {
    throw Exception("Canceled");
  }
  return rowConnections.when(
    loading: () => [],
    error: (_, __) => [],
    data: (conns) {
      if (filter.trim().isEmpty) {
        return conns.connections ?? [];
      }
      return extractAll(
              query: filter,
              ratio: PartialRatio(),
              cutoff: 30,
              choices: conns.connections ?? [],
              getter: (c) => jsonEncode(c.toJson()))
          .map<ClashConnection>((res) => res.choice)
          .toList();
    },
  );
}
